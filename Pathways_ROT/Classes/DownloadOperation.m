#import "DownloadOperation.h"

@interface DownloadOperation ()
@property(assign) BOOL isExecuting;
@property(assign) BOOL isFinished;
@end

@implementation DownloadOperation
@synthesize isExecuting, isFinished, receivedData;

@synthesize doDelegate;

-(id)initWithURL:(NSURLRequest *)arequest withDelegate:(id )aDelegate {
	
    self = [super init];
    request = [arequest retain];
    self.doDelegate = aDelegate;
    
    return self;
}

- (void) dealloc
{
    [request release];
    [super dealloc];
}

#pragma mark NSOperation Stuff

- (void) start
{
    NSParameterAssert(request);

    // Bail out early if cancelled.
    if ([self isCancelled]) {
        [self setIsFinished:YES];
        [self setIsExecuting:NO];
        
		if (self.doDelegate != nil && [self.doDelegate respondsToSelector:@selector(didFailed:)]) {
			[self.doDelegate didFailed:nil];
		}
        return;
    }
    
    [self setIsExecuting:YES];
    [self setIsFinished:NO];
    
    receivedData = [[NSMutableData alloc] init];
    
    // Make sure the connection runs in the main run loop.
    connection = [[NSURLConnection alloc] initWithRequest:request
        delegate:self startImmediately:NO];
   
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
        forMode:NSDefaultRunLoopMode];
    
    [connection start];
}

- (BOOL) isConcurrent
{
    return YES;
}

#pragma mark NSURLConnection Callbacks

- (void) connection: (NSURLConnection*) cn didReceiveData: (NSData*) data
{
    // Not cancelled, receive data.
    if (![self isCancelled]) {

        [receivedData appendData:data];
        return;
    }
    
    // Cancelled, tear down connection.
    [self setIsExecuting:NO];
    [self setIsFinished:YES];
    [connection cancel];
    [connection release];
    [receivedData release];
    
    if (self.doDelegate != nil && [self.doDelegate respondsToSelector:@selector(didFailed:)]) {
        [self.doDelegate didFailed:nil];
    }
}

- (void) connectionDidFinishLoading: (NSURLConnection*) cn
{
   
	if (self.doDelegate != nil && [self.doDelegate respondsToSelector:@selector(didReceiveData:)]) {
        [self.doDelegate didReceiveData:receivedData];
     //   [receivedData release];
     //   receivedData = nil;
    }
    
    [self setIsExecuting:NO];
    [self setIsFinished:YES];
	[connection release];

	
}

- (void) connection: (NSURLConnection*) cn didFailWithError: (NSError*) error
{
    [self setIsExecuting:NO];
    [self setIsFinished:YES];
    [connection release];
    [receivedData release];
	
	if (self.doDelegate != nil && [self.doDelegate respondsToSelector:@selector(didFailed:)]) {
        [self.doDelegate didFailed:error];
    }
}

// http://stackoverflow.com/questions/3573236
+ (BOOL) automaticallyNotifiesObserversForKey: (NSString*) key
{
    return YES;
}


@end
