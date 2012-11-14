
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Three20.h"

#define kBrushOpacity		0.7
#define kBrushPixelStep		3
#define kBrushScale			2
#define kLuminosity			0.75
#define kSaturation			1.0
#define kMagic              .7

@class Brush;

@interface PaintingView : UIView
{
	Brush *brush;
	UIViewController *viewController;
    
    UIColor *brushColors;
    UIColor *backColor;
    
@private
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	
	GLuint viewRenderbuffer, viewFramebuffer;

	GLuint depthRenderbuffer;
	
	GLuint	bgTexture;

	CGPoint	location;
	CGPoint	previousLocation;

	NSTimeInterval previousTimeStamp;
    
    NSTimeInterval currentTimeStamp;
    
    CGFloat totalDistance;
    CGFloat totalTime;
    CGPoint	c,p1,p2,p3;

    BOOL firstTouch;
    
    float BrushOpacity;
    
    float orgBrushOpacity;
}

@property(assign) float BrushOpacity;
@property(nonatomic,retain)Brush *brush;
@property(nonatomic,retain)EAGLContext *context;
@property (assign) IBOutlet UIViewController * viewController;;
@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;
@property(nonatomic,readwrite) NSTimeInterval previousTimeStamp;
@property(nonatomic,readwrite) NSTimeInterval currentTimeStamp;

-(void)erase;
-(IBAction)setBrush:(Brush*)aBrush;
-(UIImage*)snapUIImage;
//-(int)BrushOpacity;
-(void)loadTextual;
@end
