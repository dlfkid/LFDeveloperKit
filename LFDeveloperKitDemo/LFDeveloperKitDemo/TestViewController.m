//
//  TestViewController.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/1.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"View will disappear");
}

- (void)dealloc {
    NSLog(@"%@: Test view controller is dealloced", self);
}

- (void)testPrint {
    NSLog(@"Run instance method");
}

@end
