//
//  NSObject+DeallocCallBack.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/3/20.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeallocCallBack.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DeallocCallBack)

- (void)willDeallocWithCallBack:(DeallocSelfCallback)callBack;

@end

NS_ASSUME_NONNULL_END
