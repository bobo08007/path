//
//  GalleriesVC.m
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GalleriesVC.h"
#import "MockPhotoSource.h"
#import "GalleryPhoto.h"
#import "GlobalSettings.h"
#import "TTPhotoViewController.h"
#import "DrawVC.h"

@implementation GalleriesVC
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;

@synthesize sourceType =_sourceType;
@synthesize  pickerDelegate = _pickerDelegate;

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GalleryPhoto" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastModified" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}

-(GalleryPhoto*)galleryPhotoForURL:(NSString*)aURL
{
    NSArray *allPhotos = [self.fetchedResultsController fetchedObjects];
    
    NSString *actualPath = [aURL stringByReplacingOccurrencesOfString:@"documents://" withString:@""];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoName=%@",actualPath];
    
    NSArray *result = [allPhotos filteredArrayUsingPredicate:predicate];
    
    return result.count>0?[result objectAtIndex:0]:nil;
}

-(void)editCurrentImage:(NSString*)aURL{
 
    NSString* URL = aURL;
    GalleryPhoto *selectedPhoto = [self galleryPhotoForURL:URL];
    if(selectedPhoto)
    {
        DrawVC *rootViewController = [[DrawVC alloc] initWithNibName:@"DrawVC" bundle:nil];
        rootViewController.editingPhoto = selectedPhoto;
        UIImage* image = [[TTURLCache sharedCache] imageForURL:URL];
        [rootViewController performSelector:@selector(setBackgroundImage:) withObject:image];
        
        UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        
        [self presentModalViewController:navController animated:YES];
        
        [rootViewController release];
        [navController release];
    }
}

- (void)thumbsTableViewCell:(TTThumbsTableViewCell*)cell didSelectPhoto:(id<TTPhoto>)photo {
    NSString* URL = [photo URLForVersion:TTPhotoVersionThumbnail];
    
    if (_sourceType == GalleryViewTypeNormal)
            [self editCurrentImage:URL];
    else
    {
        if (URL)
        {
            UIImage* image = [[TTURLCache sharedCache] imageForURL:URL];
            if([_pickerDelegate respondsToSelector:@selector(setBackgroundImage:)]){
                [_pickerDelegate performSelector:@selector(setBackgroundImage:) withObject:image];
            }
        }
        
        UIApplication *application = [UIApplication sharedApplication];
        [application setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        [self dismissModalViewController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = 0;
    
    NSLog(@"W %f",self.tableView.frame.size.width);
    
	UIImage *logoImage = [UIImage imageNamed:@"smallogo2.png"];
	UIImageView *logoView = [[UIImageView alloc] initWithImage:logoImage];
	logoView.frame = CGRectMake(0, 0, logoImage.size.width, 44);
	
	UIBarButtonItem* homeButton = [[UIBarButtonItem alloc] initWithCustomView:logoView];
	[self.navigationItem setRightBarButtonItem:homeButton animated:YES];
	[homeButton release];
	[logoView release];
    
    NSArray *allPhotos = [self.fetchedResultsController fetchedObjects];
    NSMutableArray *mocPhotos = [[NSMutableArray alloc] initWithCapacity:allPhotos.count];
    for (GalleryPhoto *gphoto in allPhotos)
    {
        MockPhoto *mPhoto = [[MockPhoto alloc] initWithURL:nil smallURL:[NSString stringWithFormat:@"documents://%@",gphoto.photoName] size:CGSizeMake(0, 0) caption:@"Pathways."] ;  
        [mocPhotos addObject:mPhoto];
        [mPhoto release];
    }
    
	self.title = @"Gallery";
    
	self.photoSource = [[[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal title:@"Gallery Photos" photos:mocPhotos photos2:nil] autorelease];
    
    [mocPhotos release];
    
    NSLog(@"self.tableView %f",self.tableView.frame.size.width);
}

-(IBAction)Cancelbuttonaction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)Donebuttonaction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc
{
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}

@end
