//
//  LFDeveloperKit.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2019/9/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "LFDeveloperKit.h"

#import "LFDeveloper.h"

@interface LFDeveloperKit()

@property (nonatomic, strong) NSDictionary <NSString *, LFDeveloper *> *developerList;

@end

static dispatch_once_t onceToken;
static LFDeveloperKit *_sharedInstance;

@implementation LFDeveloperKit

#pragma mark - Private

- (NSString *)archivePath {
    NSString *sandBoxPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [sandBoxPath stringByAppendingPathComponent:@"LFDeveloper.data"];
    return filePath;
}

#pragma mark - Public

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LFDeveloperKit alloc] init];
    });
    return _sharedInstance;
}

- (void)printLogWithFormat:(NSString *)formattedLog, ... {
    if ([self.delegate respondsToSelector:@selector(lf_logFormattedMessage:)]) {
        va_list args;
        va_start(args, formattedLog);
        NSString *rst = [[NSString alloc] initWithFormat:formattedLog arguments:args];
        va_end(args);
        [self.delegate lf_logFormattedMessage:rst];
    }
}

- (void)saveDeveloper:(LFDeveloper *)developer {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.developerList];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    [dict setObject:developer forKey:developer.identifier];
    if (@available(iOS 11.0, *)) {
        NSError *saveError = nil;
        NSData *encrpytData = [NSKeyedArchiver archivedDataWithRootObject:dict requiringSecureCoding:YES error:&saveError];
        [NSKeyedArchiver archiveRootObject:encrpytData toFile:[self archivePath]];
    } else {
        NSData *encrpytData = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [NSKeyedArchiver archiveRootObject:encrpytData toFile:[self archivePath]];
    }
}

- (void)removeDeveloperWithDeveloper:(LFDeveloper *)developer {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.developerList];
    [dict removeObjectForKey:developer.identifier];
    if (@available(iOS 11.0, *)) {
        NSError *saveError = nil;
        NSData *encrpytData = [NSKeyedArchiver archivedDataWithRootObject:dict requiringSecureCoding:YES error:&saveError];
        [NSKeyedArchiver archiveRootObject:encrpytData toFile:[self archivePath]];
    } else {
        NSData *encrpytData = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [NSKeyedArchiver archiveRootObject:encrpytData toFile:[self archivePath]];
    }
}

- (void)clearAllDevelopers {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self archivePath]]) {
        NSError *error = nil;
        [manager removeItemAtPath:[self archivePath] error:&error];
    }
}

#pragma mark - LazyLoads

- (NSDictionary *)developerList {
    if (!_developerList) {
        NSData *encryptData = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
        NSError *loadError = nil;
        if (@available(iOS 11.0, *)) {
            _developerList = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:encryptData error:&loadError];
        } else {
            // Fallback on earlier versions
            _developerList = [NSKeyedUnarchiver unarchiveObjectWithData:encryptData];
        }
    }
    return _developerList;
}

@end
