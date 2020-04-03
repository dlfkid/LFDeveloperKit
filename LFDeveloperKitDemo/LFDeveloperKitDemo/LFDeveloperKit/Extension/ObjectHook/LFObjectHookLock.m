//
//  LFObjectHookLock.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/3.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "LFObjectHookLock.h"
#import <pthread.h>

@implementation LFObjectHookLock

- (instancetype)init {
    if (self = [super init]) {
        self->_uf_lock = OS_UNFAIR_LOCK_INIT;
        pthread_rwlock_init(&self->_rw_lock, NULL);
        pthread_rwlock_init(&self->_rw_lock2, NULL);
        pthread_rwlock_init(&self->_rw_lock3, NULL);
        self->_sig_lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)dealloc {
    pthread_rwlock_destroy(&self->_rw_lock);
    pthread_rwlock_destroy(&self->_rw_lock2);
    pthread_rwlock_destroy(&self->_rw_lock3);
}


@end
