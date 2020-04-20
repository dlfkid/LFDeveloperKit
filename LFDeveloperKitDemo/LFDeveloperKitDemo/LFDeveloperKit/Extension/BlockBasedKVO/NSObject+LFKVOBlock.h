//
//  NSObject+LFKVOBlock.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KeyValueObserverCallBack)(id observedObject, NSString *key, id oldValue, id newValue);

@interface NSObject (LFKVOBlock)

- (void)addObserver:(id)observer Key:(NSString *)key CallBack:(KeyValueObserverCallBack)callBack;

- (void)removeObserver:(id)observer Key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
