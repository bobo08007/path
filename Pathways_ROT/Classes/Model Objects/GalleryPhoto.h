//
//  GalleryPhoto.h
//  Pathways
//
//  Created by SRAimac2 on 02/05/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GalleryPhoto : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * photoName;
@property (nonatomic, retain) NSDate * lastModified;

@end
