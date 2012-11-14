
@protocol DownloadOperationDelegate;

@interface DownloadOperation : NSOperation
{
    // NSOperation support
    BOOL isExecuting;
    BOOL isFinished;
    // networking
    NSURLRequest *request;
    NSURLConnection *connection;
    NSMutableData *receivedData;
    id<DownloadOperationDelegate> doDelegate;
}
@property(nonatomic,assign) id<DownloadOperationDelegate> doDelegate;
@property(readonly) BOOL isExecuting;
@property(readonly) BOOL isFinished;

@property(readonly) NSMutableData *receivedData;

-(id)initWithURL:(NSURLRequest *)arequest withDelegate:(id )aDelegate;

@end

@protocol DownloadOperationDelegate <NSObject>
@optional
-(void)didFailed:(NSError*)error;
-(void)didReceiveData:(NSData*)data;
@end