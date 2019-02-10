#import "FlutterDynamicIconPlugin.h"

@implementation FlutterDynamicIconPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_dynamic_icon"
            binaryMessenger:[registrar messenger]];
  FlutterDynamicIconPlugin* instance = [[FlutterDynamicIconPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"mSupportsAlternateIcons" isEqualToString:call.method]) {
      if (@available(iOS 10.3, *)) {
          result(@(UIApplication.sharedApplication.supportsAlternateIcons));
      } else {
          result([FlutterError errorWithCode:@"UNAVAILABLE"
                                     message:@"Not supported on iOS ver < 10.3"
                                     details:nil]);
      }
  } else if ([@"mGetAlternateIconName" isEqualToString:call.method]) {
      if (@available(iOS 10.3, *)) {
          result(UIApplication.sharedApplication.alternateIconName);
      } else {
          result([FlutterError errorWithCode:@"UNAVAILABLE"
                                     message:@"Not supported on iOS ver < 10.3"
                                     details:nil]);
      }
  } else if ([@"mSetAlternateIconName" isEqualToString:call.method]) {
      if (@available(iOS 10.3, *)) {
          @try {
              NSString *iconName = call.arguments[@"iconName"];
              [UIApplication.sharedApplication setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
                  if(error) {
                      result([FlutterError errorWithCode:@"Failed to set icon"
                                                 message:[error description]
                                                 details:nil]);
                  } else {
                      result(nil);
                  }
              }];
          }
          @catch (NSException *exception) {
              NSLog(@"%@", exception.reason);
              result([FlutterError errorWithCode:@"Failed to set icon"
                                         message:exception.reason
                                         details:nil]);
          }
      } else {
          result([FlutterError errorWithCode:@"UNAVAILABLE"
                                     message:@"Not supported on iOS ver < 10.3"
                                     details:nil]);
      }
  } else if ([@"mGetApplicationIconBadgeNumber" isEqualToString:call.method]) {
      result(FlutterMethodNotImplemented);
//      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"mSetApplicationIconBadgeNumber" isEqualToString:call.method]) {
      result(FlutterMethodNotImplemented);//      NSInteger *batchIconNumber = call.arguments[@"batchIconNumber"];
//      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
