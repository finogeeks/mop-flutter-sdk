#import <Flutter/Flutter.h>

@interface MopEventStream : NSObject <FlutterStreamHandler>
- (void)send:(NSString *)channel event:(NSString *)event body:(id)body;
@end

@interface MopPlugin : NSObject <FlutterPlugin>
@property MopEventStream *mopEventStreamHandler;

@end
