//
//  TestViewController.h
//  LFDeveloperKitDemo
//
//  Created by LeonDeng on 2020/4/1.
//  Copyright © 2020 LeonDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController : UIViewController

- (void)testPrint;

- (void)testPrintWithParameterInteger:(NSInteger)integer NSString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
