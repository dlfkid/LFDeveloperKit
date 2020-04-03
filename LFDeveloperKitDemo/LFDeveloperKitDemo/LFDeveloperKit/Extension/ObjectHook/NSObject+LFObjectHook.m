//
//  NSObject+LFObjectHook.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/3.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSObject+LFObjectHook.h"

#import <objc/message.h>
#import <objc/runtime.h>
#import <pthread.h>

#import "LFObjectHookContainer.h"
#import "LFOrderedDict.h"
#import "LFObjectHookLock.h"

static NSString * const kObjectHookNamePrefixHeader = @"LFObjectHook";
static NSString * const kCurrentCallIndexDictKey = @"LFObjectHook-currentCallIndexDictKey";
static NSString * const kOriginalCallFlagDictKey = @"LFObjectHook-originalCallFlagDictKey";
static NSString * const kDebugOriginalCallDictKey = @"LFObjectHook-debugOriginalCallDictKey";
static NSString * const kKeyForOriginalCallFlag = @"LFObjectHook-keyForOriginalCallFlag";

NSMutableDictionary *threadStoredDictForEntry(NSString *entry) {
    NSMutableDictionary *res = [[NSThread currentThread].threadDictionary valueForKey:entry];
    if (!res) {
        res = [[NSMutableDictionary alloc] init];
        [[NSThread currentThread].threadDictionary setValue:res forKey:entry];
    }
    return res;
}

NSString *entryForThreadStoredDict(const NSString *const key, NSString * clasName) {
    return [NSString stringWithFormat:@"%@-%@", key, clasName];
}

NSMutableDictionary *threadStoredDict(const NSString *const key, NSString *className) {
    return threadStoredDictForEntry(entryForThreadStoredDict(key, className));
}

@implementation NSObject (LFObjectHook)

- (void)hookMethod:(SEL)sel Identifier:(NSString *)identifier ImplementationBlock:(id)implementationBlock {
    pthread_rwlock_wrlock(&([self hookLock]->_rw_lock3));
    LFObjectHookContainer *container = [self hookContainer];
    NSString *selName = NSStringFromSelector(sel);
    Class originalClass = self.class;
    Class currentClass = object_getClass(self);
    if (identifier) {
        NSString *targetSelName = container.selBlockDict[selName][identifier];
        if (targetSelName) {
            Method originMethod = class_getInstanceMethod(currentClass, NSSelectorFromString(targetSelName));
            method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock));
            return;
        }
    }
    const char *originalClassName = class_getName(originalClass);
    NSString *newClassName = [NSString stringWithFormat:@"%@_%s_%p_%d", kObjectHookNamePrefixHeader, originalClassName, self, container.randomFlag];
    int resetTimers = [self resetCountForSel:sel];
    Method method = class_getInstanceMethod(currentClass, sel);
    Class newClass = NSClassFromString(newClassName);
    if (!newClass) {
        newClass = objc_allocateClassPair(currentClass, newClassName.UTF8String, 0);
        SEL forwardSel = @selector(forwardInvocation:);
        Method lfforwardMethod = class_getInstanceMethod([NSObject class], @selector(lfForwardInvocation:));
        class_addMethod(newClass, forwardSel, method_getImplementation(lfforwardMethod), method_getTypeEncoding(lfforwardMethod));
        [self addGetClassImpToClass:newClass];
        objc_registerClassPair(newClass);
        LFObjectHookContainer *container = [self hookContainer];
        container.className = newClassName;
    }
}

- (int)resetCountForSel:(SEL)sel {
    NSDictionary *dict = [self hookContainer].resetCountDict;
    return [dict[NSStringFromSelector(sel)] intValue];
}

- (void)lfForwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    if ([[self hookContainer].selSet containsObject:NSStringFromSelector(sel)]) {
        NSString *selName = NSStringFromSelector(sel);
        pthread_rwlock_rdlock(&[self hookLock]->_rw_lock3);
        NSArray *sels = [[[self hookContainer].selOrderedDict objectArrayForKey:selName] copy];
        NSInteger currentIndex = [self getCurrentCallIndex:sel];
        if ([self shouldCallOriginalMethod]) {
            NSAssert(currentIndex > 0, @"lfForwardInvocation fatal error!");
            [self setOriginalCallFlag:NO];
        } else {
            currentIndex = sels.count - 1;
        }
        SEL currentSel = NSSelectorFromString(sels[currentIndex]);
        anInvocation.selector = currentSel;
        [self setCurrentCallIndex:(int)--currentIndex forSel:sel];
        pthread_rwlock_unlock(&[self hookLock]->_rw_lock3);
        [anInvocation invoke];
    }
}

- (void)setCurrentCallIndex:(int)index forSel:(SEL)sel {
    NSMutableDictionary *dict = threadStoredDict(kCurrentCallIndexDictKey, [self hookContainer].className);
    [dict setValue:@(MAX(0, index)) forKey:NSStringFromSelector(sel)];
}

- (void)setOriginalCallFlag:(BOOL)flag {
    NSMutableDictionary *dict = threadStoredDict(kOriginalCallFlagDictKey, [self hookContainer].className);
    [dict setValue:@(flag) forKey:kKeyForOriginalCallFlag];
}

- (int)getCurrentCallIndex:(SEL)sel {
    NSDictionary *dict = threadStoredDict(kCurrentCallIndexDictKey, [self hookContainer].className);
    int res = 0;
    if (dict) {
        res = [[dict valueForKey:NSStringFromSelector(sel)] intValue];
    }
    return res;
}

- (void)addGetClassImpToClass:(Class)toClass {
    Class originalClass = self.class;
    SEL classSel = @selector(class);
    IMP classImp = imp_implementationWithBlock((Class)^{
        return originalClass;
    });
    const char *type = method_getTypeEncoding(class_getInstanceMethod(NSObject.class, classSel));
    class_addMethod(toClass, classSel, classImp, type);
}

- (BOOL)shouldCallOriginalMethod {
    NSMutableDictionary *dict = threadStoredDict(kOriginalCallFlagDictKey, [self hookContainer].className);
    BOOL res = NO;
    if (dict) {
        res = [dict[kKeyForOriginalCallFlag] boolValue];
    }
    return res;
}

- (LFObjectHookLock *)hookLock {
    LFObjectHookLock *lockObject = objc_getAssociatedObject(self, _cmd);
    if (!lockObject) {
        @synchronized (self) {
            lockObject = [[LFObjectHookLock alloc] init];
            objc_setAssociatedObject(self, _cmd, lockObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return lockObject;
}

- (LFObjectHookContainer *)hookContainer {
    LFObjectHookContainer *container = objc_getAssociatedObject(self, _cmd);
    if (!container) {
        @synchronized (self) {
            container = [[LFObjectHookContainer alloc] init];
            objc_setAssociatedObject(self, _cmd, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return container;
}

@end
