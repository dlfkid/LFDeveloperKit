//
//  LFDeveloper.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/2/14.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFDeveloper : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descroptions;

- (instancetype)initWithIdentifier:(NSString *)identifier Name:(NSString *)name Descriptions:(NSString *)descriptions;

- (instancetype)initWithIdentifier:(NSString *)identifier Name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
