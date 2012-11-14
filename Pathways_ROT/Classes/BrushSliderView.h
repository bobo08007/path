//
//  BrushSliderView.h
//  Pathways
//
//  Created by iMac on 16/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Brush;

@interface BrushSliderView : UIView {
	Brush *brush;
	UISlider *slider;
	NSTimer *timer;
	id brushSliderDelegate;
    bool isBrush;
}
@property(assign)   id brushSliderDelegate;
@property(assign)   bool isBrush;
@property(nonatomic,retain) NSMutableDictionary *dicSliderValue;
@property (nonatomic,retain) UIColor *brushColors;
@property (nonatomic,retain) UIColor *eraserColor;
@property (nonatomic,retain) UISlider *slider;

-(void)setBrush:(Brush*)aBrush;
-(void)sliderAction;
-(void)setSliderValue;
@end
