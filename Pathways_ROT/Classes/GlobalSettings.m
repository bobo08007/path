//
//  GlobalSettings.m
//  UniMall
//
//  Created by sanjeev rao on 22/01/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GlobalSettings.h"


static UIFont *labelFont = nil;
static UIFont *cellLabelFont = nil;
static UIFont *textFieldFont = nil;
static UIColor *labelTextColor = nil;
static UIColor *labelShadowColor = nil;
static UIColor *cellSeperatorColor = nil;
static UIColor *appBGColor = nil;
static NSDateFormatter *dateFormatter = nil;

static int systemOSVersion = 0;

@implementation GlobalSettings

+(NSString*)getBasePath{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doumentaryDirectoryPath=[paths objectAtIndex:0] ;
    NSString *directoryPath = doumentaryDirectoryPath;//[doumentaryDirectoryPath stringByAppendingPathComponent:@"paintImages"];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    BOOL isDir = YES;
//    if(![fm fileExistsAtPath:directoryPath isDirectory:&isDir]){
//        [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];    
//    } 

	return directoryPath;
}
+(NSString*)getPath:(NSString*)fileName{
	NSString *path=[[GlobalSettings getBasePath] stringByAppendingPathComponent:fileName];
	return path;
}

+(void)saveimageData:(NSData*)imageData imageFileName:(NSString*)fileName{
	NSString *path=[GlobalSettings getPath:fileName];
	[imageData writeToFile:path atomically:YES];
}
+(void)removeImageFile:(NSString*)fileName{
	NSString *path=[GlobalSettings getPath:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:path error:NULL];
}


+(int)getSystemOSVersion{
	
	if(systemOSVersion == 0){
		
		UIDevice *currentDevice = [UIDevice currentDevice];
		
		systemOSVersion = [currentDevice.systemVersion intValue];
		
	}
	return systemOSVersion;
}
+(UIFont*)cellLableFont{
	if(cellLabelFont == nil){
		cellLabelFont = [[UIFont boldSystemFontOfSize:13] retain];
	}
	return cellLabelFont;
}
+(int)customTableViewRowHeight{
	
	return 80;
}
+(int)tableViewRowHeight{
	return 44;
}

+(UIColor*)cellSeperatorColor{
	if(cellSeperatorColor == nil){
		cellSeperatorColor = [[UIColor colorWithWhite:0.8 alpha:0.7] retain];
	}
	
	return cellSeperatorColor;
	
}
+(NSDateFormatter*)dateFormatter{
	if(dateFormatter == nil){
		dateFormatter = [[NSDateFormatter alloc] init];	
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
	
}
+(UIFont*)lableFont{
	if(labelFont == nil){
		labelFont = [[UIFont boldSystemFontOfSize:15] retain];
	}
	return labelFont;
}
+(UIFont*)textFieldFont{
	if(textFieldFont == nil){
		textFieldFont = [[UIFont systemFontOfSize:14] retain];
	}
	
	return textFieldFont;
}
//[UIColor colorWithRed:0.054 green: 0.108 blue: 0.455 alpha:0.8]
+(UIColor*)labelReadTitleColor{
	return [UIColor colorWithRed:0.69 green:0.76 blue:0 alpha:1.0];
}
+(UIColor*)labelReadContentColor{
	return [UIColor colorWithRed:0.02 green: 0.21 blue: 0.31 alpha:1.0];
}
+(UIColor*)labelUnReadTitleColor{
		return [UIColor colorWithWhite:0.3 alpha:0.9];
}
+(UIColor*)labelUnReadContentColor{
		return [UIColor colorWithWhite:0.3 alpha:0.75];
}
+(UIColor*)labelCatColor{
	return [UIColor whiteColor];
}
+(UIColor*)labelTextColor{
	if(labelTextColor == nil){
		labelTextColor = [[UIColor colorWithWhite:1.0 alpha:0.75] retain];
	}
	
	return labelTextColor;
}
+(UIColor*)labelShadowColor{
	if(labelShadowColor == nil){
		labelShadowColor = [[UIColor colorWithWhite:0.0 alpha:0.4] retain];
	}
	
	return labelShadowColor;
}
+(CGSize)labelShadowOffset{
	return CGSizeMake(0, 1);
}
+(UIColor*)appBackgroundColor{
	if(appBGColor == nil){
		appBGColor = [[UIColor whiteColor] retain];
		[appBGColor retain];
	}
	
	return appBGColor;
	
}

+ (BOOL)isNetworkAvailable
{
	CFNetDiagnosticRef diag;        
	diag = CFNetDiagnosticCreateWithURL (NULL, (CFURLRef)[NSURL URLWithString:@"www.apple.com"]);
	
	CFNetDiagnosticStatus status;
	status = CFNetDiagnosticCopyNetworkStatusPassively (diag, NULL);        
	
	CFRelease (diag);
	
	if ( status == kCFNetDiagnosticConnectionUp )
	{
		//NSLog (@"Connection is up");
		return YES;
	} else {
		NSLog (@"Connection is down");
		return NO;
	}
}
@end
