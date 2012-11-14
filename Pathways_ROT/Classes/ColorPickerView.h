//
//  ColorPickerView.h
//  Pathways
//
//  Created by iMac on 09/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANImageBitmapRep.h"

@protocol ColorPickerViewDelegate

- (void)colorChanged:(UIColor *)newColor;

@end

@class ColorView;

@interface ColorPickerView : UIView {
	UIImage * colorWheelImage;
	UIImage * brightnessBarImage;
	UIImage * brightnessIndicatorImage;
	UIColor * lastColor;
	
	ANImageBitmapRep * wheelAdjusted;
	CGRect brightnessBarFrame;
	CGRect brightnessIndicatorFrame;	
	CGRect colorWheelFrame;
	float brightnessPCT;
	CGPoint selectedPoint;
    CGPoint selectedPointBrush;
	CGPoint selectedPointBGColor;    
	id <ColorPickerViewDelegate> delegate;
	BOOL drawsSquareIndicator;
    BOOL isForBrush;
	
}

@property (nonatomic, assign) id <ColorPickerViewDelegate> delegate;
@property (readwrite) BOOL drawsSquareIndicator;
-(void)colorPickerFor:(BOOL)isBrush;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (UIColor *)color;
- (void)setBrightness:(float)_brightness;
- (void)setColor:(UIColor*)color;
- (float)brightness;


@end
