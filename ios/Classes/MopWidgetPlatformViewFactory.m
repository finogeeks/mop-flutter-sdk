#import "MopWidgetPlatformViewFactory.h"
#import "MopWidgetPlatformView.h"

@interface MopWidgetPlatformViewFactory () {
    NSObject<FlutterBinaryMessenger>* _messenger;
}
@end

@implementation MopWidgetPlatformViewFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [[MopWidgetPlatformView alloc] initWithFrame:frame
                                         viewIdentifier:viewId
                                              arguments:args
                                        binaryMessenger:_messenger];
}

@end
