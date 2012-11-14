//
//  PwTableView.h
//  iCurrencyConvertor
//
//  Created by iMac on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PwTableView : UITableView {
	CAGradientLayer *originShadow;
	CAGradientLayer *topShadow;
	CAGradientLayer *bottomShadow;
}
-(void)drawBackgroundGradient:(CGContextRef)context;
-(void)drawForegroundGradient:(CGContextRef)context;

@end
