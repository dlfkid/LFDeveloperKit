//
//  LFDeveloperKit.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2019/9/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFDeveloperKit : NSObject

@property (nonatomic, strong) NSString *currentDeveloper;
@property (nonatomic, assign, readonly) BOOL isDeveloper;

+ (instancetype)sharedInstance;

- (void)registerDevelopers:(NSArray <NSString *> *)developerIdentifiers;



@end

NS_ASSUME_NONNULL_END
