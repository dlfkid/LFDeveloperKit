//
//  DeallocCallBack.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "DeallocCallBack.h"

@interface DeallocCallBack()

@end

@implementation DeallocCallBack

- (instancetype)initWithOwner:(id)owner {
    self = [super init];
    if (self) {
        _owner = owner;
        _lock = [[NSLock alloc] init];
        _callBackDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSUInteger)addSelfCallBack:(DeallocSelfCallback)selfCallBack identifier:(NSInteger)identifier {
    if (!selfCallBack || identifier <= 0) {
        return 0;
    }
    [self.lock lock];
    [self.callBackDictionary setObject:[selfCallBack copy] forKey:@(identifier)];
    [self.lock unlock];
    return identifier;
}

- (BOOL)removeCallBackWithIdentifier:(NSUInteger)identifier {
    if (identifier == 0) {
        return NO;
    }
    NSNumber *identifierNumber = @(identifier);
    if (self.callBackDictionary[identifierNumber]) {
        [self.lock lock];
        [self.callBackDictionary removeObjectForKey:identifierNumber];
        [self.lock unlock];
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc {
    NSArray *allKeys = [[self.callBackDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber *identifier in allKeys) {
        DeallocSelfCallback callBack = self.callBackDictionary[identifier];
        callBack(_owner, identifier.unsignedIntValue);
    }
}

@end
