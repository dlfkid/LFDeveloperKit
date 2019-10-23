//
//  UIAlertController+CrashAlert.h
//  LFDeveloperKitDemo
//
//  Created by Ivan_deng on 2019/10/24.
//  Copyright © 2019 LeonDeng. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (CrashAlert)

+ (instancetype)crashAlertWithTitle:(NSString *)title Message:(NSString *)message;

+ (void)showCrashAlertWithTitle:(NSString *)title Message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
