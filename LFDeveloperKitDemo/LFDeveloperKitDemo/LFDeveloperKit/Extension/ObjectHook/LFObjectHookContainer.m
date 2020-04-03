//
//  LFObjectHookContainer.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/3.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "LFObjectHookContainer.h"

#import "LFOrderedDict.h"

@interface LFObjectHookContainer()

@end

@implementation LFObjectHookContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        _randomFlag = arc4random_uniform(99999999);
        _resetCountDict = [NSMutableDictionary dictionary];
        _selSet = [NSMutableSet set];
        _selOrderedDict = [[LFOrderedDict alloc] init];
    }
    return self;
}

@end
