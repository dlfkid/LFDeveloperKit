//
//  NSObject+DeallocCallBack.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeallocCallBackContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DeallocCallBack)

- (NSInteger)willDeallocWithCallBack:(DeallocSelfCallback)callBack;

- (NSInteger)removeDeallocCallBackWithIdentifier:(NSInteger)identifier;

@end

NS_ASSUME_NONNULL_END
