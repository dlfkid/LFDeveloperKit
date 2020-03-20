//
//  NSObject+Swizzle.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzle)

/**
 交换类中的某两个实例方法
 
 @param selector1 方法1
 @param selector2 方法2
 */
+ (void)swizzleInstanceMethodWithSelector:(SEL)selector1 AndSelector:(SEL)selector2;

/**
 交换类中的某两个类方法

 @param selector1 方法1
 @param selector2 方法2
 */
+ (void)swizzleClassMethodWithSelector:(SEL)selector1 AndSelector:(SEL)selector2;

@end

NS_ASSUME_NONNULL_END
