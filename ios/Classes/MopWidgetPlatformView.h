#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface MopWidgetPlatformView : NSObject <FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
