//
//  DrawBackVC.m
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawBackVC.h"
#import "Three20.h"

@implementation DrawBackVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"DrawBack";
    UIImage *logoImage = [UIImage imageNamed:@"smallogo2.png"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logoImage];
    logoView.frame = CGRectMake(0, 0, logoImage.size.width, 44);

    UIBarButtonItem* camera = [[UIBarButtonItem alloc] initWithCustomView:logoView];
    [self.navigationItem setRightBarButtonItem:camera animated:YES];
    [camera release];
    [logoView release];
    self.view.backgroundColor = TTSTYLEVAR(screenBackgroundColor);
    self.navigationController.navigationBar.tintColor = TTSTYLEVAR(navigationBarTintColor);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
