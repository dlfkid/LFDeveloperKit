//
//  UIAlertController+CrashAlert.m
//  LFDeveloperKitDemo
//
//  Created by Ivan_deng on 2019/10/24.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "UIAlertController+CrashAlert.h"

#import "AppDelegate.h"


@implementation UIAlertController (CrashAlert)

+ (instancetype)crashAlertWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Crash Collected" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:okAction];
    return alert;
}

+ (void)showCrashAlertWithTitle:(NSString *)title Message:(NSString *)message {
    UIViewController *controller = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    [controller presentViewController:[self crashAlertWithTitle:title Message:message] animated:YES completion:nil];
}

@end
