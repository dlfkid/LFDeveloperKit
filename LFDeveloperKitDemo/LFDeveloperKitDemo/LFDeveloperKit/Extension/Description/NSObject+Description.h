//
//  NSObject+Description.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Description)

/**
 获得当前类的所有方法名

 @return 方法名数组
 */
+ (NSArray <NSString *> *)methodNames;

/**
 打印类的所有属性
 */
+ (void)logPropertys;

/**
 打印类的所有成员变量
 */
+ (void)logIvars;

@end

NS_ASSUME_NONNULL_END
