//
//  ViewController.m
//  MiniChat
//
//  Created by 陈华谋 on 29/04/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "ViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:RongCloudToken success:^(NSString *userId) {
        NSLog(@"----成功连接服务器");
    } error:^(RCConnectErrorCode status) {
        NSLog(@"----连接服务器失败");
    } tokenIncorrect:^{
         NSLog(@"----token错误");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
