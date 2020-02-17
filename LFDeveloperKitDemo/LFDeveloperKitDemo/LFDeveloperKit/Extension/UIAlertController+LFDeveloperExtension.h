//
//  UIAlertController+LFDeveloperExtension.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/2/17.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (LFDeveloperExtension)

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
