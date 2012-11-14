//
//  EventCell.m
//  Pathways
//
//  Created by iMac on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Gradient.h"

@implementation EventCell

static CGGradientRef gradient1 =nil;
static CGGradientRef gradient2 =nil;
static CGGradientRef gradient3 =nil;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
	self.backgroundColor = [UIColor clearColor];
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}
- (void)drawRect:(CGRect)rect {
	self.backgroundColor = [UIColor clearColor];

	CGFloat colors[] =
	{
		200 / 255.0, 207.0 / 255.0, 212.0 / 255.0, 0.1,
		250 / 255.0,  250 / 255.0, 250 / 255.0, 0.3
	};
	[UIView drawLinearGradientInRect:CGRectMake(0, 0, 320, CGRectGetHeight(rect)-0.5) colors:colors];
	
	
	 
	 CGFloat colors2[] =
	 {
	 220/255.0, 156/255.0, 161/255.0, 0.6,
	 220/255.0, 156/255.0, 161/255.0, 0.1
	 };
	 [UIView drawLinearGradientInRect:CGRectMake(0, CGRectGetHeight(rect)-1, 320, 1) colors:colors2];
	 
	
	CGFloat line[]={94 / 255.0,  103 / 255.0, 109 / 255.0, 1.00};
	[UIView drawLineInRect:CGRectMake(0, CGRectGetHeight(rect)-0.5, 320, 0.5) colors:line];
	
	
	/* 
	 CGContextRef currentContext = UIGraphicsGetCurrentContext();
	 
	 [self drawBackgroundGradient:currentContext];
	 [self drawForegroundGradient:currentContext];
	 [self drawBackgroundGradientForCode:currentContext];
	 */
}


-(CGGradientRef)getGradient1{
	
	if (gradient1 == nil) {
		
		size_t num_locations = 3;
		CGFloat locations[3] = { 0.0,0.97, 1.0 };
		CGFloat components[12] = {
			0.09, 0.47, 0.60, 1.0,
			0.09, 0.47, 0.60, 0.3,
			1, 1, 1, 1.0
		}; 
		
		CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
		gradient1 = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
		CGColorSpaceRelease(rgbColorspace); 
	}
	return gradient1;
}
-(CGGradientRef)getGradient2{
	
	if (gradient2 == nil) {
		size_t num_locations = 2;
		CGFloat locations[2] = { 0.0, 1.0  };
		CGFloat components[8] = {
			0.09, 0.47, 0.60, 1.0,
			0.09, 0.47, 0.60, 0.3,
		};
		CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
		gradient2 = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
		CGColorSpaceRelease(rgbColorspace); 
	}
	return gradient2;
}
-(CGGradientRef)getGradient3{
	
	if (gradient3 == nil) {
		size_t num_locations = 2;
		CGFloat locations[2] = { 0.0, 1.0  };
		CGFloat components[8] = {
			1.0, 1.0, 1.0, 0.0,
			1.0, 1.0, 1.0, 0.5
		};
		
		CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
		gradient3 = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
		CGColorSpaceRelease(rgbColorspace); 
	}
	return gradient3;
}

-(void)drawBackgroundGradient:(CGContextRef)context{
	CGContextRef currentContext = context;
	
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetHeight(currentBounds));
	
	
	
	CGContextDrawLinearGradient(currentContext, [self getGradient1], topCenter, midCenter, 0);
}
-(void)drawForegroundGradient:(CGContextRef)context{
	CGContextRef currentContext = context;
	
	CGRect currentBounds = self.bounds;
	
	CGPoint topCenter = CGPointMake(0, CGRectGetMidY(currentBounds));
	CGPoint midCenter = CGPointMake(0, CGRectGetMidY(currentBounds));
	
	
	CGContextDrawRadialGradient(currentContext, [self getGradient2], topCenter, 500, midCenter, CGRectGetMidY(currentBounds), 1);
	
}
-(void)drawBackgroundGradientForCode:(CGContextRef)context{
	CGContextRef currentContext = context;
	CGRect currentBounds = self.bounds;
	
	CGPoint topCenter = CGPointMake(7, CGRectGetMidY(currentBounds));
	CGPoint midCenter = CGPointMake(70, CGRectGetMidY(currentBounds));
	
	CGContextDrawLinearGradient(currentContext, [self getGradient3], topCenter, midCenter, 0);
}


- (void)dealloc {
    [super dealloc];
}


@end
