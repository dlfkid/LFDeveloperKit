//
//  DeallocCallBack.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DeallocSelfCallback)(id owner, NSInteger identifier);

@interface DeallocCallBackContainer : NSObject

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableDictionary *callBackDictionary;
@property (nonatomic, unsafe_unretained) id owner;

- (instancetype)initWithOwner:(id)owner;

- (NSInteger)addSelfCallBack:(DeallocSelfCallback)selfCallBack identifier:(NSInteger)identifier;

- (BOOL)removeCallBackWithIdentifier:(NSInteger)identifier;

@end


NS_ASSUME_NONNULL_END
