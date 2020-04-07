//
//  LFObjectHookContainer.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/3.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

@class LFOrderedDict;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClassDisposedCallBackBlock)(void);

@interface LFObjectHookContainer : NSObject

@property (nonatomic, strong) NSMutableDictionary *selBlockDict;
@property (nonatomic, strong) NSMutableDictionary *resetCountDict;
@property (nonatomic, strong) NSMutableArray *classes;
@property (nonatomic, strong) NSMutableSet *selSet;
@property (nonatomic, strong) LFOrderedDict *selOrderedDict;
@property (nonatomic, assign) int randomFlag;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) ClassDisposedCallBackBlock onClassDisposal;
@property (nonatomic, strong) NSMutableArray *deallocCallBacks;

- (void)addSelValue:(NSString *)value forMainKey:(NSString *)selStr subKey:(NSString *)strId;

- (void)deleteSelValue:(NSString *)value forMainKey:(NSString *)selStr subKey:(NSString *)strId;


@end

NS_ASSUME_NONNULL_END
