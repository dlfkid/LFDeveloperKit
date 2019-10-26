//
//  NSDictionary+ShadowArchive.h
//  LFDeveloperKitDemo
//
//  Created by Ivan_deng on 2019/10/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ShadowArchive)

@property (nonatomic, copy, readonly) NSDictionary *reportShadowArchiver;
@property (nonatomic, copy, readonly) NSDictionary *reportShadowUnarchiver;
@property (nonatomic, copy, readonly) NSDictionary *desireShadowArchiver;
@property (nonatomic, copy, readonly) NSDictionary *desireShadowUnarchiver;

@end

NS_ASSUME_NONNULL_END
