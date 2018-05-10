//
//  CHMMainController.m
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMMainController.h"
#import "CHMInfoProvider.h"

@interface CHMMainController () <RCIMReceiveMessageDelegate>

@end

@implementation CHMMainController

#pragma mark - RCIMReceiveMessageDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    NSLog(@"-------%@",message);
    RCContactNotificationMessage *contactNotificationMsg = nil;
    if ([message.objectName isEqualToString:@"RC:ContactNtf"]) {
        contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        // 如果是同意好友申请的消息，就刷新好友列表数据
        NSString *account = [[NSUserDefaults standardUserDefaults] valueForKey:KAccount];
        [[CHMInfoProvider shareInstance] syncFriendList:account complete:^(NSMutableArray *friends) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KChangeUserInfoNotification object:nil];
        }];
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 连接融云服务器
    [self connectToRongCloud];
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
}



/**
 连接融云服务器
 */
- (void)connectToRongCloud {
    NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] valueForKey:KRongCloudToken];
    [[RCIM sharedRCIM] connectWithToken:rongCloudToken success:^(NSString *userId) {
        NSLog(@"----连接成功%@",userId);
        [self setCurrentUserInfo];
        
        [self refreshOfficeAccount];
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"----连接失败%ld",(long)status);
    } tokenIncorrect:^{
        NSLog(@"----连接token不正确");
    }];
}


/**
 设置当前用户的用户信息，用于SDK显示和发送。
 */
- (void)setCurrentUserInfo {
    // 从沙盒中取登录时保存的用户信息
    NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:KNickName];
    NSString *account = [[NSUserDefaults standardUserDefaults] valueForKey:KAccount];
    NSString *portrait = [[NSUserDefaults standardUserDefaults] valueForKey:KPortrait];
    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:account name:nickName portrait:portrait];
}



#pragma mark - 用户信息提供者



/**
 刷新 官方客服 和 资金助手
 */
- (void)refreshOfficeAccount {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
