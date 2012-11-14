//
//  RegisterVC.m
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegisterVC.h"
#import "Three20.h"
#import "NSOperationQueue+CWSharedQueue.h"
#import "GlobalSettings.h"

#import "XMLReader.h"

@implementation RegisterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
//        //viewReg.frame = CGRectMake((self.view.frame.size.width-320)/2, (self.view.frame.size.height-500)/2, 320, 480);
//    }
    
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RegisterBG.png"]];	
    
//    UIImage *btn_BG = [UIImage imageNamed:@"Form_0010_submitl-copy.png"];
//    [registerButton setBackgroundImage:btn_BG forState:UIControlStateNormal];
//    registerButton.frame = CGRectMake(registerButton.frame.origin.x, registerButton.frame.origin.y, btn_BG.size.width, btn_BG.size.height);


}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor = TTSTYLEVAR(navigationBarTintColor);
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    BOOL isRegistered = [defaults boolForKey:@"isRegistered"];
//    
//    if(isRegistered){
//        
//        [registerButton removeTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
//        [registerButton addTarget:self action:@selector(editAbuttonAction) forControlEvents:UIControlEventTouchUpInside];
//        [registerButton setTitle:@"Edit      " forState:UIControlStateNormal];
//        
//        self.title = @"Edit Details";
//        
//        int index = 1;
//        
//        for (index = 1; index <=5; index++) {
//            
//            UITextField *textfield = (UITextField*)[self.view viewWithTag:index];
//            textfield.text = [defaults valueForKey:textfield.placeholder];
//            textfield.enabled = NO;
//        }
//    } else {
        self.title = @"Register";

//    }
        


}
-(void)editAbuttonAction{
    [registerButton removeTarget:self action:@selector(editAbuttonAction) forControlEvents:UIControlEventTouchUpInside];
    [registerButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"Save     " forState:UIControlStateNormal];
    
    int index = 1;
    
    for (index = 1; index <=5; index++) {
        
        UITextField *textfield = (UITextField*)[self.view viewWithTag:index];
        textfield.clearButtonMode = UITextFieldViewModeAlways;
        textfield.enabled = YES;
    }

    
}
-(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL sticterFilter = YES; 
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = sticterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction)submit:(id)sender
{
    if([GlobalSettings isNetworkAvailable]){
        int index = 1;
//        NSMutableString *soapMessage =  [[NSMutableString alloc] init];
//        [soapMessage appendString: @"<SOAP-ENV:Envelope\n"
//         "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
//         "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
//         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
//         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
//         "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"
//         "<SOAP-ENV:Body>\n"
//         "<RegisterUser xmlns=\"http://tempuri.org/\">\n"
//         "<firstName xsi:type=\"xsd:string\">First Name</firstName>\n"
//         "<lastName xsi:type=\"xsd:string\">Last Name</lastName>\n"
//         "<userName xsi:type=\"xsd:string\">User Name</userName>\n"
//         "<password xsi:type=\"xsd:string\">Password</password>\n"
//         "<email xsi:type=\"xsd:string\">E-Mail</email>\n"
//         "</RegisterUser>\n"
//         "</SOAP-ENV:Body>\n"
//         "</SOAP-ENV:Envelope>\n"]; ;
        NSMutableDictionary *dicReg = [[NSMutableDictionary alloc]init];
        for (index = 1; index <=4; index++) {
            
            UITextField *textfield = (UITextField*)[self.view viewWithTag:index];
            textfield.clearButtonMode = UITextFieldViewModeNever;
            
            
            NSString *key =  textfield.placeholder;
            NSString *value = textfield.text;
            
            [dicReg setObject:value forKey:key];
            
            NSLog(@"key %@",key);
            if (value == nil || [value isEqualToString:@""] || [value length] <= 0) {
                //Alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:[NSString stringWithFormat:@"Enter valid %@",key] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                return;
            }
            
            if([key isEqualToString:@"Email"])
            {
                BOOL isValid = [self NSStringIsValidEmail:value];
                if(isValid == FALSE){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:[NSString stringWithFormat:@"Enter valid Email"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    
                    return;
                }
                
            }
            
//            [soapMessage replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:NSMakeRange(0, [soapMessage length])];
        }
        if (![[dicReg objectForKey:@"Password"]isEqualToString:[dicReg objectForKey:@"Retype Password"]]) {
            UIAlertView *alert;
            alert= [[UIAlertView alloc] initWithTitle:@"Pathways" message:[NSString stringWithFormat:@"The Passwords you have entered do not match. Please retype the password."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return;
        }
        
//        NSURL *url = [NSURL URLWithString:@"http://220.225.234.204:6061/Pathways/PathwaysServices.asmx"];
//        
//        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
//        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];  
//        [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        [theRequest addValue:@"http://tempuri.org/RegisterUser" forHTTPHeaderField:@"SOAPAction"];
//        [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
//        [theRequest setHTTPMethod:@"POST"];
//        [theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [soapMessage release];
//        
//        
//        UIActivityIndicatorView *activityLabel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        activityLabel.tag = 100;
//        activityLabel.frame = CGRectMake(768/2-20/2, 1028/2-20/2, 20, 20);
//        [self.view addSubview:activityLabel];		
//        [activityLabel startAnimating];
//        [activityLabel release];
//        
//        
//        DownloadOperation *operation = [[DownloadOperation alloc] initWithURL:theRequest withDelegate:self];
//        
//        [operation setQueuePriority:NSOperationQueuePriorityHigh];
//        
//        [[NSOperationQueue sharedOperationQueue] addOperation:operation];
//        
//        [operation release];
//        
//        [theRequest release];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.pathwaystheproject.org/app/register.php?artist=%@&email=%@&password=%@&confirm_password=%@",[dicReg objectForKey:@"Artist"],[dicReg objectForKey:@"Email"],[dicReg objectForKey:@"Password"],[dicReg objectForKey:@"Retype Password"]]]];
        
        NSError *error = nil;
        NSURLResponse *response = nil;
        
        // Synchronous isn't ideal, 
        NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // Parse the XML Data into an NSDictionary
        NSDictionary *xmlDictionary = [[XMLReader dictionaryForXMLData:xmlData error:&error] retain];
        NSLog(@"xmlDictionary %@",xmlDictionary);
        NSDictionary *status = [xmlDictionary retrieveForPath:[NSString stringWithFormat:@"Response.status"]];
        
        NSLog(@"status %@",status);
        
        if (![[status valueForKey:@"status_message"]isEqualToString:@"Login Successful"])
        {
            [altLogIn show];
            
            [[[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat: @"%@",[status objectForKey:@"status_message"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease]show];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"Success" forKey:@"register"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults]setValue:@"Success" forKey:@"LogIn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[[[UIAlertView alloc]initWithTitle:nil message:@"You have registered successfully..." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease]show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:@"Please Check Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
        
}

-(void)didFailed:(NSError*)error{
    
}
-(void)didReceiveData:(NSData*)data{
    
    NSString *result_str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
    NSArray *Chunks = [result_str componentsSeparatedByString:@"<RegisterUserResult>"];
    
    [result_str release];
    
    NSArray *Chunks1 = [[Chunks objectAtIndex:1] componentsSeparatedByString:@"</RegisterUserResult>"];
    
    if(Chunks1.count>1){
        long userid = [[Chunks1 objectAtIndex:0] intValue];
        if (userid != 0) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[NSNumber numberWithLong:userid] forKey:@"userid"];
            [defaults setBool:YES forKey:@"isRegistered"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:@"Successfully registered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];

        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:@"Registration Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
             
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pathways" message:@"Registration Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissModalViewController];
        
}

- (void) animateTextField: (UITextField *) textField up: (BOOL) up {
    int movementDistance = 35; 
//	if (textField.tag == 1) {
//        movementDistance = 60;
//    } else if (textField.tag == 2) {
//        movementDistance = 80;
//    } else if (textField.tag == 3) {
//        movementDistance = 80;
//    } else if (textField.tag == 4) {
//        movementDistance = 80;
//    } else if (textField.tag == 5) {
//        movementDistance = 80;
//    } 
    movementDistance = movementDistance*textField.tag;
    
    const float movementDuration = 0.3f; // tweak as needed
	
    int movement = (up ? -movementDistance : movementDistance);
	
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	//self.view.frame = CGRectOffset(self.view.frame, movement, 0);
    [UIView commitAnimations];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField 
{
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self animateTextField: textField up: YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:textField.text forKey:textField.placeholder];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self animateTextField: textField up: NO];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
	return YES;
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
	return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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

-(IBAction)LogIn:(id)sender
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
        BlockAlertView *altLogIn1 = [BlockAlertView alertWithTitle:@"LogIn" message:@"The login ID you entered is incorrect.Please enter the correct E-mail/Password to continue."isLogIn:NO];
        
        //        [altLogIn1 setDestructiveButtonWithTitle:@"Calcel" block:nil];
        [altLogIn1 addButtonWithTitle:@"    Okay! ! !   " block:^{
            [self showLogIn:[dicDetails valueForKey:@"UserID"] password: [dicDetails valueForKey:@"password"]];
        }];
        
        [altLogIn1 show];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"Success" forKey:@"LogIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView==altLogIn)
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
