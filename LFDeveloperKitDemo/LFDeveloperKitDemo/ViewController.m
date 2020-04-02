//
//  ViewController.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2019/9/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "NSObject+DeallocCallBack.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *VCButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, unsafe_unretained) TestViewController *testVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _VCButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_VCButton setTitle:@"ViewController" forState:UIControlStateNormal];
    [_VCButton addTarget:self action:@selector(vcButtonDidTappedAction:) forControlEvents:UIControlEventTouchUpInside];
    _VCButton.frame = CGRectMake(80, 100, 180, 80);
    _testButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_testButton setTitle:@"Test" forState:UIControlStateNormal];
    [_testButton addTarget:self action:@selector(testButtonDidTappedAction:) forControlEvents:UIControlEventTouchUpInside];
    _testButton.frame = CGRectMake(80, 160, 180, 80);
    [self.view addSubview:self.VCButton];
    [self.view addSubview:self.testButton];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)vcButtonDidTappedAction:(UIButton *)button {
    TestViewController *controller = [[TestViewController alloc] init];
    _testVC = controller;
    [controller willDeallocWithCallBack:^(id  _Nonnull owner, NSInteger identifier) {
        __strong typeof(owner) strongOwner = owner;
        TestViewController *controller = strongOwner;
        [controller testPrint];
    }];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)testButtonDidTappedAction:(UIButton *)button {
    [self.testVC testPrint];
}

@end
