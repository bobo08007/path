//
//  BrushColorPicker.m
//  Pathways
//
//  Created by iMac on 18/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrushColorPicker.h"
#import "Brush.h"
#import "FTAnimation.h"

#define kSliderHeight			7.0

static UIImage *closeImage = nil;

@implementation BrushColorPicker
@synthesize bcDelegate;

+(void)initialize{
    closeImage = [[UIImage imageNamed:@"close_button.png"] retain];
}

- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
	}
	
	self.backgroundColor = [UIColor redColor];
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, closeImage.size.width, closeImage.size.height);
    closeButton.contentMode = UIViewContentModeTop;
    [closeButton addTarget:bcDelegate action:@selector(closeBrushColorPicker) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    //[self addSubview:closeButton];
    
    segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Brush",@"Background", nil]];
    segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentControl.backgroundColor = [UIColor clearColor];
    segmentControl.tintColor = [UIColor colorWithWhite:0 alpha:0.3];
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(segmentcontrolAction) forControlEvents:UIControlEventValueChanged];
    segmentControl.frame = CGRectMake(40, 5, 200, 30);
    //[self addSubview:segmentControl];

	return self;
}
-(void)segmentcontrolAction{
    [colorPicker colorPickerFor:!segmentControl.selectedSegmentIndex];
}
 
-(ColorPickerView*)getColorPickerView{
    return colorPicker;
}
-(void)setBrush:(Brush*)aBrush{
	brush = aBrush;
	
	const CGFloat *pxl = CGColorGetComponents(brush.brushColor.CGColor);
	
	NSLog(@"B Color %f,%f,%f,%f",pxl[0],pxl[1],pxl[2],pxl[3]);
	
	if(!colorPicker)
	{
		[self performSelector:@selector(initializeColorPicker)];
	}
}
- (void)colorChanged:(UIColor *)newColor{
    if(segmentControl.selectedSegmentIndex == 1)
    {
        self.superview.backgroundColor = newColor;
    }
    else
    {
        brush.brushColor = newColor;
        
        const CGFloat *pxl = CGColorGetComponents(brush.brushColor.CGColor);
        
        NSLog(@"B Color %f,%f,%f,%f",pxl[0],pxl[1],pxl[2],pxl[3]);
    }
}

-(void)initializeColorPicker
{
	NSString * coderPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/save.dat"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:coderPath]) {
		colorPicker = [[NSKeyedUnarchiver unarchiveObjectWithFile:coderPath] retain];
	} else {
		colorPicker = [[ColorPickerView alloc] initWithFrame:CGRectMake(5, 5, 270, 220)];
        colorPicker.delegate = self;
	}
	[colorPicker setColor:brush.brushColor];
	[self addSubview:colorPicker];
    [self bringSubviewToFront:closeButton];
}

- (void)drawRect:(CGRect)rect {
	
	[[UIColor colorWithRed:0.243 green:0.255 blue:0.293 alpha:1.0] set];	
	UIBezierPath *rectsbyroundtop = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
	[rectsbyroundtop fill];
}


- (void)dealloc {
	[colorPicker release];
	[super dealloc];
}


@end
