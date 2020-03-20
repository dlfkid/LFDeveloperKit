//
//  NSDictionary+LFCrashHook.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/2/17.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSDictionary+LFCrashHook.h"

#import "LFDeveloperKit.h"

#import "NSObject+Swizzle.h"

@implementation NSDictionary (LFCrashHook)

+ (void)load {
    Class class = NSClassFromString(@"__NSPlaceholderDictionary");
    [class swizzleInstanceMethodWithSelector:@selector(initWithObjects:forKeys:count:) AndSelector:@selector(ch_initWithObjects:forKeys:count:)];
    
    class = NSClassFromString(@"__NSDictionaryM");
    [class swizzleInstanceMethodWithSelector:@selector(setObject:forKey:) AndSelector:@selector(ch_setObject:forKey:)];
    [class swizzleInstanceMethodWithSelector:@selector(setObject:forKeyedSubscript:) AndSelector:@selector(ch_setObject:forKeyedSubscript:)];
}

- (instancetype)ch_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    
    if (!LFSharedKit.dictionaryCrashHookEnable) {
        return [self ch_initWithObjects:objects forKeys:keys count:cnt];
    }
    
    id nObjects[cnt];
    id nKeys[cnt];
    int i = 0;
    for (; i < cnt; i++) {
        if (keys[i]) {
            nKeys[i] = keys[i];
        }
        else {
            nKeys[i] = @"";
            [LFSharedKit printLogWithFormat:@"nil in dictionary initialization \n Stack : %@", [NSThread callStackSymbols].description];
        }
        if (objects[i]) {
            nObjects[i] = objects[i];
        }
        else {
            nObjects[i] = NSNull.null;
            [LFSharedKit printLogWithFormat:@"nil in dictionary initialization \n Stack : %@", [NSThread callStackSymbols].description];
        }
    }
    
    return [self ch_initWithObjects:nObjects forKeys:nKeys count:i];
}

- (void)ch_setObject:(id)anObject forKey:(id)aKey {
    
    if (!LFSharedKit.dictionaryCrashHookEnable) {
        [self ch_setObject:anObject forKey:aKey];
    }
    
    if (anObject && aKey) {
        [self ch_setObject:anObject forKey:aKey];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
}

- (void)ch_setObject:(nullable id)obj forKeyedSubscript:(id)key {
    
    if (!LFSharedKit.dictionaryCrashHookEnable) {
        [self ch_setObject:obj forKeyedSubscript:key];
    }
    
    if (key) {
        [self ch_setObject:obj forKeyedSubscript:key];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
}

- (void)showAlertViewWithMethodName:(NSString *)name {
    [LFSharedKit printLogWithFormat:@"Method :%@ \n Object Description: %@ \n Stack Description: %@", name, self.description, [NSThread callStackSymbols].description];
}

@end
