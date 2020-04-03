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

@interface LFObjectHookContainer : NSObject

@property (nonatomic, strong) NSMutableDictionary *selBlockDict;
@property (nonatomic, strong) NSMutableDictionary *resetCountDict;
@property (nonatomic, strong) NSMutableSet *selSet;
@property (nonatomic, strong) LFOrderedDict *selOrderedDict;
@property (nonatomic, assign) int randomFlag;
@property (nonatomic, copy) NSString *className;


@end

NS_ASSUME_NONNULL_END
