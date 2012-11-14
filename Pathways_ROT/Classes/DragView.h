//
//  DragView.h
//  HelloWorld
//
//  Created by SRAimac2 on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Brush;


@interface DragView : UIImageView {
	IBOutlet UIViewController *viewController;
    BOOL isEraseMode;
	Brush *brush;
    UIImage *imgNew;
}
-(void)erase;
-(IBAction)setBrush:(Brush*)aBrush;
-(IBAction)eraserButtonAction:(id)sender;
-(IBAction)trash:(id)sender;

@property (assign) UIViewController *viewController;
@end
