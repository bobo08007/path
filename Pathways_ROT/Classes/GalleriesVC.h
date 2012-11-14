//
//  GalleriesVC.h
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20.h"
#import "TTThumbsViewController.h"
enum {
    GalleryViewTypeNormal,
    GalleryViewTypePicker
};
typedef NSUInteger GalleryViewType;

@class GalleryPhoto;

@interface GalleriesVC : TTThumbsViewController<NSFetchedResultsControllerDelegate> {
    GalleryViewType _sourceType;
    id _pickerDelegate;
}
@property(nonatomic)           GalleryViewType     sourceType;
@property(assign) id pickerDelegate;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end