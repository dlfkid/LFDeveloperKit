//
//  LFDeveloperKit.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2019/9/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFDeveloper;

NS_ASSUME_NONNULL_BEGIN

@interface LFDeveloperKit : NSObject

/// Saved developerDictionary
@property (nonatomic, strong, readonly) NSDictionary <NSString *, LFDeveloper *> *developerList;

+ (instancetype)sharedInstance;

/// Write a new or exist developer
/// @param developer develoeprModel
- (void)saveDeveloper:(LFDeveloper *)developer;

/// remove a developer from the list
/// @param developer developer
- (void)removeDeveloperWithDeveloper:(LFDeveloper *)developer;

- (void)clearAllDevelopers;

@end

NS_ASSUME_NONNULL_END
