//
//  NSDictionary+ShadowArchive.m
//  LFDeveloperKitDemo
//
//  Created by Ivan_deng on 2019/10/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "NSDictionary+ShadowArchive.h"


@implementation NSDictionary (ShadowArchive)

- (NSDictionary *)reportShadowArchiver {
    NSDictionary *shadow = @{@"state": @{@"reported": self}};
    return shadow;
}

- (NSDictionary *)reportShadowUnarchiver {
    NSDictionary *reported = self[@"state"][@"reported"];
    return reported;
}

- (NSDictionary *)desireShadowArchiver {
    NSDictionary *shadow = @{@"state": @{@"desired": self}};
    return shadow;
}

- (NSDictionary *)desireShadowUnarchiver {
    NSDictionary *reported = self[@"state"][@"desire"];
    return reported;
}

@end
