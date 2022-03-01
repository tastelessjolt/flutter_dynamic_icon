#import "FLTDynamicIconPlugin.h"

@implementation FLTDynamicIconPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_dynamic_icon"
                                     binaryMessenger:[registrar messenger]];
    [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
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
                    if (iconName == [NSNull null]) {
                        iconName = nil;
                    }
                    
                    NSNumber *showAlertBoolean = call.arguments[@"showAlert"];

                    if([showAlertBoolean isEqualToNumber:[NSNumber numberWithBool:NO]]){
                        NSMutableString *selectorString = [[NSMutableString alloc] initWithCapacity:40];
                        [selectorString appendString:@"_setAlternate"];
                        [selectorString appendString:@"IconName:"];
                        [selectorString appendString:@"completionHandler:"];

                        SEL selector = NSSelectorFromString(selectorString);
                        IMP imp = [[UIApplication sharedApplication] methodForSelector:selector];
                        void (*func)(id, SEL, id, id) = (void *)imp;
                        if (func)
                        {
                            func([UIApplication sharedApplication], selector, iconName, ^(NSError * _Nullable error) {
                                if(error) {
                                    result([FlutterError errorWithCode:@"Failed to set icon"
                                                            message:[error description]
                                                            details:nil]);
                                } else {
                                    result(nil);
                                }
                            });
                        }
                        
                    } else {
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
            result([NSNumber numberWithInteger:UIApplication.sharedApplication.applicationIconBadgeNumber]);
        } else if ([@"mSetApplicationIconBadgeNumber" isEqualToString:call.method]) {
            if (@available(iOS 10.0, *)) {
                [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        @try {
                            NSInteger batchIconNumber = ((NSNumber *)call.arguments[@"batchIconNumber"]).integerValue;
                        numberWithInteger:UIApplication.sharedApplication.applicationIconBadgeNumber = batchIconNumber;
                            result(nil);
                        }
                        @catch (NSException *exception) {
                            NSLog(@"%@", exception.reason);
                            result([FlutterError errorWithCode:@"Failed to set batch icon number"
                                                    message:exception.reason
                                                    details:nil]);
                        }
                    }
                    else {
                        result([FlutterError errorWithCode:@"Failed to set batch icon number"
                                                message:@"Permission denied by the user"
                                                details:nil]);
                    }
                }];
            } else {
                // Fallback on earlier versions
                @try {
                    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
                    
                    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                    NSInteger batchIconNumber = ((NSNumber *)call.arguments[@"batchIconNumber"]).integerValue;
                numberWithInteger:UIApplication.sharedApplication.applicationIconBadgeNumber = batchIconNumber;
                    result(nil);
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception.reason);
                    result([FlutterError errorWithCode:@"Failed to set batch icon number"
                                            message:exception.reason
                                            details:nil]);
                }
            }
            
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}


@end
