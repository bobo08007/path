//
//  GlobalSettings.h
//  UniMall
//
//  Created by sanjeev rao on 22/01/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationMacros.h"

extern NSString *CategoriesChangedNotification;

@interface GlobalSettings : NSObject {

}
+(UIFont*)cellLableFont;
+(UIFont*)lableFont;
+(UIFont*)textFieldFont;
+(UIColor*)labelTextColor;
+(UIColor*)labelShadowColor;
+(UIColor*)appBackgroundColor;
+(UIColor*)cellSeperatorColor;
+(int)customTableViewRowHeight;
+(int)tableViewRowHeight;
+(CGSize)labelShadowOffset;
+(NSDateFormatter*)dateFormatter;
+(BOOL)isNetworkAvailable;
+(UIColor*)labelReadTitleColor;
+(UIColor*)labelReadContentColor;
+(UIColor*)labelUnReadTitleColor;
+(UIColor*)labelUnReadContentColor;
+(UIColor*)labelCatColor;

+(int)getSystemOSVersion;
+(NSString*)getBasePath;
+(NSString*)getPath:(NSString*)fileName;
+(void)saveimageData:(NSData*)imageData imageFileName:(NSString*)fileName;
+(void)removeImageFile:(NSString*)fileName;
@end
