//
//  HomeVC.h
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20.h"

#import <QuartzCore/QuartzCore.h>
#import "BlockAlertView.h"
#import "BlockActionSheet.h"
#import "BlockTextPromptAlertView.h"

@class LandingView;

@interface HomeVC :  UIViewController {
	IBOutlet LandingView *_launcherView;
    IBOutlet UIButton *btnDraw;
    IBOutlet UIButton *btnEvents;
    IBOutlet UIButton *btnGallery;
    IBOutlet UIButton *btnRegister;
    IBOutlet UIButton *btnDrawBack;
    IBOutlet UIButton *btnOnBoard;
    IBOutlet UIButton *btnOutLine;
    IBOutlet UIButton *btnMore;
    
    IBOutlet UIImageView *img;
    BlockAlertView *altLogIn;
    UIAlertView *altLogIn01;
    NSManagedObjectContext *managedObjectContext;

}

@property(nonatomic, readonly) LandingView *launcherView;
-(IBAction)buttonAction:(UIButton*)sender;
-(void)logIn:(NSString*)UserID password:(NSString*)password;
-(void)showLogIn:(NSString*)UserID password:(NSString*)password;
-(void)logInWebservice:(NSDictionary*)dicDetails;
-(void)downloadWebservice;
@end
