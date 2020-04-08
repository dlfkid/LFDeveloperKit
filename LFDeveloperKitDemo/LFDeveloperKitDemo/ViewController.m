//
//  ViewController.m
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2019/9/27.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "NSObject+LFObjectHook.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *VCButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UIButton *removeSwizzleButton;
@property (nonatomic, strong) TestViewController *testVC;
@property (nonatomic, strong) TestViewController *testVC2;

@end

static NSString * const kSwizzleIdentifier = @"swizzleTestPrint";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _VCButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_VCButton setTitle:@"Swizzle" forState:UIControlStateNormal];
    [_VCButton addTarget:self action:@selector(vcButtonDidTappedAction:) forControlEvents:UIControlEventTouchUpInside];
    _VCButton.frame = CGRectMake(80, 100, 180, 80);
    _testButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_testButton setTitle:@"Test" forState:UIControlStateNormal];
    [_testButton addTarget:self action:@selector(testButtonDidTappedAction:) forControlEvents:UIControlEventTouchUpInside];
    _testButton.frame = CGRectMake(80, 160, 180, 80);
    _removeSwizzleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_removeSwizzleButton setTitle:@"Remove Swizzle" forState:UIControlStateNormal];
    [_removeSwizzleButton addTarget:self action:@selector(removeSwizzleButtonDidTappedAction:) forControlEvents:UIControlEventTouchUpInside];
    _removeSwizzleButton.frame = CGRectMake(80, 220, 180, 80);
    [self.view addSubview:self.VCButton];
    [self.view addSubview:self.testButton];
    [self.view addSubview:self.removeSwizzleButton];
    TestViewController *controller = [[TestViewController alloc] init];
    _testVC = controller;
    TestViewController *controller2 = [[TestViewController alloc] init];
    _testVC2 = controller2;
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)vcButtonDidTappedAction:(UIButton *)button {
    
    void(^hookedTestPrint)(id, NSInteger, NSString *) = ^(id objectSelf, NSInteger integer, NSString *string){
        [objectSelf callOriginalMethodInBlock:^{
            [objectSelf testPrintWithParameterInteger:integer NSString:string];
        }];
        NSLog(@"Hooked Test print Number: %ld Text: %@", integer, string);
    };
    
    [self.testVC2 hookMethod:@selector(testPrintWithParameterInteger:NSString:) ImplementationBlock:hookedTestPrint];
}

- (void)testButtonDidTappedAction:(UIButton *)button {
    // [self.testVC testPrintWithParameterInteger:10 NSString:@"I am Iron man"];
    [self.testVC2 testPrintWithParameterInteger:10 NSString:@"I am Iron man"];
}

- (void)removeSwizzleButtonDidTappedAction:(UIButton *)sender {
    [self.testVC2 unhookMethod:@selector(testPrintWithParameterInteger:NSString:)];
}

@end
