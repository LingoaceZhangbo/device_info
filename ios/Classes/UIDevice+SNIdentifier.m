//
//  UIDevice+SNIdentifier.m
//  Unity-iPhone
//
//  Created by tianyulong on 2019/6/16.
//

#import "UIDevice+SNIdentifier.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <objc/runtime.h>

@import AdSupport;

#define kDeviceIdentifierID @"deviceIdentifierID"

#define dSCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)

static void * const kUIDeviceIdentifierIDKey     = (void*)&kUIDeviceIdentifierIDKey;

@implementation UIDevice (SNIdentifier)

- (void)setDeviceIdentifierID:(NSString *)deviceIdentifierID {
    objc_setAssociatedObject(self, &kUIDeviceIdentifierIDKey, deviceIdentifierID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)deviceIdentifierID {
    NSString *identifierID = objc_getAssociatedObject(self, &kUIDeviceIdentifierIDKey);
    if ( identifierID == nil ) {
        identifierID = [UIDevice deviceIdentifierID];
        self.deviceIdentifierID = identifierID;
    }
    return identifierID;
}

+ (NSString *)deviceIdentifierID {
#if TARGET_IPHONE_SIMULATOR
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *identifierID = [userDefault objectForKey:kDeviceIdentifierID];
    if ( identifierID == nil || [identifierID isEqualToString:@""] ) {
        identifierID = [self getUUID];
        [userDefault setObject:identifierID forKey:kDeviceIdentifierID];
    }
    return identifierID;
#else
    NSString *identifierID = nil;
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
    if ( store ) {
        identifierID = store[kDeviceIdentifierID];
        if ( identifierID == nil || [identifierID isEqualToString:@""] ) {
            identifierID = [self getUUID];
            store[kDeviceIdentifierID] = identifierID;
        }
    }
    return identifierID;
#endif
}

+ (NSString*)getUUID {
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef UUIDString = CFUUIDCreateString(kCFAllocatorDefault, UUID);
    NSString *result = [NSString stringWithFormat:@"%@", UUIDString];
    CFRelease(UUID);
    CFRelease(UUIDString);
    return result;
}

#pragma mark -
#pragma mark - 获取设备具体型号
//eg : @"iPhone6,1"
+ (NSString *)getDeviceModel {
    struct utsname u;
    uname(&u);
    NSString *machine = [[NSString alloc] initWithUTF8String:u.machine];
    
    //Simulator
    if ([machine isEqualToString:@"i386"] || [machine isEqualToString:@"x86_64"]) {
        machine = @"Simulator";
    }
    
    return machine;
}

@end
