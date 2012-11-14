//
//  EventCell.h
//  Pathways
//
//  Created by iMac on 24/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventCell : UITableViewCell {

}

-(void)drawBackgroundGradient:(CGContextRef)context;
-(void)drawForegroundGradient:(CGContextRef)context;
-(void)drawBackgroundGradientForCode:(CGContextRef)context;

-(CGGradientRef)getGradient1;
-(CGGradientRef)getGradient2;
-(CGGradientRef)getGradient3;
@end
