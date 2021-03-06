// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTDeviceInfoPlugin.h"
#import <sys/utsname.h>

@implementation FLTDeviceInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/device_info"
                                  binaryMessenger:[registrar messenger]];
  FLTDeviceInfoPlugin* instance = [[FLTDeviceInfoPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getIosDeviceInfo" isEqualToString:call.method]) {
    UIDevice* device = [UIDevice currentDevice];
    struct utsname un;
    uname(&un);
    //修复问题特出情况下获取不到uuid 导致崩溃问题
    //修改初始化方法
      NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                          @"name",[device name],
                          @"systemName",[device systemName],
                          @"systemVersion",[device systemVersion],
                          @"model",[device model],
                          @"localizedModel", [device localizedModel],
                          @"identifierForVendor", [[UIDevice currentDevice]deviceIdentifierID],
                          @"isPhysicalDevice",[self isDevicePhysical],
                          @"utsname",@{
                              @"sysname" : @(un.sysname),
                              @"nodename" : @(un.nodename),
                              @"release" : @(un.release),
                              @"version" : @(un.version),
                              @"machine" : @(un.machine),
                          },nil];
      result(dic);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

// return value is false if code is run on a simulator
- (NSString*)isDevicePhysical {
#if TARGET_OS_SIMULATOR
  NSString* isPhysicalDevice = @"false";
#else
  NSString* isPhysicalDevice = @"true";
#endif

  return isPhysicalDevice;
}

@end
