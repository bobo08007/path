//
//  BrushSliderView.m
//  Pathways
//
//  Created by iMac on 16/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrushSliderView.h"
#import "Brush.h"
#import "FTAnimation.h"

#define kSliderHeight			7.0


@implementation BrushSliderView
@synthesize brushSliderDelegate,isBrush,dicSliderValue;
@synthesize brushColors;
@synthesize eraserColor,slider;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void)initializeSliderView
{
    dicSliderValue = [[NSMutableDictionary alloc]initWithCapacity:2];
	CGRect frame = CGRectMake(2, CGRectGetHeight(self.frame)-3*kSliderHeight, CGRectGetWidth(self.frame)-10, 10);
	slider = [[UISlider alloc] initWithFrame:frame];
	[slider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
	slider.backgroundColor = [UIColor clearColor];	
	UIImage *stetchLeftTrack = [[UIImage imageNamed:@"slider_select.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	UIImage *stetchRightTrack = [[UIImage imageNamed:@"slider_select.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	[slider setThumbImage: [UIImage imageNamed:@"slider_mover.png"] forState:UIControlStateNormal];
	[slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
	[slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];

    slider.minimumValue = 5.0;
    slider.maximumValue = 10.0;
	slider.continuous = YES;
	slider.value = 7.5;
	[dicSliderValue setObject:[NSString stringWithFormat:@"%f",slider.value] forKey:@"brush"];
    [dicSliderValue setObject:[NSString stringWithFormat:@"1.5"] forKey:@"Pen"];
    NSLog(@"dicSliderValue %@",dicSliderValue);
	slider.hidden = NO;
	
	[slider setAccessibilityLabel:NSLocalizedString(@"CustomSlider", @"")];
	
	[self addSubview:slider];
}

-(void)sliderAction
{
	if(timer)
    {
		[timer invalidate];
		[timer release];
		timer = nil;
	}
	
    NSLog(@"slider.value %f",slider.value);
    
    if (isBrush)
        [dicSliderValue setObject:[NSString stringWithFormat:@"%f",slider.value] forKey:@"brush"];
    else
        [dicSliderValue setObject:[NSString stringWithFormat:@"%f",slider.value] forKey:@"Pen"];
    
	brush.brushSize = [NSNumber numberWithInt:slider.value];
	//NSLog(@"B Size %@",brush.brushSize);
	[self setNeedsDisplay];
	timer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:NO] retain];
}

-(void)timerAction:(NSTimer*)atimer
{
	[timer invalidate];
	[timer release];
	timer = nil;
	
	if(brushSliderDelegate && [brushSliderDelegate respondsToSelector:@selector(closeBrushSliderView)])
    {
		[brushSliderDelegate performSelector:@selector(closeBrushSliderView)];
	}
}

-(void)setBrush:(Brush*)aBrush{
	brush = aBrush;
	
	if(!slider){
		[self performSelector:@selector(initializeSliderView)];
	}
    if(timer){
		[timer invalidate];
		[timer release];
		timer = nil;
	}
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction:) userInfo:nil repeats:NO] retain];

}

- (void)drawRect:(CGRect)rect {
	
	/*
	[[UIColor colorWithRed:0.243 green:0.255 blue:0.293 alpha:1.0] set];	
	UIBezierPath *rectsbyroundtop = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
	[rectsbyroundtop fill];
	
	
	//NSLog(@"Slider Rect %@",NSStringFromCGRect(rect));
	
	float mover_x = CGRectGetMinX(slider.frame)+CGRectGetWidth(slider.frame)*(slider.value/slider.maximumValue)/1.35;
	
	static float maxCircleSize = 30;
	static float minCircleSize = 15;
	
	float mover_size = minCircleSize+(slider.value/slider.maximumValue)*maxCircleSize;
	
	
	//NSLog(@"Mover x %f, mover size %f, slider value %f,mover width %f",mover_x,mover_size,slider.value,CGRectGetWidth(slider.frame));
	
	CGRect outerCircleRect = CGRectMake(mover_x-minCircleSize/2, CGRectGetMinY(slider.frame)-mover_size, mover_size, mover_size);
	
	[[UIColor colorWithWhite:0.0 alpha:1.0] set];	
	UIBezierPath *outerCircle = [UIBezierPath bezierPathWithOvalInRect:outerCircleRect];
	[outerCircle fill];
	
	CGRect innerCircleRect = CGRectInset(outerCircleRect, 5, 5);
	[[UIColor colorWithWhite:1.0 alpha:0.5] set];	
	UIBezierPath *innerCircle = [UIBezierPath bezierPathWithOvalInRect:innerCircleRect];
	[innerCircle fill];
	
	
	
	NSString *val = [NSString stringWithFormat:@"%.0f",slider.value];
	UIFont *font = [UIFont boldSystemFontOfSize:(13+(int)(slider.value/slider.maximumValue))];
	CGSize tsize = [val sizeWithFont:font];
	
	[[UIColor colorWithWhite:0.8 alpha:0.6] set];
	[val drawAtPoint:CGPointMake(CGRectGetMidX(innerCircleRect)-tsize.width/2, CGRectGetMidY(innerCircleRect)-tsize.height/2) withFont:font];
	
	[[UIColor blackColor] set];
	
	[val drawAtPoint:CGPointMake(CGRectGetMidX(innerCircleRect)-tsize.width/2, (CGRectGetMidY(innerCircleRect)-tsize.height/2)-1) withFont:font];*/
}

- (void)dealloc {
    [super dealloc];
}


@end
