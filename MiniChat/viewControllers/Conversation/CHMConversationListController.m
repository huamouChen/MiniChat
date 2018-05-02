//
//  CHMConversationController.m
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMConversationListController.h"
#import "CHMConversationController.h"

@interface CHMConversationListController ()

@end

@implementation CHMConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏table view 分割线
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            UITableView *tableView = obj;
            tableView.tableFooterView = [UIView new];
        }
    }];
    
    // 设置需要显示那些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
}

// 点击cell，进入聊天界面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    //新建一个聊天会话View Controller对象,建议这样初始化
    CHMConversationController *chatController = [[CHMConversationController alloc] initWithConversationType:ConversationType_PRIVATE
                                                                                         targetId:@"baikaitest"];
    [chatController setHidesBottomBarWhenPushed:YES];
    
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatController.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatController.targetId = @"baikaitest";
    
    //设置聊天会话界面要显示的标题
    chatController.title = @"感觉有点冷";
    //显示聊天会话界面
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
