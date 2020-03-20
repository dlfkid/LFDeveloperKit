//
//  NSObject+Swizzle.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSObject+Swizzle.h"

@import ObjectiveC.runtime;


@implementation NSObject (Swizzle)

+ (void)swizzleInstanceMethodWithSelector:(SEL)selector1 AndSelector:(SEL)selector2 {
    Method originMethod = class_getInstanceMethod(self, selector1);
    Method newMethod = class_getInstanceMethod(self, selector2);
//    if(class_addMethod(self, selector1, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
//        class_replaceMethod(self, selector2, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
//    else
      method_exchangeImplementations(originMethod, newMethod);
}

+ (void)swizzleClassMethodWithSelector:(SEL)selector1 AndSelector:(SEL)selector2 {
    Method originMethod = class_getClassMethod(self, selector1);
    Method newMethod = class_getClassMethod(self, selector2);
    //    if(class_addMethod(self, selector1, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    //        class_replaceMethod(self, selector2, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    //    else
    method_exchangeImplementations(originMethod, newMethod);
}

@end
