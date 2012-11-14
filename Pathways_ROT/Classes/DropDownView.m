//
//  DropDownView.m
//  Pathways
//
//  Created by iMac on 10/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DropDownView.h"


@implementation DropDownView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}
-(void)setImage:(UIImage*)aImage{
	image = aImage;
	[self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
	[image drawInRect:rect];
}

- (void)dealloc {
    [super dealloc];
}


@end
