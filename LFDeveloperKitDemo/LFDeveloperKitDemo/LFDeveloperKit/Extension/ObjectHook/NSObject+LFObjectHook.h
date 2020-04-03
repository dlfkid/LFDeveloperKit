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

@interface NSObject (LFObjectHook)

- (void)hookMethod:(SEL)sel Identifier:(NSString * _Nonnull)identifier ImplementationBlock:(id)implementationBlock;

- (void)callOriginalMethodInBlock:(OriginalMethodBlock)block;

- (void)unhookMethod:(SEL)sel Identifier:(NSString * _Nonnull)Identifier;

@end

NS_ASSUME_NONNULL_END
