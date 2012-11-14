//
//  DrawVC.m
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawVC.h"

#import "FbGraph.h"
#import "SBJSON.h"
#import "FbGraphFile.h"

#import "DragView.h"
#import "SoundEffect.h"
#import "PaintingMacros.h"
#import "Three20.h"
#import "Brush.h"
#import "UIViewAdditions.h"

#import "FTAnimation.h"
#import "GlobalSettings.h"
#import "BrushColorPicker.h"
#import "DropDownView.h"
#import "NSOperationQueue+CWSharedQueue.h"

#import "DownloadOperation.h"
#import "BrushSliderView.h"
#import "PaintingView.h"

#define POST_URL @"http://220.225.234.204:6061/Pathways/Uploadphoto.aspx?" 
#import "PathwaysAppDelegate.h"
#import "GalleryPhoto.h"
#import "RegisterVC.h"
#import "GalleriesVC.h"
//CONSTANTS:

#define kPaletteHeight			30
#define kPaletteSize			5
#define kMinEraseInterval		0.5

// Padding for margins
#define kLeftMargin				1.0
#define kTopMargin				10.0
#define kRightMargin			10.0


//Social N/W

#define kOAuthConsumerKey				@"3Dq3DxL7wKpFoqo4zgCLcQ"		
#define kOAuthConsumerSecret			@"pmOAnLyVaYxevATotNsIOpb0CH9FGd58seA8reKrhk"

#define FBkOAuthConsumerKey			@"287225a9641de0cfa6abc39e4c2f20cd"
#define FBkOAuthConsumerSecret		@"686a0f966247d79a17cd34ecf6bb4211"

//#import "SA_OAuthTwitterEngine.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#define kTwitterSettingsButtonIndex 0

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
static UIImage *highlighted_image = nil;
static UIImage *normal_image = nil;
@interface DrawVC (private)
- (NSUndoManager *)undoManager;
@end

@implementation DrawVC
@synthesize managedObjectContext,editingPhoto;
+(void)initialize
{
	highlighted_image = [[UIImage imageNamed:@"pobut_select.png"] retain];
	normal_image = [[UIImage imageNamed:@"pobut_normal_small.png"] retain];
}

- (NSUndoManager *)undoManager
{
//    BUCoreDataHelper *coreDataHelper = [BUCoreDataHelper sharedInstance];
    NSUndoManager *undoManager = [appDelegete.managedObjectContext undoManager];
    return undoManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    CGRect rect;
    rect = CGRectMake(0, 0, 1024, 768);
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

    appDelegete = (PathwaysAppDelegate *)[UIApplication sharedApplication].delegate;
    
//    self.undoManager = [[NSUndoManager alloc] init];
//    [self.undoManager setLevelsOfUndo:0];
//    
//    [self.undoManager release];

    drawingView = [[DragView alloc] initWithFrame:rect];
    drawingView.userInteractionEnabled = YES;
    drawingView.viewController = self;
    drawingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:drawingView];

    self.view.backgroundColor = [UIColor whiteColor];//colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];

    paintView = [[PaintingView alloc] initWithFrame:rect];
    paintView.viewController = self;
    paintView.userInteractionEnabled = YES;
    paintView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:paintView];
    
    //Adding Gestures
//    [self addGestureRecognizersToPiece:self.view];

    NSBundle *mainBundle = [NSBundle mainBundle];	
    erasingSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Erase" ofType:@"caf"]];
    selectSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Select" ofType:@"caf"]];

    brush = [[Brush alloc] init];

    CGFloat components[3];
//    HSL2RGB(kPaletteSize, kSaturation, kLuminosity, &components[0], &components[1], &components[2]);
//    glColor4f(components[0], components[1], components[2], kBrushOpacity);
    UIColor *bColor = [UIColor colorWithRed:components[1] green:components[1] blue:components[1] alpha:1];
    brush.brushColor = bColor;
    brush.brushSize = [NSNumber numberWithInt:5];
    
    [self performSelector:@selector(updatePaintView)];

//    PathwaysAppDelegate *appDelegate = (PathwaysAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegete.managedObjectContext;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];

    [self setUpPaintToolBar];

}

-(UIImage*)getCurrentImage
{	
    sliderView.hidden = YES;
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImage *resulImage = bgImage;
    
    sliderView.hidden = NO;

    return  resulImage;
}

-(GalleryPhoto*)saveCurrentDrawing 
{
    GalleryPhoto *newPhoto;
    if (self.editingPhoto == nil) 
    {
        NSManagedObjectContext *context = [self  managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"GalleryPhoto" inManagedObjectContext:context];
        newPhoto = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        newPhoto.createdDate = [NSDate date];
        newPhoto.lastModified = [NSDate date];
        NSString *photoName = [NSString stringWithFormat:@"Galley_%f.png",[[NSDate date] timeIntervalSince1970]];
        newPhoto.photoName = photoName;
        
        UIImage *theImage = [self getCurrentImage];
        NSData *theData = UIImagePNGRepresentation(theImage);
        [GlobalSettings saveimageData:theData imageFileName:photoName];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else 
    {
        NSManagedObjectContext *context = [self  managedObjectContext];
        newPhoto = self.editingPhoto;
        newPhoto.lastModified = [NSDate date];
        NSString *photoName = newPhoto.photoName;
        
        UIImage *theImage = [self getCurrentImage];
        NSData *theData = UIImagePNGRepresentation(theImage);
        [GlobalSettings saveimageData:theData imageFileName:photoName];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    return newPhoto;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

    arrayUndo = [[NSMutableArray alloc]init];
    arrayRedo = [[NSMutableArray alloc]init];

    NSMutableArray *leftBarButton = [[NSMutableArray alloc]init];
    UIBarButtonItem *launcherBarButtonItem = [[UIBarButtonItem alloc] initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/launcher.png") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissChild)];
    [leftBarButton addObject:launcherBarButtonItem];

//    if(!editingPhoto)
//    {        
//        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        addButton.frame = CGRectMake(20, 0, 20, 44);
//        [addButton setImage:[UIImage imageNamed:@"addNew.png"] forState:UIControlStateNormal];
//        addButton.showsTouchWhenHighlighted = YES;
//        [addButton addTarget:self action: @selector(addNewPaint) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *itemAddButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
//        [leftBarButton addObject:itemAddButton];
//        
//        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cameraButton.frame = CGRectMake(30, 0, 20, 44);
//        [cameraButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
//        cameraButton.showsTouchWhenHighlighted = YES;
//        [cameraButton addTarget:self action: @selector(changeBackground:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *itemCameraButton = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
//        [leftBarButton addObject:itemCameraButton];
//    }
    
    [self.navigationItem setLeftBarButtonItems:leftBarButton];
    
    
    //setRightBarButtonItem
    
    UIView *rightBarButton = [[UIView alloc] init];
    rightBarButton.frame = CGRectMake(0, 0, 90, 44);
    rightBarButton.backgroundColor = [UIColor clearColor];
    
    UIButton *btnUndo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUndo setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    btnUndo.showsTouchWhenHighlighted = YES;
    btnUndo.tag = 0;
    btnUndo.frame = CGRectMake(0, 0, 40, 44);
//    [btnUndo addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    //[rightBarButton addSubview:btnUndo];
    
//    UIButton *btnRedo = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnRedo setImage:[UIImage imageNamed:@"redo.png"] forState:UIControlStateNormal];
//    btnRedo.showsTouchWhenHighlighted = YES;
//    btnRedo.frame = CGRectMake(30, 0, 20, 44);
//    btnUndo.tag = 0;
//    [btnRedo addTarget:self action:@selector(redo:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBarButton addSubview:btnRedo];
//    
//    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnDelete setImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
//    btnDelete.showsTouchWhenHighlighted = YES;
//    btnDelete.frame = CGRectMake(60, 0, 20, 44);
//    btnUndo.tag = 0;
//    [btnDelete addTarget:self action:@selector(trash:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBarButton addSubview:btnDelete];
    
//    UIBarButtonItem* camera = [[UIBarButtonItem alloc] initWithCustomView:btnUndo];
//    [self.navigationItem setRightBarButtonItem:camera animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(more:)];
    [rightBarButton release];
//    [camera release];
    
    [launcherBarButtonItem release];
    
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self saveSnapShot:drawingView.image];
    [self.view bringSubviewToFront:sliderView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (actMenu)
        [actMenu dismissWithClickedButtonIndex:0 animated:YES];

    [arrayUndo release];
    arrayUndo = nil;
    [arrayRedo release];
    arrayRedo = nil;
    
    [self saveCurrentDrawing];
}

-(void)addNewPaint
{
    drawingView.image = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    
//	CATransition *animation = [CATransition animation];
//	animation.duration = 0.5f;
//	animation.type = kCATransitionPush;
//	animation.subtype = kCATransitionFromBottom;
//	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//	//[drawingView.layer addAnimation:animation forKey:@"Transition"];
//    [self.view.layer addAnimation:animation forKey:@"Transition"];
//
    [[self undoManager] removeAllActions];
    [self.view bringSubviewToFront:paintView];
}

#pragma 
#pragma UNDO MANAGER
//- (void) checkUndoAndUpdateNavBar
//{
//	while ([self.undoManager isUndoing]);
//    
//	if (!self.undoManager.canUndo) 
//		[[self.navigationController.toolbar.items objectAtIndex:4] setValue:[NSNumber numberWithBool:NO] forKey:@"enabled"];
//	else
//    {
////        [[self.navigationController.toolbar.items objectAtIndex:4] setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
////        [[self.navigationController.toolbar.items objectAtIndex:5] setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
////        [[self.navigationController.toolbar.items objectAtIndex:7] setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
//    }
//}

-(void)setImage:(UIImage*)newImage
{
    if (imgNew != newImage) 
    {
        NSLog(@"undo/redo");
        [[[self undoManager] prepareWithInvocationTarget:self] removeImage:imgNew];
        //[self performSelector:@selector(checkUndoAndUpdateNavBar)];
        [imgNew release];
        imgNew = [newImage retain];
    }
}

-(void)removeImage:(UIImage*)newImg
{
    [[self undoManager] registerUndoWithTarget:self selector:@selector(setImage:) object:drawingView.image];
}

#pragma mark ScreenShot
-(void)saveSnapShot:(UIImage*)topImage
{
    UIGraphicsBeginImageContext(drawingView.bounds.size);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    [drawingView.image drawInRect:drawingView.frame blendMode:kCGBlendModeNormal alpha:1.0];
    [topImage drawInRect:drawingView.frame blendMode:kCGBlendModeNormal alpha:1.0];
    drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    [[self undoManager] registerUndoWithTarget:drawingView selector:@selector(setImage:) object:drawingView.image];
//    [self performSelector:@selector(checkUndoAndUpdateNavBar)];
    UIGraphicsEndImageContext();
    [arrayUndo addObject: [self getCurrentImage]];
    [arrayRedo removeAllObjects];
    [self.view bringSubviewToFront:sliderView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [NSThread detachNewThreadSelector:@selector(dropDownViewButtonActios:) toTarget:self withObject:nil];
    
    NSLog(@"testing");
    UIGraphicsBeginImageContext(drawingView.bounds.size);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    [drawingView.image drawInRect:drawingView.bounds];
    
    drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.undoManager registerUndoWithTarget:drawingView selector:@selector(setImage:) object:drawingView.image];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"Keep Moving");
    CGPoint currentPoint = [[touches anyObject] locationInView:drawingView];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:drawingView];
    
    UIGraphicsBeginImageContext(drawingView.bounds.size);
    
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    [drawingView.image drawInRect:drawingView.bounds];
    
    UIBezierPath *aPath =  [UIBezierPath bezierPath];
    [aPath moveToPoint:prevPoint];
    [aPath addLineToPoint:currentPoint];
    
    aPath.lineJoinStyle = kCGLineJoinRound;
    aPath.lineCapStyle = kCGLineCapRound; 
    aPath.lineWidth = [brush.brushSize floatValue]*3;
    aPath.flatness = 0.1;
    aPath.usesEvenOddFillRule = YES;
    CGFloat pattern[2] = { 100, 100};
    [aPath setLineDash:pattern count:2 phase:0.999];
    [aPath closePath];
    [aPath strokeWithBlendMode:kCGBlendModeClear alpha:0];
   
    drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void) touchesEnded:(NSSet *)touches withEvent: (UIEvent *) event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:drawingView];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:drawingView];
    
    UIGraphicsBeginImageContext(drawingView.bounds.size);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    [drawingView.image drawInRect:drawingView.bounds];
    
    UIBezierPath *aPath =  [UIBezierPath bezierPath];
    [aPath moveToPoint:prevPoint];
    [aPath addLineToPoint:currentPoint];
    
    aPath.lineJoinStyle = kCGLineJoinRound;
    aPath.lineCapStyle = kCGLineCapRound;    
    aPath.lineWidth = [brush.brushSize floatValue]*3;
    aPath.flatness = 0.01;
//    aPath.usesEvenOddFillRule = YES;
//    CGFloat pattern[2] = { 10000, 1000 };
//    [aPath setLineDash:pattern count:2 phase:0.0];
    
    [aPath closePath];
    [aPath strokeWithBlendMode:kCGBlendModeClear alpha:1];
   
    drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  

    NSLog(@"testing");
    
    [self.undoManager registerUndoWithTarget:self selector:@selector(setImage:) object:drawingView.image];
}

- (void) touchesCancelled:(NSSet *)touches withEvent: (UIEvent *) event
{
    
}

////////////////////////////////////////////////////////////

-(void)setUpPaintToolBar
{

	CGPoint bPoint = CGPointMake(5, 25);
	
	NSMutableArray *mA = [[NSMutableArray alloc] initWithCapacity:10];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    [mA addObject:item];
    
    for (int index=0; index<6; index++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"paint%d.png",index]];
		CGRect frame = CGRectMake(bPoint.x, bPoint.y, image.size.width, 30);
        
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:image forState:UIControlStateNormal];
		button.showsTouchWhenHighlighted = YES;
        SEL action = @selector(toolBarButtonActions:);
        button.tag = index;
		button.frame = frame;
		[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
		item.target = self; 
		item.action = action;
		
		[mA addObject:item];
		[item release];
    }

    [self.navigationController setToolbarHidden:NO animated:YES];
    [self setToolbarItems:mA animated:YES];
    
    UIToolbar *bottomBar = self.navigationController.toolbar;
    bottomBar.barStyle = UIBarStyleBlack;
    
    brushSliderView = [[BrushSliderView alloc] initWithFrame:CGRectMake(-80, 175, 200, 30)];
    brushSliderView.brushSliderDelegate = self;
    brushSliderView.backgroundColor = [UIColor clearColor];
//    brushSliderView.hidden = YES;
    [brushSliderView setBrush:brush];
    brushSliderView.transform = CGAffineTransformRotate(brushSliderView.transform,RADIANS(270.0));
    [sliderView addSubview:brushSliderView];
    [sliderView bringSubviewToFront:brushSliderView];
    
    CGFloat components[3];
    HSL2RGB(kPaletteSize, kSaturation, kLuminosity, &components[0], &components[1], &components[2]);
    glColor4f(components[0], components[1], components[2], kBrushOpacity);
    brushSliderView.brushColors = brush.brushColor;
    brushSliderView.eraserColor = [UIColor colorWithRed:components[2] green:components[2] blue:components[2] alpha:1];
    
    brushSliderView.isBrush = TRUE;
    //[brushSliderView setSliderValue];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(-80, 400, 200, 30)];
	[slider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
	slider.backgroundColor = [UIColor clearColor];
    
	UIImage *stetchLeftTrack = [[UIImage imageNamed:@"slider_select.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	UIImage *stetchRightTrack = [[UIImage imageNamed:@"slider_select.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	[slider setThumbImage: [UIImage imageNamed:@"slider_mover.png"] forState:UIControlStateNormal];
	[slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
	[slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    
    slider.minimumValue = 0.1;
    slider.maximumValue = 0.8;
//    slider.value = 0.4;
//	slider.continuous = YES;
    
    slider.transform = CGAffineTransformRotate(slider.transform,RADIANS(270.0));
    
    [brushSliderView.dicSliderValue setObject:[NSString stringWithFormat:@"%f",slider.value] forKey:@"BrushAlfa"];
    [brushSliderView.dicSliderValue setObject:[NSString stringWithFormat:@"%f",slider.value] forKey:@"PenAlfa"];
    
    [sliderView addSubview:slider];
    [sliderView bringSubviewToFront:slider];
    
	[mA release];
}

-(void)sliderAction
{
    paintView.BrushOpacity = slider.value;
    
    if (eraser==YES)
    {
        
    }
    else if (BrushPen == YES)
    {
        [brushSliderView.dicSliderValue setObject:[NSString stringWithFormat:@"%f",slider.value] forKey:@"BrushAlfa"];
    }
    else
    {
        [brushSliderView.dicSliderValue setObject:[NSString stringWithFormat:@"%f",slider.value] forKey:@"PenAlfa"];
    }

    [paintView loadTextual];
}

-(void)toolBarButtonActions:(id)sender
{
    [self.view bringSubviewToFront:paintView];
    UIButton *btn = sender;
    SEL action;
    int index = btn.tag;
    
//    if (index==3)
//        return;
    
    if (index==0)
        [self takePictureFrom:@"My Gallery"];
    else if (index ==1)
        action= @selector(brushesButtonAction:);
    else if(index ==5)
        action= @selector(colorButtonAction:);            
    else if(index ==2||index==3)
        action= @selector(penPencil:);            
    else if(index ==4)
        action= @selector(eraserButtonAction:);            
    else if(index ==4)
        action= @selector(record:);            
    else if(index ==5)
        action= @selector(upload:);
    else if(index ==6)
        action= @selector(more:);
//    else if(index ==7)
//        action= @selector(upload:);            
//    else if(index ==8)
//        action= @selector(trash:);            
//    else if(index ==9)
//        action= @selector(more:);
    if (!index==0)
        [self performSelector:action];
}

///////////TOOLBAR ACTIONS/////////////////////

-(IBAction)penPencil:(int)sender
{
    brushSliderView.slider.minimumValue = 1.0;
    brushSliderView.slider.maximumValue = 2.0;
    brushSliderView.slider.value =[[brushSliderView.dicSliderValue valueForKey:@"Pen"] floatValue];
    slider.value = [[brushSliderView.dicSliderValue valueForKey:@"PenAlfa"] floatValue];
    
    brush.brushColor = brushSliderView.brushColors;
    brush.brushSize = [NSNumber numberWithInt:brushSliderView.slider.value];
    
    eraser = NO;
    BrushPen = NO;
}

-(IBAction)brushesButtonAction:(id)sender
{
    if(brushSliderView.hidden || ![brushSliderView superview])
    {
        drawingView.userInteractionEnabled = paintView.userInteractionEnabled = NO;
        
        if([dropDownView superview]) {
			[dropDownView removeFromSuperview];
		}
        
        if([brushColorPicker superview]) {
			[brushColorPicker removeFromSuperview];
		}
        
        //[self.navigationController.toolbar.items setValue:[NSNumber numberWithBool:NO] forKey:@"enabled"];
        
        [brushSliderView setBrush:brush];
        
        UIToolbar *bottomBar = self.navigationController.toolbar;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            brushSliderView.frame = CGRectMake(500, 0, 0, 0);
        else
            brushSliderView.frame = CGRectMake(140, 0, 0, 0);

        brushSliderView.hidden = NO;
        [bottomBar addSubview:brushSliderView];
        
        [UIView animateWithDuration:0.3 animations:^(void)
         {
            brushSliderView.alpha = 1.0;
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                brushSliderView.frame = CGRectMake(500, -45, 300, 60);
            else
                brushSliderView.frame = CGRectMake(140, -45, 100, 60);
        }];
        
        [bottomBar bringSubviewToFront:brushSliderView];
    }
    
    brushSliderView.slider.minimumValue = 3.0;
    brushSliderView.slider.maximumValue = 7.0;
    brushSliderView.slider.value =[[brushSliderView.dicSliderValue valueForKey:@"brush"] floatValue];\
    slider.value = [[brushSliderView.dicSliderValue valueForKey:@"BrushAlfa"] floatValue];
    
    eraser = NO;
    BrushPen = YES;
    brush.brushColor = brushSliderView.brushColors;
    brush.brushSize = [NSNumber numberWithInt:brushSliderView.slider.value];
}

-(IBAction)colorButtonAction:(id)sender
{
    if ([popoverController isPopoverVisible]) {
        [popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        if(![brushColorPicker superview]){
           
            drawingView.userInteractionEnabled = paintView.userInteractionEnabled = NO;
            
            if([dropDownView superview]) 
                [dropDownView removeFromSuperview];
            
            if (!pickerColor)
                pickerColor = [InfColorPickerController colorPickerViewController];
            
            pickerColor.sourceColor = brushSliderView.brushColors;
            pickerColor.delegate = self;
            
            brushColorPicker.frame = CGRectMake(15, 10, 0, 0);
            brushColorPicker.hidden = NO;
            
            if (!popoverController)
            {
                UIViewController *view = [[UIViewController alloc]init];
                
                view.view = brushColorPicker;
                    NSLog(@"Y %f",view.view.frame.origin.y);
                popoverController = [[UIPopoverController alloc] initWithContentViewController:pickerColor];
            }
            
            popoverController.delegate = self;

            [popoverController setPopoverContentSize:CGSizeMake(320.0f, 416.0f)];
            
            [popoverController presentPopoverFromRect:CGRectMake(75.0f, 675.0f, 320.0f, 416.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
    }
    
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self closeBrushColorPicker];
    NSLog(@"Popover Did");
}


//------------------------------------------------------------------------------
#pragma mark	InfHSBColorPickerControllerDelegate methods
//------------------------------------------------------------------------------

- (void) colorPickerControllerDidChangeColor: (InfColorPickerController*) picker
{
    NSLog(@"colorPickerControllerDidChangeColor");
	brush.brushColor = brushSliderView.brushColors = picker.resultColor;
}

//------------------------------------------------------------------------------

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    NSLog(@"colorPickerControllerDidFinish");
    brush.brushColor = brushSliderView.brushColors = picker.resultColor;
}

-(void)closeBrushColorPicker
{
    drawingView.userInteractionEnabled = paintView.userInteractionEnabled = YES;

    [UIView animateWithDuration:0.2
                     animations:^{brushColorPicker.alpha = 0.0;}
                     completion:^(BOOL finished){
                         [brushColorPicker removeFromSuperview];
                       //  brush.brushColor = [[brushColorPicker getColorPickerView] color];
                         [self performSelectorOnMainThread:@selector(updatePaintView) withObject:nil waitUntilDone:NO]; }];
    
    [self.view bringSubviewToFront:paintView];
}

-(void)upload:(id)sencer
{
    [self.view bringSubviewToFront:paintView];
  
    BOOL isRegistered = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRegistered"];
    if (!isRegistered)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:@"Please Register" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Register",@"Cancel",nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //change Base URL
    NSString *urlString;
    urlString= [NSString stringWithFormat: @"%@userid=%@",POST_URL,[defaults valueForKey:@"userid"]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadphoto1\"; filename=\"%@\"\r\n",[NSString stringWithFormat:@"%@_%0.f.jpg",[[UIDevice currentDevice] uniqueIdentifier],[[NSDate date] timeIntervalSince1970]]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *image = [drawingView image];
    
    NSData* imageData = UIImagePNGRepresentation(image);

    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
   // [imageData release];
   // imageData = nil;
    
    DownloadOperation *operation = [[DownloadOperation alloc] initWithURL:request withDelegate:self];
    
    [operation setQueuePriority:NSOperationQueuePriorityHigh];
	
	[[NSOperationQueue sharedOperationQueue] addOperation:operation];
	
	[operation release];
    
   // [request release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        UIViewController *rootViewController;
        rootViewController = [[RegisterVC alloc] initWithNibName:@"RegisterVC" bundle:nil];
        
        UIBarButtonItem *launcherBarButtonItem = [[UIBarButtonItem alloc] initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/launcher.png") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissChild)];
        [rootViewController.navigationItem setLeftBarButtonItem:launcherBarButtonItem];
        [launcherBarButtonItem release];
        
        UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        [self presentModalViewController:navController animated:YES];
        [rootViewController release];
        [navController release];
    }
}

-(void)dismissChild
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    [self dismissModalViewControllerAnimated:YES];
}

-(void)didFailed:(NSError*)error
{
    NSLog(@"error %@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:@"Failed Posted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)didReceiveData:(NSData*)data{
    
    NSString *result_str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"response %@",result_str);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:@"Successfully Posted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
}

/**
 ToolBar Undo Action
 */

-(IBAction)undo:(id)sender
{
//    [self.view bringSubviewToFront:paintView];
    
    if ([arrayUndo count]==0)
        return;
    
    drawingView.image = nil;
//    drawingView.image = [arrayUndo lastObject];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[arrayUndo lastObject]];
    NSLog(@"H %f W %f",drawingView.frame.size.height,drawingView.frame.size.width);
    [arrayRedo addObject:[arrayUndo lastObject]];
    [arrayUndo removeLastObject];
    
    [self.view bringSubviewToFront:sliderView];
//    if ([[self undoManager] canUndo])
//    {
//        [[self undoManager] undo];
//    }
}

-(IBAction)redo:(id)sender
{
	// Add image From deleted List
//    [self.view bringSubviewToFront:paintView];
    
    if ([arrayRedo count]==0)
        return;

    drawingView.image = nil;
//    drawingView.image = [arrayRedo lastObject];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[arrayRedo lastObject]];    
    [arrayUndo addObject:[arrayRedo lastObject]];
    [arrayRedo removeLastObject];
    [self.view bringSubviewToFront:sliderView];
    NSLog(@"H %f W %f",drawingView.frame.size.height,drawingView.frame.size.width);
//    if ([[self undoManager] canRedo])
//    {
//        [[self undoManager] redo];
//    }
}

-(IBAction)eraserButtonAction:(id)sender
{
//    [self.view sendSubviewToBack:paintView];
////    brush.brushColor = drawingView.backgroundColor;
//    //[self.view bringSubviewToFront:drawingView];
//	[drawingView eraserButtonAction:sender];
    
    brushSliderView.slider.minimumValue = 5.0;
    brushSliderView.slider.maximumValue = 10.0;
    
    brushSliderView.slider.value = 7.5;
    brush.brushSize = [NSNumber numberWithInt:7.5];
    eraser = YES;
    brush.brushColor = brushSliderView.eraserColor;
}

-(IBAction)trash:(id)sender{
    
    [self.view bringSubviewToFront:paintView];
//    [[self.navigationController.toolbar.items objectAtIndex:5]setValue:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    
    drawingView.image = nil;
 //   self.view.backgroundColor = [UIColor whiteColor];
    [self.undoManager removeAllActions];
    [self.undoManager undo];
    [self performSelector:@selector(checkUndoAndUpdateNavBar)];
    
    return;
}

-(IBAction)more:(id)sender
{
    actMenu= [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancle" destructiveButtonTitle:@"Cancle" otherButtonTitles:@"Facebook",@"Twitter",@"Save",@"Reset",@"Cancel", nil];
    
    [actMenu showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
}

/////////////TOOLBAR ACTIONS END///////////////////////////////

-(void)dropDownViewButtonActios:(UIButton*)button
{
    drawingView.userInteractionEnabled = paintView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.2
                     animations:^{dropDownView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         [dropDownView removeFromSuperview];
                         if (button.tag != 4)
                         {
                             [self setUpSocailNetworking:button.tag];
                         } }];
    
    [self.view bringSubviewToFront:paintView];
}

////////////////////////////////////////////////////////////

-(void)updatePaintView{
    [self.view bringSubviewToFront:paintView];
	[drawingView setBrush:brush];
    [paintView setBrush:brush];
	
}

-(void)didSelectBrushColor:(UIColor*)newColor size:(float)size{

	brush.brushColor = [newColor retain];
	brush.brushSize = [NSNumber numberWithInt:size];
	[self performSelector:@selector(updatePaintView)];
}

#pragma mark 
#pragma mark UIImagePickerController delegate

-(void)takePictureFrom:(NSString*)type
{
    
    if([type isEqualToString:@"Photo Library"]){
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        //	picker.allowsImageEditing = NO;
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    } else if([type isEqualToString:@"Camera"]){
        //if ([UIImagePickerController isSourceTypeAvailable:type]) 
        {
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            //	picker.allowsImageEditing = NO;
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];   
        }
       

    } else if([type isEqualToString:@"My Gallery"]){
        //Gallary VC
        
        GalleriesVC *rootViewController;
        rootViewController = [[GalleriesVC alloc] initWithNibName:@"GalleriesVC" bundle:nil];
        rootViewController.managedObjectContext = ((PathwaysAppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        rootViewController.sourceType = GalleryViewTypePicker;
        rootViewController.pickerDelegate = self;
              
        UIBarButtonItem *launcherBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissChild)];
        [rootViewController.navigationItem setLeftBarButtonItem:launcherBarButtonItem];
        [launcherBarButtonItem release];
        
        UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        navController.navigationBar.tintColor = [UIColor colorWithWhite:0.4 alpha:1];

        [self presentModalViewController:navController animated:YES];
        [rootViewController release];
        [navController release];
        
        UIApplication *application = [UIApplication sharedApplication];
        [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];

    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (actMenu)
    {
        if (buttonIndex==1)
        {
            NSString *client_id = @"365186020226515";
            
            //alloc and initalize our FbGraph instance
            fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
            
            //begin the authentication process.....
            [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
        }
        else if (buttonIndex==2)
        {
            [self sendTweet:nil];
        }
        else if (buttonIndex==3)
        {
            [self saveCurrentDrawing];
            
            [[[[UIAlertView alloc]initWithTitle:@"" message:@"Drawing saved in gallery..." delegate:nil cancelButtonTitle:@"Okay!!!!" otherButtonTitles: nil]autorelease]show];
        }
        else if (buttonIndex==4)
        {
            [self addNewPaint];
        }
    }
//    if(buttonIndex != 10){
//        [self takePictureFrom:[actionSheet buttonTitleAtIndex:buttonIndex]];
//    }
}

-(void)setBackgroundImage:(UIImage*)aBGImage{
    
    [UIView beginAnimations:@"suck" context:NULL];
    [UIView setAnimationDuration:0];

    [UIView setAnimationTransition:0 forView:self.view cache:YES];
   // [UIView setAnimationPosition:CGPointMake(12, 345)];
        self.view.backgroundColor = [UIColor colorWithPatternImage:aBGImage];
    [UIView commitAnimations];
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:1.0];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:aBGImage];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:NO];
//    [UIView commitAnimations];
}

-(IBAction)changeBackground:(id)sender{
    
    UIActionSheet *popupaction_control ;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        popupaction_control= [[UIActionSheet alloc]
                              initWithTitle:@"Choose background picture"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"Camera",@"Photo Library",@"My Gallery",nil];

    } else {
        popupaction_control= [[UIActionSheet alloc]
                              initWithTitle:@"Choose background picture"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"Photo Library",@"My Gallery",nil];
   
    }
	
    popupaction_control.actionSheetStyle = UIActionSheetStyleBlackOpaque;
   // popupaction_control.cancelButtonIndex = 10;
    [popupaction_control showInView:self.view];
	
    [popupaction_control release];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info 
{
	UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
	[UIView animateWithDuration:0.5 animations:^{
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.5 animations:^(void) {
            [self setBackgroundImage:image];

		}];
	}];

	[self dismissModalViewControllerAnimated:NO];
	
}
- (UIImage*) mergeImages:(UIImage*)bgImage hoverImage:(UIImage*)hoverImage
{
   CGSize size = self.view.frame.size;
	
	if (UIGraphicsBeginImageContextWithOptions != NULL) {
		UIGraphicsBeginImageContextWithOptions(size, NO, self.view.contentScaleFactor);
	} else {
		UIGraphicsBeginImageContext(size);
	}
	
   UIGraphicsBeginImageContext(size);

  	[bgImage drawAtPoint:CGPointMake(0, 0)];
	[hoverImage drawAtPoint:CGPointMake(0, 0)];


   UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
	
   return result;
}

#pragma mark facebook
- (void)fbGraphCallback:(id)sender
{    
    if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) )
    {
        NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
        
        UIAlertView *alertname = [[UIAlertView alloc] init];
        
//        [alertname setDelegate:self];
        [alertname setTitle:@"Successfully posted"];
        [alertname setMessage:@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful...."];
        [alertname addButtonWithTitle:@"Ok"];
        
        [alertname show];
        [alertname release];
    }
    else
    {
        //pop a message letting them know most of the info will be dumped in the log        
        NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:3];
    
        UIImage *picture = [self getCurrentImage];
        
        //create a FbGraphFile object insance and set the picture we wish to publish on it
        FbGraphFile *graph_file = [[FbGraphFile alloc] initWithImage:picture];
        
        //finally, set the FbGraphFileobject onto our variables dictionary....
        [variables setObject:graph_file forKey:@"file"];
        
        [variables setObject:@"Pathways Drawing App" forKey:@"message"];
        
        //the fbGraph object is smart enough to recognize the binary image data inside the FbGraphFile
        //object and treat that is such.....
        FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"117795728310/photos" withPostVars:variables];
        //        NSLog(@"postMeFeedButtonPressed:  %@", fb_graph_response.htmlResponse);
        
        //parse our json
        SBJSON *parser = [[SBJSON alloc] init];
        NSDictionary *facebook_response = [parser objectWithString:fb_graph_response.htmlResponse error:nil];    
        [parser release];
        
        //let's save the 'id' Facebook gives us so we can delete it if the user presses the 'delete /me/feed button'
        NSString *feedPostId = (NSString *)[facebook_response objectForKey:@"id"];
        NSLog(@"feedPostId, %@", feedPostId);
        NSLog(@"Now log into Facebook and look at your profile...");					 
        UIAlertView *alertname = [[UIAlertView alloc] init];
        
//        [alertname setDelegate:self];
        [alertname setTitle:@"Successfully posted"];
        [alertname setMessage:@""];
        [alertname addButtonWithTitle:@"Ok"];
        
        [alertname show];
        [alertname release];
    }
}

//-(void)uploadphotoOnMainThread
//{
//	UIImage *resulImage = [self getCurrentImage];
//	
//	NSData *data = UIImageJPEGRepresentation(resulImage, 1); 
//	
//}

/////////////SOCIAL N/W//////////////////////////////////
-(void)setUpSocailNetworking:(int)tag{
	
    if(tag == 1)
    {
        NSString *client_id = @"365186020226515";
        
        //alloc and initalize our FbGraph instance
        fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
        
        //begin the authentication process.....
        [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
	}
    else if(tag == 2)
    {
        [self sendTweet:nil];
	}
    else if(tag == 3)
    {
        if (!editingPhoto)
            editingPhoto = [[self saveCurrentDrawing] retain];
        else
            [self saveCurrentDrawing];
    }
	
}

//=============================================================================================================================
#pragma mark Twitter

- (IBAction)sendTweet:(id)sender
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        // Initialize Tweet Compose View Controller
        TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
        
        // Settin The Initial Text
        [vc setInitialText:@"This tweet was sent using Parthway iPhone App"];
        
        // Adding an Image
        UIImage *image = [self getCurrentImage];
        [vc addImage:image];
        
        // Adding a URL
        
        // Setting a Completing Handler
        [vc setCompletionHandler:^(TWTweetComposeViewControllerResult result)
         {
             if(result == TWTweetComposeViewControllerResultDone)
             {
                 [[[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Tweet send" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]autorelease]show];
                 NSLog(@"Tweet send"); // the user finished composing a tweet
             }
             else if(result == TWTweetComposeViewControllerResultCancelled)
             {
                 [[[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Tweet cancelled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]autorelease]show];
                 NSLog(@"Tweet cancelled");// the user cancelled composing a tweet
             }
            [self dismissModalViewControllerAnimated:YES];
        }];
        
        // Display Tweet Compose View Controller Modally
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    else
    {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device. Pleaes add Twitter account from Setting>Twitter";
        [[[[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]autorelease]show];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) 
    {
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [drawingView release];
    [paintView release];
    
    [brushColorPicker release];
    [dropDownView release];
    [brushSliderView release];;
    
    [erasingSound release];;
    [selectSound release];;
    [brush release];;
    
    [managedObjectContext release];

    [super dealloc];
}

@end

