//
//  CommentView.m
//  UniMall
//
//  Created by iMac on 07/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShadowView.h"
#import "UIView+Gradient.h"
@implementation ShadowView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}
UIColor *bgColor;
-(void)setDrawBackgroundColor:(UIColor *)aColor{
	bgColor = [aColor retain];
}
/*
- (void)drawRect:(CGRect)rect {
	if(!bgColor)
		[[UIColor colorWithRed:0 green:0.67 blue:0.84 alpha:1] set];
	else
		[bgColor set];
	
	UIBezierPath *rectsbyround = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
	rectsbyround.lineWidth = 2;
	rectsbyround.usesEvenOddFillRule =YES;
    [rectsbyround fill];
	[[UIColor colorWithWhite:1.0 alpha:1.0] set];
	
    [rectsbyround stroke];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 
											  blue:0.2 alpha:0.5].CGColor;
	CGContextSaveGState(context);
	CGContextSetShadow(context, CGSizeMake(0, 10), 0.6);
	CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
	CGContextRestoreGState(context);
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
