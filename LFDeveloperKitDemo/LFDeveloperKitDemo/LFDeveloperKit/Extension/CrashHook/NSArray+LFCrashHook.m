//
//  NSArray+LFCrashHook.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/2/17.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSArray+LFCrashHook.h"

#import "LFDeveloperKit.h"

#import "NSObject+HookExtension.h"

@implementation NSArray (CrashHook)

+ (void)load {
    Class class = NSClassFromString(@"__NSArrayI");
    [class swizzleInstanceMethodWithSelector:@selector(objectAtIndex:) AndSelector:@selector(ch_objectAtIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(objectAtIndexedSubscript:) AndSelector:@selector(ch_objectAtIndexedSubscript:)];
    
    /*
    test :
    NSNumber *a = [NSNumber numberWithInt:1];
    NSNumber *b = @(2);
    NSNumber *c = nil;
    NSArray *array = @[a, b, c];
    */
    class = NSClassFromString(@"__NSPlaceholderArray");
    [class swizzleInstanceMethodWithSelector:@selector(initWithObjects:count:) AndSelector:@selector(ch_initWithObjects:count:)];
    
    /*
     test :
     NSArray *array = @[];
     id a = array[0];
     */
    class = NSClassFromString(@"__NSArray0");
    [class swizzleInstanceMethodWithSelector:@selector(objectAtIndex:) AndSelector:@selector(ch0_objectAtIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(objectAtIndexedSubscript:) AndSelector:@selector(ch0_objectAtIndexedSubscript:)];
    
    class = NSClassFromString(@"__NSArrayM");
    [class swizzleInstanceMethodWithSelector:@selector(objectAtIndex:) AndSelector:@selector(chM_objectAtIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(objectAtIndexedSubscript:) AndSelector:@selector(chM_objectAtIndexedSubscript:)];
    [class swizzleInstanceMethodWithSelector:@selector(addObject:) AndSelector:@selector(ch_addObject:)];
    [class swizzleInstanceMethodWithSelector:@selector(insertObject:atIndex:) AndSelector:@selector(ch_insertObject:atIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(removeObjectAtIndex:) AndSelector:@selector(ch_removeObjectAtIndex:)];
    [class swizzleInstanceMethodWithSelector:@selector(replaceObjectAtIndex:withObject:) AndSelector:@selector(ch_replaceObjectAtIndex:withObject:)];
    [class swizzleInstanceMethodWithSelector:@selector(setObject:atIndexedSubscript:) AndSelector:@selector(ch_setObject:atIndexedSubscript:)];
}

- (id)ch_objectAtIndex:(NSUInteger)idx {
    if (idx < self.count) {
        return [self ch_objectAtIndex:idx];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
        return nil;
    }
}

- (id)ch_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count) {
        return [self ch_objectAtIndexedSubscript:idx];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
        return nil;
    }
}

- (instancetype)ch_initWithObjects:(const id _Nonnull [_Nullable])objects count:(NSUInteger)cnt {
    id nObjects[cnt];
    int i = 0;
    for (; i < cnt; i++) {
        if (objects[i]) {
            nObjects[i] = objects[i];
        }
        else {
            nObjects[i] = NSNull.null;
            [LFSharedKit printLogWithFormat:@"nil in array initialization \n Stack : %@", [NSThread callStackSymbols].description];
        }
    }
    return [self ch_initWithObjects:nObjects count:i];
}

- (id)ch0_objectAtIndex:(NSUInteger)idx {
    if (idx < self.count) {
        return [self ch0_objectAtIndex:idx];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
        return nil;
    }
}

- (id)ch0_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count) {
        return [self ch0_objectAtIndexedSubscript:idx];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
        return nil;
    }
}

- (id)chM_objectAtIndex:(NSUInteger)idx {
    if (idx < self.count) {
        return [self chM_objectAtIndex:idx];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
        return nil;
    }
}

- (id)chM_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count) {
        return [self chM_objectAtIndexedSubscript:idx];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
        return nil;
    }
}

- (void)ch_addObject:(id)anObject {
    if (anObject) {
        return [self ch_addObject:anObject];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
}

- (void)ch_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index <= self.count) {
        return [self ch_insertObject:anObject atIndex:index];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
}

- (void)ch_removeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self ch_removeObjectAtIndex:index];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
}

- (void)ch_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (anObject && index < self.count) {
        return [self ch_replaceObjectAtIndex:index withObject:anObject];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
}

- (void)ch_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (obj && idx <= self.count) {
        return [self ch_setObject:obj atIndexedSubscript:idx];
    }
    else {
        [self showAlertViewWithMethodName:NSStringFromSelector(_cmd)];
    }
}

- (void)showAlertViewWithMethodName:(NSString *)name {
    [LFSharedKit printLogWithFormat:@"Method :%@ \n Object Description: %@ \n Stack Description: %@", name, self.description, [NSThread callStackSymbols].description];
}

@end
