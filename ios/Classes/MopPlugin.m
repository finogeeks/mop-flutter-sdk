#import "MopPlugin.h"
#import "MOPBaseApi.h"
#import "MOPApiRequest.h"
#import "MOPApiConverter.h"

@implementation MopEventStream {
    FlutterEventSink _eventSink;
}

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events {
    _eventSink = events;
    return nil;
}
- (void)send:(NSString *)channel event:(NSString *)event body:(id)body {
    if (_eventSink) {
        NSDictionary *dictionary = @{@"channel": channel, @"event": event, @"body": body};
        _eventSink(dictionary);
    }
}


- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}
@end


@implementation MopPlugin

static MopPlugin *_instance;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"mop"
            binaryMessenger:[registrar messenger]];
    _instance = [[MopPlugin alloc] init];
    [registrar addApplicationDelegate:_instance];
    [registrar addMethodCallDelegate:_instance channel:channel];
    _instance.methodChannel = channel;

    FlutterEventChannel *mopEventChannel = [FlutterEventChannel eventChannelWithName:@"plugins.mop.finogeeks.com/mop_event" binaryMessenger:[registrar messenger]];
    _instance.mopEventStreamHandler = [[MopEventStream alloc] init];
    [mopEventChannel setStreamHandler:_instance.mopEventStreamHandler];
    
    FlutterMethodChannel* shareChannel = [FlutterMethodChannel
        methodChannelWithName:@"plugins.finosprite.finogeeks.com/share"
              binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:_instance channel:shareChannel];
    _instance.shareMethodChannel = shareChannel;
}

+ (instancetype)instance{
    return _instance;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
      MOPApiRequest* request = [[MOPApiRequest alloc] init];
      request.command = call.method;
      request.param = (NSDictionary*)call.arguments;
      MOPBaseApi* api = [MOPApiConverter apiWithRequest: request];
      if (api) {
          [api setupApiWithSuccess:^(NSDictionary<NSString *,id> * _Nonnull data) {
              result(@{@"retMsg":@"ok",@"success":@(YES),@"data": data});
          } failure:^(id _Nullable error) {
              if ([error isKindOfClass:[NSDictionary class]]) {
                  NSDictionary* dict = (NSDictionary*)error;
                  if (dict != nil) {
                      result(@{@"retMsg": dict ,@"success":@(NO)});
                  } else {
                      result(@{@"retMsg": @"其它错误" ,@"success":@(NO)});
                  }
              } else {
                  result(@{@"retMsg": error ,@"success":@(NO)});
              }
          } cancel:^{
              
          }];
      } else {
          result(FlutterMethodNotImplemented);
      }
  }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    return [[FATClient sharedClient] handleOpenURL:url];
}

@end
