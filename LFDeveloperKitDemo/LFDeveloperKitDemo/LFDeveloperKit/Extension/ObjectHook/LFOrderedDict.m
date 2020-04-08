//
//  LFOrderedDict.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/3.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "LFOrderedDict.h"

@implementation LFOrderedDict

{
    NSMutableDictionary *_dict;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    NSMutableArray *arr = _dict[key];
    if (!arr) {
        arr = [NSMutableArray new];
        [_dict setValue:arr forKey:key];
    }
    if (object) {
        [arr addObject:object];
    }
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    NSMutableArray *arr = _dict[key];
    for (NSInteger i = 0; i < arr.count; ++i) {
        if ([arr[i] isEqualToString:object]) {
            [arr removeObjectAtIndex:i];
            break;
        }
    }
}

- (NSArray *)objectArrayForKey:(NSString *)key {
    return _dict[key];
}

@end
