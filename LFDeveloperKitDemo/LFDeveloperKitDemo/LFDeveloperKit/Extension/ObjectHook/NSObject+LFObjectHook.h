//
//  NSObject+LFObjectHook.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/3.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OriginalMethodBlock)(void);
typedef void(^deallockCallBackBlock)(void);

/// 实现思路：
///  1. 在针对对象Hook的时候，针对该对象创建对应的Container和子类
///  2. 将hook的方法挂载到子类中，并将子类注册到runtime
///  3. 替换子类的forwardInvocation方法，这样在子类找不到方法的实现时可以实现自定义转发
///  3. 在调用方法时, 通过自定义转发，从Container中调用我们挂载的方法实现

@interface NSObject (LFObjectHook)

- (BOOL)hookMethod:(SEL)sel ImplementationBlock:(id)implementationBlock;

- (BOOL)unhookMethod:(SEL)sel;

- (void)callOriginalMethodInBlock:(OriginalMethodBlock)block;

@end

NS_ASSUME_NONNULL_END
