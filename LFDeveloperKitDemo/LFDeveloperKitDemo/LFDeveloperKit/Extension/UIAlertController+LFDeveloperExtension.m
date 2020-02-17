//
//  UIAlertController+LFDeveloperExtension.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/2/17.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "UIAlertController+LFDeveloperExtension.h"

@implementation UIAlertController (LFDeveloperExtension)

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *temp = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [temp addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:temp animated:YES completion:nil];
}

@end
