//
//  HomeButton.m
//  Pathways
//
//  Created by iMac on 07/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeButton.h"
#import <QuartzCore/QuartzCore.h>

#define borderLineWidth 2.5
#define layerCornerRadius 8.5

@implementation HomeButton
static CGGradientRef gradient1 =nil;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
	self.backgroundColor = [UIColor blueColor];
    return self;
}

- (void)drawRect:(CGRect)rect {
	

	[[UIColor colorWithWhite:0.0 alpha:1.0] set];
	CGRect newRect = CGRectInset(rect, borderLineWidth, borderLineWidth);
	UIBezierPath *rectsbyround = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:layerCornerRadius];
	rectsbyround.lineWidth = borderLineWidth;
    //[rectsbyround stroke];

//	self.layer.masksToBounds = NO;
//	self.layer.shadowOffset = CGSizeMake(1, 2);
//	self.layer.shadowRadius = layerCornerRadius;
//	self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
//	self.layer.shadowOpacity = 1.0;
	
//	[self drawBackgroundGradient:UIGraphicsGetCurrentContext()];

}

-(CGGradientRef)getGradient1{
	
	if (gradient1 == nil) {
		
		size_t num_locations = 2;
		CGFloat locations[2] = { 0.0, 1.0 };
		CGFloat components[8] = {
			1, 1, 1, 1.0,
			1, 1, 1, 0.2
		}; 
		
		CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
		gradient1 = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
		CGColorSpaceRelease(rgbColorspace); 
	}
	return gradient1;
}

-(void)drawBackgroundGradient:(CGContextRef)context{
	CGContextRef currentContext = context;
	
	CGRect currentBounds = CGRectInset( self.bounds, borderLineWidth, borderLineWidth);
	
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
	CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
	
	
	CGContextDrawRadialGradient(currentContext, [self getGradient1], topCenter, 0, midCenter, 35, 1);
	
	
}

- (void)dealloc {
    [super dealloc];
}


@end
