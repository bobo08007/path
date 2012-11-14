//
//  NSOperationQueue+CWSharedQueue.m
//  iCurrencyConvertor
//
//  Created by iMac on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSOperationQueue+CWSharedQueue.h"
@implementation NSOperationQueue (CWSharedQueue)

static NSOperationQueue* cw_sharedOperationQueue = nil;
static NSOperationQueue* cw_sharedOperationQueue_Images = nil;

+(NSOperationQueue*)sharedOperationQueue;
{
	if (cw_sharedOperationQueue == nil) {
		cw_sharedOperationQueue = [[NSOperationQueue alloc] init];
		[cw_sharedOperationQueue setMaxConcurrentOperationCount:CW_DEFAULT_OPERATION_COUNT];
	}
	return cw_sharedOperationQueue;
}
+(NSOperationQueue*)sharedOperationQueueImages{
	if (cw_sharedOperationQueue_Images == nil) {
		cw_sharedOperationQueue_Images = [[NSOperationQueue alloc] init];
		[cw_sharedOperationQueue_Images setMaxConcurrentOperationCount:CW_DEFAULT_OPERATION_COUNT];
	}
	return cw_sharedOperationQueue_Images;
	
}
+(void)setSharedOperationQueue:(NSOperationQueue*)operationQueue;
{
	if (operationQueue != cw_sharedOperationQueue) {
		[cw_sharedOperationQueue release];
		cw_sharedOperationQueue = [operationQueue retain];
	}
}

@end


@implementation NSObject (CWSharedQueue)

-(NSInvocationOperation*)performSelectorInBackgroundQueue:(SEL)aSelector withObject:(id)arg;
{
	NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:aSelector object:arg];
	[[NSOperationQueue sharedOperationQueue] addOperation:operation];
	return [operation autorelease];  
}

-(NSInvocationOperation*)performSelectorInBackgroundQueue:(SEL)aSelector withObject:(id)arg dependencies:(NSArray*)dependencies priority:(NSOperationQueuePriority)priority;
{
	NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:aSelector object:arg];
	[operation setQueuePriority:priority];
	for (NSOperation* dependency in dependencies) {
		[operation addDependency:dependency]; 
	}
	[[NSOperationQueue sharedOperationQueue] addOperation:operation];
	return [operation autorelease];  
}

@end
