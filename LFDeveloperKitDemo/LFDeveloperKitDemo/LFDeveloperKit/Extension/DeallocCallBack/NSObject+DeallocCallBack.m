//
//  NSObject+DeallocCallBack.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSObject+DeallocCallBack.h"

@import ObjectiveC.runtime;

@interface NSObject (DeallockCallBack)

@property (nonatomic, assign) NSInteger callBackCount;
@property (nonatomic, strong) dispatch_queue_t deallocBlockManageQueue;
@property (nonatomic, strong) DeallocCallBackContainer *deallocBlockContainer;

@end

@implementation NSObject (DeallocCallBack)

- (NSInteger)callBackCount {
    NSNumber *identifier = objc_getAssociatedObject(self, _cmd);
    return identifier.integerValue;
}

- (void)setCallBackCount:(NSInteger)callBackCount {
    NSNumber *identifier = @(callBackCount);
    objc_setAssociatedObject(self, _cmd, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_queue_t)deallocBlockManageQueue {
    __block dispatch_queue_t queue = nil;
    dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        queue = objc_getAssociatedObject(self, _cmd);
        if (!queue) {
            NSString *queueName = [NSString stringWithFormat:@"%@.dealloc.callBack.handle", self.class];
            objc_setAssociatedObject(self, _cmd, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            queue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
        }
    });
    return queue;
}

- (DeallocCallBackContainer *)deallocBlockContainer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDeallocBlockContainer:(DeallocCallBackContainer *)deallocBlockContainer {
    objc_setAssociatedObject(self, _cmd, deallocBlockContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)willDeallocWithCallBack:(DeallocSelfCallback)callBack {
    if (!callBack) {
        return 0;
    }
    __block DeallocCallBackContainer *callBackContainer = nil;
    __block NSInteger blockCount = 0;
    
    dispatch_sync(self.deallocBlockManageQueue, ^{
        blockCount = self.callBackCount;
        blockCount += 1;
        callBackContainer = self.deallocBlockContainer;
        if (!callBackContainer) {
            callBackContainer = [[DeallocCallBackContainer alloc] initWithOwner:self];
            self.deallocBlockContainer = callBackContainer;
        }
        if ([callBackContainer addSelfCallBack:callBack identifier:blockCount] > 0) {
            self.callBackCount = blockCount;
        }
    });
    return blockCount;
}

- (NSInteger)removeDeallocCallBackWithIdentifier:(NSInteger)identifier {
    if (identifier <= 0) {
        return 0;
    }
    __block NSInteger blockCount = 0;
    __block DeallocCallBackContainer *callBackContainer = nil;
    dispatch_sync(self.deallocBlockManageQueue, ^{
        blockCount = self.callBackCount;
        callBackContainer = self.deallocBlockContainer;
        if (!callBackContainer) {
            blockCount = 0;
            return;
        }
        blockCount = [callBackContainer removeDeallocCallBackWithIdentifier:identifier];
    });
    return blockCount;
}

@end
