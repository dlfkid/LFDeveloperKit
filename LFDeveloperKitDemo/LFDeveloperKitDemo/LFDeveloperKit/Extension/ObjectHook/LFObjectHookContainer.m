//
//  LFObjectHookContainer.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/3.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "LFObjectHookContainer.h"
#import <objc/runtime.h>
#import "LFOrderedDict.h"


@interface LFObjectHookContainer()

@end

@implementation LFObjectHookContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        _randomFlag = arc4random_uniform(99999999);
        _selSet = [NSMutableSet set];
        _selBlockDict = [[NSMutableDictionary alloc] init];
        _selOrderedDict = [[LFOrderedDict alloc] init];
        _classes = [[NSMutableArray alloc] init];
        _deallocCallBacks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    NSMutableArray *temp = [_classes mutableCopy];
    ClassDisposedCallBackBlock block = self.onClassDisposal;
    [_deallocCallBacks enumerateObjectsUsingBlock:^(ClassDisposedCallBackBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj();
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
        for (int i = 0; i < temp.count; i ++) {
            Class sampleClass = [temp lastObject];
            [temp removeLastObject];
            objc_disposeClassPair(sampleClass);
        }
    });
}

- (void)addSelValue:(NSString *)value forMainKey:(NSString *)selStr {
    [_selBlockDict setObject:value forKey:selStr];
    [_selOrderedDict setObject:value forKey:selStr];
}

- (void)deleteSelValue:(NSString *)value forMainKey:(NSString *)selStr {
    [_selBlockDict removeObjectForKey:selStr];
    [_selOrderedDict removeObject:value forKey:selStr];
}

@end
