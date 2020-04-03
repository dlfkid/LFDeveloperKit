//
//  NSObject+Description.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSObject+Description.h"

@import ObjectiveC.runtime;

@implementation NSObject (Description)

 + (NSArray <NSString *> *)methodNames {
    unsigned int count;
    Method *methodList = class_copyMethodList(self, &count);
    NSMutableArray *methodNames = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
//        NSLog(@"%s%s",__func__,sel_getName(method_getName(method)));
        NSString *methodName = [NSString stringWithFormat:@"%s%s", __func__, sel_getName(method_getName(method))];
        [methodNames addObject:methodName];
    }
    return methodNames;
}

+ (void)logPropertys {
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(self, &count);
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSLog(@"%@",name);
    }
}

+ (void)logIvars {
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        Ivar ivar = ivars[i];
        // 获取属性的名称 C语言字符串
        const char *cName = ivar_getName(ivar);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSLog(@"%@",name);
    }
}

@end
