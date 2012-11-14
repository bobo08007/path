//
//  DrawVC.h
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SA_OAuthTwitterController.h"
#import "PopoverViewController.h"
#import "FbGraph.h"
#import "PathwaysAppDelegate.h"
#import "InfColorPicker.h"
#import "KSCustomPopoverBackgroundView.h"

@class PaintingView;
@class SoundEffect;
@class PaintToolBar;
@class Brush;
@class BrushColorPicker;
@class DropDownView;
@class BrushSliderView;
@class DragView;
@class PaintingView;
@class  GalleryPhoto;
@interface DrawVC : UIViewController<UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,InfColorPickerControllerDelegate>
{
    PathwaysAppDelegate *appDelegete;
    
    IBOutlet DragView *drawingView;
    IBOutlet PaintingView *paintView;
    
	IBOutlet BrushColorPicker *brushColorPicker;
	IBOutlet DropDownView *dropDownView;
	IBOutlet BrushSliderView *brushSliderView;

    IBOutlet UIView *sliderView;
	
	SoundEffect	*erasingSound;
	SoundEffect	*selectSound;
	Brush *brush;

	CFTimeInterval	lastTime;
	
	//Social Networking
    FbGraph *fbGraph;
	
    //Core data
    GalleryPhoto *editingPhoto;
//    NSUndoManager *undoManager;
    NSManagedObjectContext *managedObjectContext;
    UIImage *imgNew;
    
    NSMutableArray *oldImagesArrays;
    
    int undoRedoStackIndex;
    
    UIPopoverController *popoverController;
    UISlider *slider;
    
    InfColorPickerController *pickerColor;
    
    bool eraser;
    bool BrushPen;
    
    NSMutableArray *arrayUndo;
    NSMutableArray *arrayRedo;
    
    UIActionSheet *actMenu;
}

@property (assign) GalleryPhoto *editingPhoto;
//@property (retain) NSUndoManager *undoManager;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void)setUpPaintToolBar;
-(IBAction)brushesButtonAction:(id)sender;
-(IBAction)colorButtonAction:(id)sender;
-(IBAction)eraserButtonAction:(id)sender;
-(IBAction)undo:(id)sender;
-(IBAction)redo:(id)sender;
-(IBAction)trash:(id)sender;
-(IBAction)more:(id)sender;
-(IBAction)changeBackground:(id)sender;
-(void)setBackgroundImage:(UIImage*)aBGImage;
//- (void)resetImage;

-(void)setUpSocailNetworking:(int)tag;
-(void)saveSnapShot:(UIImage*)image;
-(void)closeBrushColorPicker;
//-(void)closeBrushSliderView;
-(void)setImage:(UIImage*)newImage;

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
- (void) touchesEnded:(NSSet *)touches withEvent: (UIEvent *) event;
- (void) touchesCancelled:(NSSet *)touches withEvent: (UIEvent *) event;

//- (void)addGestureRecognizersToPiece:(UIView *)piece;

-(IBAction)penPencil:(int)sender;
-(void)takePictureFrom:(NSString*)type;
- (IBAction)sendTweet:(id)sender;
-(void)removeImage:(UIImage*)newImg;
//- (NSUndoManager *)undoManager;
@end

