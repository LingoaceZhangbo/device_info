//
//  UIDevice+SNIdentifier.h
//  Unity-iPhone
//
//  Created by tianyulong on 2019/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (SNIdentifier)


+ (NSString *)deviceIdentifierID;

- (NSString *)deviceIdentifierID;

+ (NSString *)getDeviceModel;



@end

NS_ASSUME_NONNULL_END
