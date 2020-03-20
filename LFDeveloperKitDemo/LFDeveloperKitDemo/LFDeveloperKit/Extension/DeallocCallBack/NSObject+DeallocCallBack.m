//
//  NSObject+DeallocCallBack.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSObject+DeallocCallBack.h"

@import ObjectiveC.runtime;

static dispatch_queue_t _deallocCallbackQueueLock = NULL;

@interface NSObject (DeallockCallBack)

@property (nonatomic, assign) NSInteger defaultIdentifier;
@property (nonatomic, strong) dispatch_queue_t deallocQueue;

@end

@implementation NSObject (DeallocCallBack)

- (NSInteger)defaultIdentifier {
    NSNumber *identifier = objc_getAssociatedObject(self, _cmd);
    return identifier.integerValue;
}

- (void)setDefaultIdentifier:(NSInteger)defaultIdentifier {
    NSNumber *identifier = @(defaultIdentifier);
    objc_setAssociatedObject(self, _cmd, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_queue_t)deallocQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDeallocQueue:(dispatch_queue_t)deallocQueue {
    objc_setAssociatedObject(self, _cmd, deallocQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)willDeallocWithCallBack:(DeallocSelfCallback)callBack {
    if (!callBack) {
        return;
    }
}

@end
