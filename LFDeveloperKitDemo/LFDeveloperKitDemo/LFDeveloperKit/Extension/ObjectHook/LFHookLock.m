//
//  LFHookLock.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/8.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "LFHookLock.h"
#import <pthread.h>

@implementation LFHookLock

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_rwlock_init(&self->_rw_lock, NULL);
    }
    return self;
}

- (void)dealloc {
    pthread_rwlock_destroy(&self->_rw_lock);
}

@end
