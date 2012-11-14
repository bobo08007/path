//
//  DragView.m
//  HelloWorld
//
//  Created by SRAimac2 on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DragView.h"
#import <QuartzCore/QuartzCore.h>

@interface DrawLayer : CAShapeLayer {
@private
    
}
@end
@implementation DrawLayer

-(id)init{
    self= [super init];
    self.borderColor = [UIColor grayColor].CGColor;
    self.borderWidth = 1;
    self.cornerRadius = 4;
    return self;
}

@end

@implementation DragView
@synthesize viewController;

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeCGRect:self.frame forKey:@"viewFrame"];
}

- (id) initWithCoder: (NSCoder *)coder
{
	[super initWithFrame:CGRectZero];
	self.frame = [coder decodeCGRectForKey:@"viewFrame"];
	self.userInteractionEnabled = YES;
	return self;
}
+ (Class) layerClass
{
	return [DrawLayer class];
}

//////////////////TOOLBAR ACTIONS START///////////////////////
-(IBAction)setBrush:(Brush*)aBrush{
	if (aBrush != nil) {
		brush = aBrush;		
	}
	
	isEraseMode = TRUE;
    
}
- (void) erase
{
	
}
-(IBAction)eraserButtonAction:(id)sender{
    
	//isEraseMode = !isEraseMode;
	//TODO : SET Context redo	
}
-(IBAction)trash:(id)sender{
    
	/* // This is for Video Recording
     NSURL *dURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
     
     NSString* cachePath = [[dURL path] stringByAppendingPathComponent:fileName];
     
     NSMutableArray *recordedPaths = [NSMutableArray arrayWithContentsOfFile:cachePath];
     
     if([recordedPaths count])
     {
     [recordedPaths removeAllObjects];
     
     [recordedPaths writeToURL:[NSURL fileURLWithPath:cachePath] atomically:YES];
     }
     */
	[self erase];
}



-(IBAction)undo:(id)sender{
    
	//[self erase];
	
	/* // Video Recording
	 
     NSURL *dURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
     
     NSString* cachePath = [[dURL path] stringByAppendingPathComponent:fileName];
     
     NSMutableArray *recordedPaths = [NSMutableArray arrayWithContentsOfFile:cachePath];
     
     if([recordedPaths count])
     {
     [recordedPaths removeLastObject];
     
     [recordedPaths writeToURL:[NSURL fileURLWithPath:cachePath] atomically:YES];
     
     if([recordedPaths count])
     {
     [self playback:recordedPaths];
     }
     }
	 */
}

//////////////////TOOLBAR ACTIONS END///////////////////////

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Prepare undo-redo first
	[self.viewController touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self.viewController touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent: (UIEvent *) event
{
	[self.viewController touchesEnded:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches withEvent: (UIEvent *) event
{
	[self.viewController touchesEnded:touches withEvent:event];
}

- (void) dealloc
{
	[super dealloc];
}
@end
