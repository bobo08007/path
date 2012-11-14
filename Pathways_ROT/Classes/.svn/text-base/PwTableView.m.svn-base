//
//  PwTableView.m
//  iCurrencyConvertor
//
//  Created by iMac on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PwTableView.h"

#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)


@implementation PwTableView

- (void)drawRect:(CGRect)rect {
	
//	CGContextRef context = UIGraphicsGetCurrentContext();
	
//	[self drawBackgroundGradient:context];

	
}
- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse
{
	CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
	CGRect newShadowFrame =
	CGRectMake(0, 0, self.frame.size.width,
			   inverse ? SHADOW_INVERSE_HEIGHT : SHADOW_HEIGHT);
	newShadow.frame = newShadowFrame;
	CGColorRef darkColor =
	[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:
	 inverse ? (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT) * 0.5 : 0.5].CGColor;
	CGColorRef lightColor =
	[self.backgroundColor colorWithAlphaComponent:0.0].CGColor;
	newShadow.colors =
	[NSArray arrayWithObjects:
	 (id)(inverse ? lightColor : darkColor),
	 (id)(inverse ? darkColor : lightColor),
	 nil];
	return newShadow;
}

//
// layoutSubviews
//
// Override to layout the shadows when cells are laid out.
//
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	//
	// Construct the origin shadow if needed
	//
	if (!originShadow)
	{
		originShadow = [self shadowAsInverse:NO];
		[self.layer insertSublayer:originShadow atIndex:0];
	}
	else if (![[self.layer.sublayers objectAtIndex:0] isEqual:originShadow])
	{
		[self.layer insertSublayer:originShadow atIndex:0];
	}
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	//
	// Stretch and place the origin shadow
	//
	CGRect originShadowFrame = originShadow.frame;
	originShadowFrame.size.width = self.frame.size.width;
	originShadowFrame.origin.y = self.contentOffset.y;
	originShadow.frame = originShadowFrame;
	
	[CATransaction commit];
	
	NSArray *indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	if ([indexPathsForVisibleRows count] == 0)
	{
		[topShadow removeFromSuperlayer];
		[topShadow release];
		topShadow = nil;
		[bottomShadow removeFromSuperlayer];
		[bottomShadow release];
		bottomShadow = nil;
		return;
	}
	
	NSIndexPath *firstRow = [indexPathsForVisibleRows objectAtIndex:0];
	if ([firstRow section] == 0 && [firstRow row] == 0)
	{
		UIView *cell = [self cellForRowAtIndexPath:firstRow];
		if (!topShadow)
		{
			topShadow = [[self shadowAsInverse:YES] retain];
			[cell.layer insertSublayer:topShadow atIndex:0];
		}
		else if ([cell.layer.sublayers indexOfObjectIdenticalTo:topShadow] != 0)
		{
			[cell.layer insertSublayer:topShadow atIndex:0];
		}
		
		CGRect shadowFrame = topShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = -SHADOW_INVERSE_HEIGHT;
		topShadow.frame = shadowFrame;
	}
	else
	{
		[topShadow removeFromSuperlayer];
		[topShadow release];
		topShadow = nil;
	}
	
	NSIndexPath *lastRow = [indexPathsForVisibleRows lastObject];
	if ([lastRow section] == [self numberOfSections] - 1 &&
		[lastRow row] == [self numberOfRowsInSection:[lastRow section]] - 1)
	{
		UIView *cell =
		[self cellForRowAtIndexPath:lastRow];
		if (!bottomShadow)
		{
			bottomShadow = [[self shadowAsInverse:NO] retain];
			[cell.layer insertSublayer:bottomShadow atIndex:0];
		}
		else if ([cell.layer.sublayers indexOfObjectIdenticalTo:bottomShadow] != 0)
		{
			[cell.layer insertSublayer:bottomShadow atIndex:0];
		}
		
		CGRect shadowFrame = bottomShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = cell.frame.size.height;
		bottomShadow.frame = shadowFrame;
	}
	else
	{
		[bottomShadow removeFromSuperlayer];
		[bottomShadow release];
		bottomShadow = nil;
	}
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[topShadow release];
	[bottomShadow release];
	
	[super dealloc];
}

-(void)drawBackgroundGradient:(CGContextRef)context{
	CGContextRef currentContext = context;
	
	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0,1.0 };
	CGFloat components[8] = {
		0.09, 0.47, 0.60, 1.0,
	//	0.65, 0.5, 0.2, 0.5,
		0.09, 0.47, 0.60, 0.4,
	}; 
	
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetHeight(currentBounds));
	
	CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
	
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace); 
}

-(void)drawForegroundGradient:(CGContextRef)context{
	CGContextRef currentContext = context;
	
	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
	
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	
	
	CGPoint topCenter1 = CGPointMake(0, 0.0f);
	CGPoint midCenter1 = CGPointMake(320, 30); 
	
	
	CGFloat locations1[2] = { 0.0, 1.0  };
	CGFloat components1[8] = {
		1.0, 1.0, 1.0, 0.3,
		1.0, 1.0, 1.0, 0.01
	};
	
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components1, locations1, num_locations);
	
	CGContextDrawLinearGradient(currentContext, glossGradient, topCenter1, midCenter1, 0);
	//CGContextDrawRadialGradient(currentContext, glossGradient, topCenter1, 500, midCenter1, 5, 1);
	
	
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace); 
}

@end
