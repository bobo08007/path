//
//  CustomHeader.m
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "CustomHeader.h"
#import "UIView+Gradient.h"

@implementation CustomHeader
@synthesize titleLabel = _titleLabel;
@synthesize lightColor = _lightColor;
@synthesize darkColor = _darkColor;

- (id)init {
    if ((self = [super init])) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.titleLabel = [[[UILabel alloc] init] autorelease];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.opaque = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_titleLabel];
        self.lightColor = [UIColor colorWithRed:105.0f/255.0f green:179.0f/255.0f blue:216.0f/255.0f alpha:1.0];
        self.darkColor = [UIColor colorWithRed:21.0/255.0 green:92.0/255.0 blue:136.0/255.0 alpha:1.0];        
    }
    return self;
}
-(id)initWithFrame:(CGRect)rect{
	if (self = [super initWithFrame:rect]){
		self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.titleLabel = [[[UILabel alloc] init] autorelease];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.opaque = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_titleLabel];
        self.lightColor = [UIColor colorWithRed:105.0f/255.0f green:179.0f/255.0f blue:216.0f/255.0f alpha:1.0];
        self.darkColor = [UIColor colorWithRed:21.0/255.0 green:92.0/255.0 blue:136.0/255.0 alpha:1.0];       
	}
	
	return self;
}

-(void) layoutSubviews {
       
    CGFloat coloredBoxMargin = 0.75;
    CGFloat coloredBoxHeight = CGRectGetHeight(self.frame)-coloredBoxMargin*2;
    _coloredBoxRect = CGRectMake(coloredBoxMargin, 
                                 coloredBoxMargin, 
                                 self.bounds.size.width-coloredBoxMargin*2, 
                                 coloredBoxHeight);
    
	_titleLabel.frame = CGRectMake(coloredBoxMargin+10, 
								   coloredBoxMargin, 
								   self.bounds.size.width-coloredBoxMargin*2-10, 
								   coloredBoxHeight);;
        
}

- (void)drawRect:(CGRect)rect {
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    CGColorRef greenColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0].CGColor;
        
    CGContextSetFillColorWithColor(context, redColor);
    CGContextFillRect(context, _coloredBoxRect);
    
    CGContextSetFillColorWithColor(context, greenColor);
    CGContextFillRect(context, _paperRect);
    */
        
    CGContextRef context = UIGraphicsGetCurrentContext();    

    CGColorRef lightColor = _lightColor.CGColor;
    CGColorRef darkColor = _darkColor.CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5].CGColor;   
   


    // Draw shadow
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
    CGContextSetFillColorWithColor(context, lightColor);
    CGContextFillRect(context, _coloredBoxRect);
    CGContextRestoreGState(context);
    
    // Draw gloss and gradient
    drawGlossAndGradient(context, _coloredBoxRect, lightColor, darkColor);  

    // Draw stroke
    CGContextSetStrokeColorWithColor(context, darkColor);
    CGContextSetLineWidth(context, 1.0);    
    CGContextStrokeRect(context, rectFor1PxStroke(_coloredBoxRect));    
    
}


- (void)dealloc {
    [_titleLabel release];
    _titleLabel = nil;
    [_lightColor release];
    _lightColor = nil;
    [_darkColor release];
    _darkColor = nil;
    [super dealloc];
}


@end
