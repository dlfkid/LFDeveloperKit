//
//  DeallocCallBack.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DeallocSelfCallback)(__unsafe_unretained id owner, NSUInteger identifier);

@interface DeallocCallBack : NSObject

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableDictionary *callBackDictionary;
@property (nonatomic, weak) id owner;

@end

NS_ASSUME_NONNULL_END
