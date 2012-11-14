//
//  HomeVC.m
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeVC.h"
#import "LandingView.h"
#import "TTDefaultStyleSheet.h"
#import "TTURLCache.h"
#import "LandingView.h"
#import "GalleriesVC.h"
#import "EventsVC.h"
#import "DrawVC.h"
#import "MoreVC.h"

#import "DrawBackVC.h"
#import "OutLineVC.h"
#import "RegisterVC.h"
#import "OnBoardVC.h"
#import "PathwaysAppDelegate.h"
#import "GlobalSettings.h"
#import "GalleryPhoto.h"

#import "XMLReader.h"
@interface HomeVC (Private)
- (void)dismissChildAnimated:(BOOL)animated;
@end


@implementation HomeVC

@synthesize launcherView = _launcherView;

-(IBAction)buttonAction:(UIButton*)sender{
    UIViewController *rootViewController = nil;
    
    if(sender.tag == 1)
        rootViewController = [[DrawVC alloc] initWithNibName:@"DrawVC" bundle:nil];
    else if(sender.tag == 2)
        rootViewController = [[EventsVC alloc] initWithNibName:@"EventsVC" bundle:nil];        
     else if(sender.tag == 3)
     {
        rootViewController = [[GalleriesVC alloc] initWithNibName:@"GalleriesVC" bundle:nil];
        ((GalleriesVC*)rootViewController).managedObjectContext = ((PathwaysAppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        ((GalleriesVC*)rootViewController).sourceType = GalleryViewTypeNormal;
    }
     else if(sender.tag == 4)
        rootViewController = [[RegisterVC alloc] initWithNibName:@"RegisterVC" bundle:nil];
     else if(sender.tag == 5)
        rootViewController = [[DrawBackVC alloc] initWithNibName:@"DrawBackVC" bundle:nil];
    else if(sender.tag == 6)
        rootViewController = [[OnBoardVC alloc] initWithNibName:@"OnBoardVC" bundle:nil];
    else if(sender.tag == 7)
        rootViewController = [[OutLineVC alloc] initWithNibName:@"OutLineVC" bundle:nil];
    else
    {
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"LogIn"]isEqualToString:@"Success"])
        {
            [[[[UIAlertView alloc]initWithTitle:nil message:@"You already login \n Do you wish to log out???" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Log out",@"Cancel", nil]autorelease]show];
        }
        else
        {
            altLogIn = [BlockAlertView alertWithTitle:@"LogIn" message:@"This is a very long message, designed just to show you how smart this class is"isLogIn:YES];
            [altLogIn setDestructiveButtonWithTitle:@"Cancel" block:nil];
            [altLogIn addButtonWithTitle:@"LogIn" block:^{
                [self logIn:altLogIn.txtID.text password: altLogIn.txtPassword.text];
            }];
            
            [altLogIn show];
        }
    }
//        rootViewController = [[MoreVC alloc] initWithNibName:@"MoreVC" bundle:nil]; 
    
    if (rootViewController==nil) {
        return;
    }
    UIBarButtonItem *launcherBarButtonItem = [[UIBarButtonItem alloc] initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/launcher.png") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissChild)];
    [rootViewController.navigationItem setLeftBarButtonItem:launcherBarButtonItem];
    [launcherBarButtonItem release];

    UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    if(sender.tag != 1 && sender.tag != 3 )
        navController.navigationBar.tintColor = [UIColor colorWithWhite:0 alpha:1];        
    else
        navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self presentModalViewController:navController animated:YES];

    [rootViewController release];
    [navController release];
}

-(void)showLogIn:(NSString*)UserID password:(NSString*)password
{
    altLogIn = [BlockAlertView alertWithTitle:@"LogIn" message:@"This is a very long message, designed just to show you how smart this class is"isLogIn:YES];
    
    altLogIn.txtID.text = UserID;
    altLogIn.txtPassword.text = password;
    
    [altLogIn setDestructiveButtonWithTitle:@"Cancel" block:nil];
    [altLogIn addButtonWithTitle:@"LogIn" block:^{
        [self logIn:altLogIn.txtID.text password: altLogIn.txtPassword.text];
    }];
    
    [altLogIn show];
}

-(void)logIn:(NSString*)UserID password:(NSString*)password
{
    if ([UserID length]==0 || [password length]==0)
    {
        BlockAlertView *altLogIn1 = [BlockAlertView alertWithTitle:@"LogIn" message:@"Please enter proper ID/Password"isLogIn:NO];
        
        [altLogIn1 addButtonWithTitle:@"    Okay! ! !   " block:^{
            [self showLogIn:UserID password: password];
        }];
        
        [altLogIn1 show];
    }
    else
    {
        NSDictionary *extraParams = [NSDictionary dictionaryWithObjectsAndKeys:UserID,@"UserID",password,@"password",nil];

        [NSThread detachNewThreadSelector:@selector(logInWebservice:) toTarget:self withObject:extraParams];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pathwaystheproject.org/app/login.php?email=%@&password=%@",UserID,password]]];
//        
//        NSError *error = nil;
//        NSURLResponse *response = nil;
//        
//        // Synchronous isn't ideal, but simplifies the code for the Demo
//        NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        
//        // Parse the XML Data into an NSDictionary
//        NSDictionary *xmlDictionary = [[XMLReader dictionaryForXMLData:xmlData error:&error] retain];
//        
//        NSDictionary *status = [xmlDictionary retrieveForPath:[NSString stringWithFormat:@"Response.status"]];
//        
//        NSLog(@"%@",[status valueForKey:@"status_message"]);
//        
//        if (![[status valueForKey:@"status_message"]isEqualToString:@"Login Successful"])
//        {
//            BlockAlertView *altLogIn1 = [BlockAlertView alertWithTitle:@"LogIn" message:@"Invalied login details... \n Please enter proper ID/Password"isLogIn:NO];
//            
//            //        [altLogIn1 setDestructiveButtonWithTitle:@"Calcel" block:nil];
//            [altLogIn1 addButtonWithTitle:@"    Okay! ! !   " block:^{
//                [self showLogIn:UserID password: password];
//            }];
//            
//            [altLogIn1 show];
//        }
//        else
//        {
//            [[NSUserDefaults standardUserDefaults]setValue:@"Success" forKey:@"LogIn"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
    }
}

-(void)logInWebservice:(NSDictionary*)dicDetails
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pathwaystheproject.org/app/login.php?email=%@&password=%@",[dicDetails valueForKey:@"UserID"],[dicDetails valueForKey:@"password"]]]];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    // Synchronous isn't ideal, but simplifies the code for the Demo
    NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Parse the XML Data into an NSDictionary
    NSDictionary *xmlDictionary = [[XMLReader dictionaryForXMLData:xmlData error:&error] retain];
    
    NSDictionary *status = [xmlDictionary retrieveForPath:[NSString stringWithFormat:@"Response.status"]];
    
    NSLog(@"%@",[status valueForKey:@"status_message"]);
    
    if (![[status valueForKey:@"status_message"]isEqualToString:@"Login Successful"])
    {
        BlockAlertView *altLogIn1 = [BlockAlertView alertWithTitle:@"LogIn" message:@"Invalied login details... \n Please enter proper ID/Password"isLogIn:NO];
        
        //        [altLogIn1 setDestructiveButtonWithTitle:@"Calcel" block:nil];
        [altLogIn1 addButtonWithTitle:@"    Okay! ! !   " block:^{
            [self showLogIn:[dicDetails valueForKey:@"UserID"] password: [dicDetails valueForKey:@"password"]];
        }];
        
        [altLogIn1 show];
    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(downloadWebservice) toTarget:self withObject:nil];
        [[NSUserDefaults standardUserDefaults]setValue:@"Success" forKey:@"LogIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)downloadWebservice
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pathwaystheproject.org/app/image.php?slice=1&user_id=3"]]];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    // Synchronous isn't ideal, but simplifies the code for the Demo
    NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Parse the XML Data into an NSDictionary
    NSDictionary *xmlDictionary = [[XMLReader dictionaryForXMLData:xmlData error:&error] retain];
    
    NSDictionary *status = [xmlDictionary retrieveForPath:[NSString stringWithFormat:@"Response.status"]];
    
    NSLog(@"%@",[status valueForKey:@"img_url"]);
    
    if ([[status valueForKey:@"img_url"]isEqualToString:@""])
    {
        [[[[UIAlertView alloc]initWithTitle:nil message:@"There is no new image on server" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay!!!", nil]autorelease]show];
    }
    else
    {
        PathwaysAppDelegate *appDelegete = (PathwaysAppDelegate *)[UIApplication sharedApplication].delegate;
        
        GalleryPhoto *newPhoto;
        NSManagedObjectContext *context = appDelegete.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"GalleryPhoto" inManagedObjectContext:context];
        newPhoto = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        newPhoto.createdDate = [NSDate date];
        newPhoto.lastModified = [NSDate date];

        NSString *photoName = [NSString stringWithFormat:@"Galley_%f.png",[[NSDate date] timeIntervalSince1970]];
        newPhoto.photoName = photoName;
        NSData *theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[status valueForKey:@"img_url"]]]  ;//= UIImagePNGRepresentation(theImage);
        [GlobalSettings saveimageData:theData imageFileName:photoName];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet 
{
    [[actionSheet layer] setBackgroundColor:[UIColor redColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_launcherView);
    [super dealloc];
}

- (void)viewDidLoad 
{
	[super loadView];
    
    
//	_launcherView = [[LandingView alloc] initWithFrame:self.view.bounds];
	//self.navigationController.navigationBar.tintColor =  TTSTYLEVAR(navigationBarTintColor);
//	self.view = _launcherView;
//	self.view.backgroundColor = TTSTYLEVAR(screenBackgroundColor);
	self.navigationController.navigationBar.tintColor = TTSTYLEVAR(navigationBarTintColor);
	self.title = @"Home";
	
	UIImage *logoImage = [UIImage imageNamed:@"smallogo2.png"];
	UIImageView *logoView = [[UIImageView alloc] initWithImage:logoImage];
	logoView.frame = CGRectMake(0, 0, logoImage.size.width, 44);
	
	UIBarButtonItem* camera = [[UIBarButtonItem alloc] initWithCustomView:logoView];
	[self.navigationItem setRightBarButtonItem:camera animated:YES];
	[camera release];
	[logoView release];
    
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//    {
//        self.view.frame = CGRectMake(0, 0, 768, 1024);
//        
//        btnDraw.frame = CGRectMake(310, 100, 150, 150);
//        btnEvents.frame = CGRectMake(70, 330, 150, 150);
//        btnGallery.frame = CGRectMake(300, 330, 150, 150);
//        btnRegister.frame = CGRectMake(514, 330, 150, 150);
//        btnDrawBack.frame = CGRectMake(70, 500, 150, 150);
//        btnOnBoard.frame = CGRectMake(300, 500, 150, 150);
//        btnOutLine.frame = CGRectMake(514, 500, 150, 150);
//        btnMore.frame = CGRectMake(300, 700, 150, 150);
//        img.frame = CGRectMake((self.view.frame.size.width-320)/2, 0, 320, 60);
//    }
//    else
//    {
//        self.view.frame = CGRectMake(0, 0, 320, 480);
//        btnDraw.frame = CGRectMake(110, 60, 100, 100);
//        btnEvents.frame = CGRectMake(30, 168, 100, 100);
//        btnGallery.frame = CGRectMake(122, 168, 100, 100);
//        btnRegister.frame = CGRectMake(214, 168, 100, 100);
//        btnDrawBack.frame = CGRectMake(30, 251, 100, 100);
//        btnOnBoard.frame = CGRectMake(122, 251, 100, 100);
//        btnOutLine.frame = CGRectMake(214, 251, 100, 100);
//        btnMore.frame = CGRectMake(122, 336, 100, 100);
//    }
}

#pragma mark -
#pragma mark Animation delegates

- (void)showAnimationDidStop {
}

- (void)fadeAnimationDidStop {
	[self dismissChildAnimated:NO];
}

- (void)dismissChild {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dismissChildAnimated:(BOOL)animated {
	[self dismissModalViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView==altLogIn01)
    {
        if (buttonIndex==0)
        {
            if ([[[alertView textFieldAtIndex:0]text]length]==0||[[[alertView textFieldAtIndex:1]text]length]==0)
            {
                [altLogIn show];
                
                [[[[UIAlertView alloc]initWithTitle:nil message:@"Please enter valid email id and password" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease]show];
            }
            else
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pathwaystheproject.org/app/login.php?email=%@&password=%@",[[alertView textFieldAtIndex:0]text],[[alertView textFieldAtIndex:1]text]]]];
                
                NSError *error = nil;
                NSURLResponse *response = nil;
                
                // Synchronous isn't ideal, but simplifies the code for the Demo
                NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                // Parse the XML Data into an NSDictionary
                NSDictionary *xmlDictionary = [[XMLReader dictionaryForXMLData:xmlData error:&error] retain];
                
                NSDictionary *status = [xmlDictionary retrieveForPath:[NSString stringWithFormat:@"Response.status"]];
                
                NSLog(@"%@",[status valueForKey:@"status_message"]);
                
                if (![[status valueForKey:@"status_message"]isEqualToString:@"Login Successful"])
                {
                    [altLogIn show];
                    
                    [[[[UIAlertView alloc]initWithTitle:nil message:@"Please enter valid email id and password" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease]show];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults]setValue:@"Success" forKey:@"LogIn"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }
    else
    {
        if (buttonIndex==0)
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"LogIn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end
