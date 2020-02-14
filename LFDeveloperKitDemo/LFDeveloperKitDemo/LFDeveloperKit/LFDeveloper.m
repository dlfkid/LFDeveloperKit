//
//  LFDeveloper.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/2/14.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "LFDeveloper.h"

@interface LFDeveloper()<NSSecureCoding>

@end

@implementation LFDeveloper

#pragma mark - Public

- (instancetype)initWithIdentifier:(NSString *)identifier Name:(NSString *)name Descriptions:(NSString *)descriptions {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.name = name;
        self.descroptions = descriptions;
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier Name:(NSString *)name {
    return [self initWithIdentifier:identifier Name:name Descriptions:@""];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@ | identifier: %@ | descroptions: %@", self.name, self.identifier, self.descroptions];
}

#pragma mark - Private

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.descroptions forKey:@"descriptions"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.descroptions = [coder decodeObjectForKey:@"descriptions"];
    }
    return self;
}

#pragma mark - LazyLoads

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = @"";
    }
    return _identifier;
}

- (NSString *)name {
    if (!_name) {
        _name = @"";
    }
    return _name;
}

- (NSString *)descriptions {
    if (!_descroptions) {
        _descroptions = @"";
    }
    return _descroptions;
}

@end
