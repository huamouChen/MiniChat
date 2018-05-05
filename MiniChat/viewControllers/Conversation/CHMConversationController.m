//
//  CHMConversationController.m
//  MiniChat
//
//  Created by 陈华谋 on 02/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMConversationController.h"
#import "CHMBettingController.h"

static NSInteger const bettingTag = 2000;

@interface CHMConversationController ()

@end

@implementation CHMConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加拓展框的插件
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"AddPhotoDefault"] title:@"玩法" atIndex:0 tag:bettingTag];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    
    // 玩法
    if (tag == bettingTag) {
        CHMBettingController *bettingController = [CHMBettingController new];
        bettingController.targetId = self.targetId;
        bettingController.conversationType = self.conversationType;
        // 设置样式才能设置透明
        bettingController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:bettingController animated:YES completion:nil];
    }
}



#pragma mark - 发送消息
// 发送消息
- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent {
    [super sendMessage:messageContent pushContent:pushContent];
    if (self.conversationType == ConversationType_GROUP || self.conversationType == ConversationType_CHATROOM) {
        if ([messageContent isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *txtMsg = (RCTextMessage *)messageContent;
            // 把文本消息都发送到服务器
            [CHMHttpTool postTxtMessageToServiceWithMessage:txtMsg.content groupId:self.targetId success:^(id response) {
                NSLog(@"--------%@",response);
            } failure:^(NSError *error) {
                NSLog(@"--------%zd",error.code);
            }];
        }
    }
    
}

// 发送消息回调
- (void)didSendMessage:(NSInteger)status content:(RCMessageContent *)messageContent {
    if (status == 0) { // 发送成功
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
