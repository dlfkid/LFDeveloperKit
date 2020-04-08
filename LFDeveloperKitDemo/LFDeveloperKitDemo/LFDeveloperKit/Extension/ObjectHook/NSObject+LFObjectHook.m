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
#import "LFHookLock.h"

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

NSString *createSelHeaderString(NSString *str, int index) {
    return [NSString stringWithFormat:@"__%d_%@", index, str];
}

SEL createSEL(SEL sel, NSString *str) {
    NSString *originalSELString = NSStringFromSelector(sel);
    NSString *newSELString = [NSString stringWithFormat:@"%@_LF_%@", str, originalSELString];
    return NSSelectorFromString(newSELString);
}

SEL createSELA(SEL sel, int index) {
    return createSEL(sel, createSelHeaderString(@"A", index));
}

SEL createSELB(SEL sel, int index) {
    return createSEL(sel, createSelHeaderString(@"B", index));
}

@implementation NSObject (LFObjectHook)

- (void)callOriginalMethodInBlock:(OriginalMethodBlock)block {
    [self setOriginalCallFlag:YES];
    block();
}

- (BOOL)hookMethod:(SEL)sel ImplementationBlock:(id)implementationBlock {
    pthread_rwlock_rdlock(&[self hookLock]->_rw_lock); // 线程锁上锁
    LFObjectHookContainer *container = [self hookContainer]; // 实例化替换方法储存器
    NSString *selName = NSStringFromSelector(sel); // 获取方法名
    Class originalClass = self.class; // 获取对象原本的类
    Class currentClass = object_getClass(self); // 获取当前实际类
    NSString *targetSelName = container.selBlockDict[selName]; // 标识储存的方法名
    if (targetSelName) { // 如果找到了标识的方法名，说明这个方法已经被替换过一次了
        Method originMethod = class_getInstanceMethod(currentClass, NSSelectorFromString(targetSelName)); // 找到被替换的方法
        method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock)); // 将新的方法替换进去
        return YES;
    }
    const char *originalClassName = class_getName(originalClass); // 取得原本类的名称
    NSString *newClassName = [NSString stringWithFormat:@"%@_%s_%p_%d", kObjectHookNamePrefixHeader, originalClassName, self, container.randomFlag]; // 定义新的类的名称
    // int resetTimers = [self resetCountForSel:sel]; // 重置次数
    Class newClass = NSClassFromString(newClassName); // 查找新类命名的类，看是否已经定义过
    if (!newClass) { // 如果找不到新类，说明没有生成过
        newClass = objc_allocateClassPair(currentClass, newClassName.UTF8String, 0); // 动态分配新类的内存，父类是currentClass,类名是刚才定义的
        SEL forwardSel = @selector(forwardInvocation:); // 找到消息转发的SEL
        Method lfforwardMethod = class_getInstanceMethod([NSObject class], @selector(lfForwardInvocation:)); // 根据SEL找到方法
        class_addMethod(newClass, forwardSel, method_getImplementation(lfforwardMethod), method_getTypeEncoding(lfforwardMethod)); // 替换新类对象的消息转发方法为自定义的消息转发方法
        [self addGetClassImpToClass:newClass]; // 替换新类的获取本类对象方法，新类的.Class方法将会返回它的原本类对象
        objc_registerClassPair(newClass); // 将新类注册到Runtime中
        LFObjectHookContainer *container = [self hookContainer]; // 获取替换方法储存器
        container.className = newClassName; // 储存本对象的实际类名
        [container.classes addObject:newClass]; // 添加新类到储存器的字典中
        container.onClassDisposal = ^{ // 定义储存器销毁的回调
            NSThread *mainThread  = [NSThread mainThread]; // 获取主线程
            NSArray *keys = @[kCurrentCallIndexDictKey, kOriginalCallFlagDictKey, kDebugOriginalCallDictKey, kKeyForOriginalCallFlag];
            NSMutableDictionary *dict = mainThread.threadDictionary; // 获取主线程字典
            [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger  idx, BOOL * _Nonnull stop) {
                if (![dict objectForKey:entryForThreadStoredDict(key, newClassName)]) {
                    *stop = YES;
                    return;
                }
                [dict removeObjectForKey:entryForThreadStoredDict(key, newClassName)]; // 去除相关索引
            }];
        };
    }
    if (!newClass) {
        return NO;
    }
    Method method = class_getInstanceMethod(currentClass, sel); // 获取当前类下的方法
NSAssert(method != NULL, ([NSString stringWithFormat:@"The Selector `%@` may be wrong, please check it!", selName])); // 获取不到要替换的类的方法，崩溃
    IMP originalImplenmentation = method_getImplementation(method); // 获取原本的方法的实现
    const char *types = method_getTypeEncoding(method); // 获取类型编码
    IMP msgForwardIMP = _objc_msgForward; // 获取消息转发的目标实现
#if !defined(__arm64__)
    if (types[0] == '{') {
        //In some cases that returns struct, we should use the '_stret' API:
        //http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
        //NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:types];
        if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
            msgForwardIMP = (IMP)_objc_msgForward_stret;
        }
    }
#endif
    if (originalImplenmentation != msgForwardIMP) { // 如果转发的函数实现和原本的函数实现不同
        class_addMethod(newClass, sel, msgForwardIMP, types); // 将消息函数的原本实现添加到当前的新类中
        SEL selB = createSELB(sel, container.randomFlag); // 生成SELB
        NSString *strSELB = NSStringFromSelector(selB);
        class_addMethod(newClass, selB, originalImplenmentation, types); // 新类添加原本的方法实现
        [container addSelValue:strSELB forMainKey:selName];
        object_setClass(self, newClass); // 将自身对象定义为自定义子类
    }
    
    IMP impA = imp_implementationWithBlock(implementationBlock);
    SEL selA = createSELA(sel, container.randomFlag);
    class_addMethod(newClass, selA, impA, types);
    NSString *stringSelA = NSStringFromSelector(selA);
    [container addSelValue:stringSelA forMainKey:selName];
    [container.selSet addObject:selName];
    pthread_rwlock_unlock(&[self hookLock]->_rw_lock);
    return YES;
}

- (BOOL)unhookMethod:(SEL)sel {
    LFObjectHookContainer *container = [self hookContainer];
    NSString *selString = container.selBlockDict[NSStringFromSelector(sel)];
    if (!selString) {
        return NO;
    }
    [container deleteSelValue:selString forMainKey:NSStringFromSelector(sel)];
    return YES;
}

// 因为动态生成的类对象只可以在注册到runtime之前添加方法，一旦注册了，就只能通过消息转发实现声明的方法，因此我们替换自定义类的消息转发方法，改为转发到我们动态挂载的方法上面去。
- (void)lfForwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector; // 获取消息中的SEL
    if ([[self hookContainer].selSet containsObject:NSStringFromSelector(sel)]) { // 判断该SEL是否被Hook过
        NSString *selName = NSStringFromSelector(sel);
        pthread_rwlock_rdlock(&[self hookLock]->_rw_lock);
        NSArray *sels = [[[self hookContainer].selOrderedDict objectArrayForKey:selName] copy]; // 取出hook过改方法的所有方法数组
        NSInteger currentIndex = 0; // 定义调用次序
        if ([self shouldCallOriginalMethod]) { // 判断是否需要调用原方法
            [self setOriginalCallFlag:NO]; // 调用后将这个表示改为No
        } else { // 不需要调用原方法，则直接调用hook后的方法
            currentIndex = sels.count - 1;
        }
        SEL currentSel = NSSelectorFromString(sels[currentIndex]);
        anInvocation.selector = currentSel; // 将最后一个挂在的方法替换到消息的Sel中
        pthread_rwlock_unlock(&[self hookLock]->_rw_lock);
        [anInvocation invoke];
    }
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

#pragma mark - OriginalImplenmentationCall

- (BOOL)shouldCallOriginalMethod {
    NSMutableDictionary *dict = threadStoredDict(kOriginalCallFlagDictKey, [self hookContainer].className);
    BOOL res = NO;
    if (dict) {
        res = [dict[kKeyForOriginalCallFlag] boolValue];
    }
    return res;
}

- (void)setOriginalCallFlag:(BOOL)flag {
    NSMutableDictionary *dict = threadStoredDict(kOriginalCallFlagDictKey, [self hookContainer].className);
    [dict setValue:@(flag) forKey:kKeyForOriginalCallFlag];
}

#pragma mark - LazyLoads

- (LFHookLock *)hookLock {
    LFHookLock *lockObject = objc_getAssociatedObject(self, _cmd);
    if (!lockObject) {
        @synchronized (self) {
            lockObject = [[LFHookLock alloc] init];
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
