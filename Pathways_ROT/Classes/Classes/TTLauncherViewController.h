//
//  TTLauncherViewController.h
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.

#import "TTViewController.h"
#import "TTLauncherView.h"

@interface TTLauncherViewController : TTViewController <UINavigationControllerDelegate> {
	UIView *_overlayView;
	TTLauncherView *_launcherView;
	UINavigationController *_launcherNavigationController;
	UIViewController *_launcherNavigationControllerTopViewController;
}
@property(nonatomic, retain) UINavigationController *launcherNavigationController;
@property(nonatomic, readonly) TTLauncherView *launcherView;
@property(nonatomic, retain) UIViewController *launcherNavigationControllerTopViewController;

@end
