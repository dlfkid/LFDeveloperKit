//
//  NSObject+LFKVOBlock.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "NSObject+LFKVOBlock.h"

#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark - ConstantString

static NSString * const kLFKVOClassPrefix = @"LFKVOClassPrefix_";
static NSString * const kLFKVOAssociatedObservers = @"LFKVOAssociatedObservers";

@interface LFObservationContainer: NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) KeyValueObserverCallBack callBack;

@end

@implementation LFObservationContainer

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key CallBack:(KeyValueObserverCallBack)callBack {
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _callBack = callBack;
    }
    return self;
}

@end

#pragma mark - fucntions

// 根据Get方法来获取Set方法的名称
static NSString * getSetterName(NSString *getterName) {
    if (getterName.length <= 0) {
        return nil;
    }
    // 首字母大写
    NSString *firstLetter = [[getterName substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getterName substringFromIndex:1];
    // 拼出Set方法名称
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    return setter;
}

static NSString * getGetterName(NSString *setterName) {
    // 不符合Setter方法的特征,直接返回
    if (setterName.length <=0 || ![setterName hasPrefix:@"set"] || ![setterName hasSuffix:@":"]) {
        return nil;
    }
    
    // 将开头的set字样和最后的:去除
    NSRange range = NSMakeRange(3, setterName.length - 4);
    NSString *key = [setterName substringWithRange:range];
    
    // 首字母小写
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}

// 获取当前对象的父类函数
static Class kvo_class(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

// 替换为可以触发KVO的Setter
static void kvo_setter(id self, SEL _cmd, id newValue) {
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getGetterName(setterName);
    
    if (!getterName) { // 没有声明过默认的Getter,返回错误
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    // 用KVC的方法获取成员变量的旧值
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superClassStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    // 强转消除编译器警告
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // 调用父类(也就是被观察对象最开始的类)执行Setter方法
    objc_msgSendSuperCasted(&superClassStruct, _cmd, newValue);
    
    // 用动态绑定的KVO容器取出对应的block,并在全局队列执行
    NSMutableArray *containers = objc_getAssociatedObject(self, (__bridge const void *)(kLFKVOAssociatedObservers));
    [containers enumerateObjectsUsingBlock:^(LFObservationContainer * _Nonnull container, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([container.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                container.callBack(self, getterName, oldValue, newValue);
            });
        }
    }];
}

@implementation NSObject (LFKVOBlock)

#pragma mark - Public

- (void)addObserver:(id)observer Key:(NSString *)key CallBack:(KeyValueObserverCallBack)callBack {
    // 获取Setter方法名
    SEL setterSEL = NSSelectorFromString(getSetterName(key));
    Method setterMethod = class_getInstanceMethod(self.class, setterSEL);
    if (!setterMethod) { // 检查被观察对象是否实现了默认Setter,如果没有则抛出异常
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have default setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        
        return;
    }
    // 获取当前类型
    Class currentClass = object_getClass(self);
    NSString *currentClassName = NSStringFromClass(currentClass);
    if (![currentClassName hasPrefix:kLFKVOClassPrefix]) { // 对象不是已经被KVO过的类型
        currentClass = [self kvoClassWithOriginalClassName:currentClassName]; // 生成一个用于KVO的子类
        object_setClass(self, currentClass); // 将对象的所属类型修改为子类
    }
    // 因为此时Self已经是动态生成的子类了,可以检查子类有没有时间过这个Setter,如果没有则需要实现
    if (![self hasSelector:setterSEL]) {
        const char *typeEncoding = method_getTypeEncoding(setterMethod);
        // 为动态生成的子类添加自定义方法
        class_addMethod(currentClass, setterSEL, (IMP)kvo_setter, typeEncoding);
    }
    // 生成储存KVO回调的容器
    LFObservationContainer *container = [[LFObservationContainer alloc] initWithObserver:observer Key:key CallBack:callBack];
    // 如果没有容器列表需要动态绑定
    NSMutableArray *containers = objc_getAssociatedObject(self, (__bridge const void *)(kLFKVOAssociatedObservers));
    if (!containers) {
        containers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLFKVOAssociatedObservers), containers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // 将容器添加到容器列表中
    [containers addObject:container];
}

- (void)removeObserver:(id)observer Key:(NSString *)key {
    // 获取动态绑定的容器列表
    NSMutableArray *containers = objc_getAssociatedObject(self, (__bridge const void *)(kLFKVOAssociatedObservers));
    if (containers) {
        LFObservationContainer *target = nil;
        for (LFObservationContainer *container in containers) {
            // 遍历所有容器看观察者和key是否一致,如果是,则移除最后一个容器
            if ([container.key isEqualToString:key] && container.observer == observer) {
                target = container;
            }
        }
        if (target) {
            [containers removeObject:target];
        }
    }
}

#pragma mark - Private

- (Class)kvoClassWithOriginalClassName:(NSString *)className {
    NSString *kvoClassName = [kLFKVOClassPrefix stringByAppendingString:className];
    Class kvoClass = NSClassFromString(kvoClassName);
    
    if (kvoClass) { // 如果是已存在的类型,直接返回
        return kvoClass;
    }
    
    // 没有已存在的KVO类,使用runtime生成
    Class originalClass = object_getClass(self);
    Class newKVOClass = objc_allocateClassPair(originalClass, kvoClassName.UTF8String, 0);
    
    // 获取Class方法的方法签名
    Method classMethod = class_getInstanceMethod(originalClass, @selector(class));
    const char *types = method_getTypeEncoding(classMethod);
    // 使用和原本Class一样的方法签名为KVOClass注册一个Class方法,实现内容是返回它的父类,这样就实现了伪装自身为父类的效果
    class_addMethod(newKVOClass, @selector(class), (IMP)kvo_class, types);
    // 将Class注册到runtime
    objc_registerClassPair(newKVOClass);
    
    return newKVOClass;
}

- (BOOL)hasSelector:(SEL)selector {
    Class currentClass = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(currentClass, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

@end
