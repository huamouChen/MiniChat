//
//  CHMConversationController.m
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMConversationListController.h"
#import "CHMConversationController.h"
#import "CHMBarButtonItem.h"
#import "KxMenu.h"
#import "CHMSelectMemberController.h"

@interface CHMConversationListController ()

@end

@implementation CHMConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
    
    
    // 设置需要显示那些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
    
    
    // 网络不可用的时候，显示网络不可用
    self.isShowNetworkIndicatorView = YES;
    
    
    // IMLib 库获取会话列表
    NSArray *conversationList = [[RCIMClient sharedRCIMClient]
                                 getConversationList:@[@(ConversationType_PRIVATE),
                                                       @(ConversationType_DISCUSSION),
                                                       @(ConversationType_GROUP),
                                                       @(ConversationType_SYSTEM),
                                                       @(ConversationType_APPSERVICE),
                                                       @(ConversationType_PUBLICSERVICE)]];
    for (RCConversation *conversation in conversationList) {
        NSLog(@"会话类型：%lu，目标会话ID：%@", (unsigned long)conversation.conversationType, conversation.targetId);
    }
    
}


#pragma mark - 即将刷新会话列表数据
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    [super willReloadTableData:dataSource];
    for (RCConversation *conversation in dataSource) {
//        NSLog(@"会话类型：%lu，目标会话ID：%@", (unsigned long)conversation.conversationType, conversation.targetId);
    }
    return dataSource;
}

/**
 设置外观
 */
- (void)setupAppearance {
    self.conversationListTableView.tableFooterView= [UIView new];
    
    // navigationBar right item
    CHMBarButtonItem *rightBtn = [[CHMBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"add"]
                                                             imageViewFrame:CGRectMake(0, 0, 17, 17)
                                                                buttonTitle:nil
                                                                 titleColor:nil
                                                                 titleFrame:CGRectZero
                                                                buttonFrame:CGRectMake(0, 0, 17, 17)
                                                                     target:self
                                                                     action:@selector(showMenu:)];
    self.navigationItem.rightBarButtonItems = @[rightBtn];
}


/**
 右上角的弹出框
 
 @param sender 目标按钮，即右上角加号
 */
- (void)showMenu:(UIButton *)sender {
    NSArray *menuItems = @[
                           
                           [KxMenuItem menuItem:@"发起聊天"
                                          image:[UIImage imageNamed:@"startchat_icon"]
                                         target:self
                                         action:@selector(pushChat:)],
                           
                           [KxMenuItem menuItem:@"创建群组"
                                          image:[UIImage imageNamed:@"creategroup_icon"]
                                         target:self
                                         action:@selector(pushContactSelected:)],
                           
                           [KxMenuItem menuItem:@"添加好友"
                                          image:[UIImage imageNamed:@"addfriend_icon"]
                                         target:self
                                         action:@selector(pushAddFriend:)]
                           ];
    
    UIBarButtonItem *rightBarButton = self.navigationItem.rightBarButtonItems[0];
    CGRect targetFrame = rightBarButton.customView.frame;
    CGFloat offset = [UIApplication sharedApplication].statusBarFrame.size.height > 20 ?  54 : 15;
    targetFrame.origin.y = targetFrame.origin.y + offset;
    if (IOS_FSystenVersion >= 11.0) {
        targetFrame.origin.x = self.view.bounds.size.width - targetFrame.size.width - 17;
    }
    [KxMenu setTintColor:[UIColor chm_colorWithHexString:@"#000000" alpha:1.0]];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:17]];
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
}

/**
 *  发起聊天
 *
 *  @param sender sender description
 */
- (void)pushChat:(id)sender {

}

/**
 *  创建群组
 *
 *  @param sender sender description
 */
- (void)pushContactSelected:(id)sender {
    CHMSelectMemberController *selectMemberController = [CHMSelectMemberController new];
    selectMemberController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectMemberController animated:YES];
}

/**
 *  添加好友
 *
 *  @param sender sender description
 */
- (void)pushAddFriend:(id)sender {

}



// 点击cell，进入聊天界面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    // 从会话列表中拿出会话模型
    RCConversation *conversation =  self.conversationListDataSource[indexPath.row];
    
    //新建一个聊天会话View Controller对象,建议这样初始化
    CHMConversationController *chatController = [[CHMConversationController alloc] initWithConversationType:conversation.conversationType
                                                                                                   targetId:conversation.targetId];
    [chatController setHidesBottomBarWhenPushed:YES];
    
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatController.conversationType = conversation.conversationType;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatController.targetId = conversation.targetId;
    
    //设置聊天会话界面要显示的标题
    chatController.title =[conversation.conversationTitle isEqualToString:@""] ? conversation.targetId : conversation.conversationTitle;
    //显示聊天会话界面
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
