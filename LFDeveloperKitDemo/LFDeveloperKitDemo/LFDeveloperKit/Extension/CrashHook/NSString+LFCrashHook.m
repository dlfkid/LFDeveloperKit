//
//  NSString+LFCrashHook.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/2/18.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSString+LFCrashHook.h"

#import "LFDeveloperKit.h"

#import "NSObject+HookExtension.h"


@implementation NSString (LFCrashHook)

+ (void)load {
    Class class = NSClassFromString(@"__NSCFConstantString");
    [class swizzleInstanceMethodWithSelector:@selector(substringFromIndex:) AndSelector:@selector(ch_cfConstant_substringFromIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(substringToIndex:) AndSelector:@selector(ch_cfConstant_substringToIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(substringWithRange:) AndSelector:@selector(ch_cfConstant_substringWithRange:)];
    
    class = NSClassFromString(@"NSTaggedPointerString");
    [class swizzleInstanceMethodWithSelector:@selector(substringFromIndex:) AndSelector:@selector(ch_taggedPointer_substringFromIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(substringToIndex:) AndSelector:@selector(ch_taggedPointer_substringToIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(substringWithRange:) AndSelector:@selector(ch_taggedPointer_substringWithRange:)];
}

- (NSString *)ch_cfConstant_substringFromIndex:(NSUInteger)from {
    if (from > self.length) {
        from = self.length;
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
    return [self ch_cfConstant_substringFromIndex:from];
}
- (NSString *)ch_cfConstant_substringToIndex:(NSUInteger)to {
    if (to > self.length) {
        to = self.length;
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
    return [self ch_cfConstant_substringToIndex:to];
}

- (NSString *)ch_cfConstant_substringWithRange:(NSRange)range {
    BOOL isRangeModify = NO;
    if (range.length > self.length) {
        range.length = self.length;
        isRangeModify = YES;
    }
    if (range.location > self.length) {
        range.location = self.length;
        isRangeModify = YES;
    }
    if (range.location + range.length > self.length) {
        range.length = self.length - range.location;
        isRangeModify = YES;
    }
    if (isRangeModify) {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
    return [self ch_cfConstant_substringWithRange:range];
}

- (NSString *)ch_taggedPointer_substringFromIndex:(NSUInteger)from {
    if (from > self.length) {
        from = self.length;
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
    return [self ch_taggedPointer_substringFromIndex:from];
}
- (NSString *)ch_taggedPointer_substringToIndex:(NSUInteger)to {
    if (to > self.length) {
        to = self.length;
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
    return [self ch_taggedPointer_substringToIndex:to];
}

- (NSString *)ch_taggedPointer_substringWithRange:(NSRange)range {
    BOOL isRangeModify = NO;
    if (range.length > self.length) {
        range.length = self.length;
        isRangeModify = YES;
    }
    if (range.location > self.length) {
        range.location = self.length;
        isRangeModify = YES;
    }
    if (range.location + range.length > self.length) {
        range.length = self.length - range.location;
        isRangeModify = YES;
    }
    if (isRangeModify) {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
    return [self ch_taggedPointer_substringWithRange:range];
}

- (void)showAlertViewWithMethodName:(NSString *)name {
    [LFSharedKit printLogWithFormat:@"Method :%@ \n Object Description: %@ \n Stack Description: %@", name, self.description, [NSThread callStackSymbols].description];
}

@end
