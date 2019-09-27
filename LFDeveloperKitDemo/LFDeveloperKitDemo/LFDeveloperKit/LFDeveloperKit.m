//
//  LFDeveloperKit.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2019/9/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "LFDeveloperKit.h"

@interface LFDeveloperKit()

@property (nonatomic, strong) NSArray <NSString *> *developerIDs;

@end

static dispatch_once_t onceToken;
static LFDeveloperKit *_sharedInstance;

@implementation LFDeveloperKit

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LFDeveloperKit alloc] init];
    });
    return _sharedInstance;
}

- (void)registerDevelopers:(NSArray<NSString *> *)developerIdentifiers {
    _developerIDs = developerIdentifiers;
}

- (BOOL)isDeveloper {
    for (NSString *developerID in self.developerIDs) {
        if ([self.currentDeveloper isEqualToString:developerID]) {
            return YES;
        }
    }
    return NO;
}

@end
