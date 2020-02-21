//
//  LFDeveloperKit.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2019/9/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LFSharedKit [LFDeveloperKit sharedInstance]

@class LFDeveloper;

NS_ASSUME_NONNULL_BEGIN

@protocol LFDeveloperKitDelegate <NSObject>

- (void)lf_logFormattedMessage:(NSString *)message;

@end

@interface LFDeveloperKit : NSObject

/// Saved developerDictionary
@property (nonatomic, strong, readonly) NSDictionary <NSString *, LFDeveloper *> *developerList;

@property (nonatomic, weak) id <LFDeveloperKitDelegate> delegate;

@property (nonatomic, assign) BOOL arrayCrashHookEnable;
@property (nonatomic, assign) BOOL dictionaryCrashHookEnable;
@property (nonatomic, assign) BOOL stringCrashHookEnable;

+ (instancetype)sharedInstance;

/// Write a new or exist developer
/// @param developer develoeprModel
- (void)saveDeveloper:(LFDeveloper *)developer;

/// remove a developer from the list
/// @param developer developer
- (void)removeDeveloperWithDeveloper:(LFDeveloper *)developer;

- (void)clearAllDevelopers;

- (void)printLogWithFormat:(NSString *)formattedLog, ... NS_FORMAT_FUNCTION(1, 2);

@end

NS_ASSUME_NONNULL_END
