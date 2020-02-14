//
//  AppDelegate.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2019/9/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "AppDelegate.h"

#import "LFDeveloper.h"
#import "LFDeveloperKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([LFDeveloperKit sharedInstance].developerList.allKeys.count == 0) {
        LFDeveloper *developer1 = [[LFDeveloper alloc] initWithIdentifier:@"1234986" Name:@"Hello"];
        LFDeveloper *developer2 = [[LFDeveloper alloc] initWithIdentifier:@"1264913" Name:@"world"];
        
        [[LFDeveloperKit sharedInstance] saveDeveloper:developer1];
        [[LFDeveloperKit sharedInstance] saveDeveloper:developer2];
    } else {
        NSLog(@"Developers: %@", [LFDeveloperKit sharedInstance].developerList.description);
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
