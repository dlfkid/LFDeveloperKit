//
//  LFOrderedDict.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/3.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFOrderedDict : NSObject

- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObject:(id)object forKey:(NSString *)key;
- (NSArray *)objectArrayForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
