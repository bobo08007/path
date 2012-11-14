//
//  BrushColorPicker.h
//  Pathways
//
//  Created by iMac on 18/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerView.h"

@class Brush;
@interface BrushColorPicker : UIView<ColorPickerViewDelegate>{
	Brush *brush;
	ColorPickerView *colorPicker;
	//UISlider *slider;
	//	UIButton *sizeButton;
	//	UIButton *colorButton;
	id bcDelegate;
    UIButton *closeButton;
    UISegmentedControl *segmentControl;

}
-(ColorPickerView*)getColorPickerView;
@property(assign) 	id bcDelegate;
-(void)setBrush:(Brush*)aBrush;
@end
