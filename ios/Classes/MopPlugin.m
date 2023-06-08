#import "MopPlugin.h"
#import "MOPBaseApi.h"
#import "MOPApiRequest.h"
#import "MOPApiConverter.h"
#import "MOPAppletDelegate.h"
#import <mop/MOPTools.h>
#import "MopShareView.h"
#import <UIView+MOPFATToast.h>

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
    
    FlutterMethodChannel* appletChannel = [FlutterMethodChannel
        methodChannelWithName:@"plugins.finosprite.finogeeks.com/applet"
              binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:_instance channel:appletChannel];
    _instance.appletMethodChannel = appletChannel;
    
    FlutterMethodChannel* appletShareChannel = [FlutterMethodChannel
        methodChannelWithName:@"plugins.finosprite.finogeeks.com/share_applet"
              binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:_instance channel:appletShareChannel];
    _instance.shareAppletMethodChannel = appletShareChannel;

}

+ (instancetype)instance{
    return _instance;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  else if ([@"getAppletInfo" isEqualToString:call.method]) {
      result([self appInfoDictWithAppId:call.arguments[@"appId"]]);
  }
  else if ([@"getAbsolutePath" isEqualToString:call.method]) {
      NSString *path = call.arguments[@"path"];
      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      dict[@"path"] = [[FATClient sharedClient] fat_absolutePathWithPath:path];
      result(dict);
  }
  else if ([@"copyFileAsFinFile" isEqualToString:call.method]) {
      NSString *path = call.arguments[@"path"];
      NSString *fileName = [path componentsSeparatedByString:@"/"].lastObject;
      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      dict[@"path"] = [[FATClient sharedClient] saveFile:[NSData dataWithContentsOfFile:path] fileName:fileName];
      result(dict);
  }
  else if ([@"showShareAppletDialog" isEqualToString:call.method]) {
      UIImage *image = [[FATClient sharedClient] getDefaultCurrentAppletImage:440.0f];
          MopShareView *view = [MopShareView viewWithData:call.arguments];
          view.image = image;
          [view show];
          [view setDidSelcetTypeBlock:^(NSString *type) {
              result(type);
          }];
  }
  else if ([@"showLoading" isEqualToString:call.method]) {
      UIViewController *currentVC = [MOPTools topViewController];
      [currentVC.view fatMakeToastActivity:CSToastPositionCenter];
      result([self appInfoDictWithAppId:call.arguments[@"appId"]]);
  }
  else if ([@"hideLoading" isEqualToString:call.method]) {
      UIViewController *currentVC = [MOPTools topViewController];
      [currentVC.view fatHideToastActivity];
      [currentVC.view fatHideAllToasts];
      result([self appInfoDictWithAppId:call.arguments[@"appId"]]);
  }
  else if ([@"showToast" isEqualToString:call.method]) {
      UIViewController *currentVC = [MOPTools topViewController];
      [currentVC.view fatMakeToast:call.arguments[@"msg"]
                                       duration:2.0
                                       position:CSToastPositionCenter];
      result([self appInfoDictWithAppId:call.arguments[@"appId"]]);
  }
  else if ([@"getScreenshot" isEqualToString:call.method]) {
          UIImage *image = [[FATClient sharedClient] getDefaultCurrentAppletImage:0.0f];
          NSString *filePtah = [[FATClient sharedClient] saveFile:UIImagePNGRepresentation(image) fileName:[NSString stringWithFormat:@"%@",call.arguments[@"appId"]]];
          filePtah = [[FATClient sharedClient] fat_absolutePathWithPath:filePtah];
          result(filePtah);
  }
  else if ([@"getPhoneNumberResult" isEqualToString:call.method]) {
      if ([MOPAppletDelegate instance].bindGetPhoneNumbers) {
          [MOPAppletDelegate instance].bindGetPhoneNumbers(call.arguments);
        //   NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:call.arguments];
        //   NSString *jsonString = [dic[@"phone"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //   NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        //   NSError *error;
        //   NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        //   [MOPAppletDelegate instance].bindGetPhoneNumbers(jsonDic);
      }
  }
  else {
      MOPApiRequest* request = [[MOPApiRequest alloc] init];
      request.command = call.method;
      request.param = (NSDictionary*)call.arguments;
      MOPBaseApi* api = [MOPApiConverter apiWithRequest: request];
      if (api) {
          [api setupApiWithSuccess:^(NSDictionary<NSString *,id> * _Nonnull data) {
              result(@{@"retMsg":@"ok",@"success":@(YES),@"data": data ? : @{}});
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options
{
    NSString *string = url.absoluteString;
    if ([string containsString:@"finclipWebview/url="]) {
        if (![FATClient sharedClient].inited) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                FlutterMethodChannel *channel = [[MopPlugin instance] shareMethodChannel];
                [channel invokeMethod:@"shareApi:openURL" arguments:@{@"url":string} result:^(id  _Nullable result) {

                }];
            });
        }
        else {
            FlutterMethodChannel *channel = [[MopPlugin instance] shareMethodChannel];
            [channel invokeMethod:@"shareApi:openURL" arguments:@{@"url":string} result:^(id  _Nullable result) {

            }];
        }

        return YES;
    }
    
    if (![FATClient sharedClient].inited) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[FATClient sharedClient] handleOpenURL:url];
        });
    }
    return [[FATClient sharedClient] handleOpenURL:url];
}

- (BOOL)application:(UIApplication*)application
    continueUserActivity:(NSUserActivity*)userActivity
      restorationHandler:(void (^)(NSArray*))restorationHandler
{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        NSLog(@"url = %@",url.absoluteString);
        return [[FATClient sharedClient] handleOpenUniversalLinkURL:url];
    }
    return YES;
}


- (NSDictionary *)appInfoDictWithAppId:(NSString *)appId {
    FATAppletInfo *info = [[FATClient sharedClient] currentApplet];
    if ([appId isEqualToString:info.appId]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"appId"] = info.appId;
        switch (info.appletVersionType) {
            case FATAppletVersionTypeRelease: {
                dict[@"appType"] = @"release";
                break;
            }
            case FATAppletVersionTypeTrial: {
                dict[@"appType"] = @"trial";
                break;
            }
            case FATAppletVersionTypeTemporary: {
                dict[@"appType"] = @"temporary";
                break;
            }
            case FATAppletVersionTypeReview: {
                dict[@"appType"] = @"review";
                break;
            }
            case FATAppletVersionTypeDevelopment: {
                dict[@"appType"] = @"development";
                break;
            }

            default:
                break;
        }
        return dict;
    }
    return nil;;
}

@end
