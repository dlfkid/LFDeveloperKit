//
//  LFHookLock.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/8.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFHookLock : NSObject

{
    @public
    pthread_rwlock_t _rw_lock;
}

@end

NS_ASSUME_NONNULL_END
