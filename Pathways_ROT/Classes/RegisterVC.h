//
//  RegisterVC.h
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadOperation.h"
#import "BlockAlertView.h"

@interface RegisterVC : UIViewController<DownloadOperationDelegate> {

    IBOutlet UIView *viewReg;
	NSMutableDictionary *userDetails;
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *btnLogIn;
    BlockAlertView *altLogIn;
}

-(IBAction)submit:(id)sender;
-(IBAction)LogIn:(id)sender;
-(void)logIn:(NSString*)UserID password:(NSString*)password;
-(void)showLogIn:(NSString*)UserID password:(NSString*)password;
-(void)logInWebservice:(NSDictionary*)dicDetails;

@end
