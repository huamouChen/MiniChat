//
//  CHMUserDetailController.m
//  MiniChat
//
//  Created by 陈华谋 on 03/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMUserDetailController.h"
#import "CHMMineDetailCell.h"
#import "CHMFriendModel.h"
#import "CHMGroupMemberModel.h"
#import "CHMUserDetailFooter.h"
#import "CHMConversationController.h"

static NSString *const detailReuseablId = @"CHMMineDetailCell";

@interface CHMUserDetailController ()

@property (nonatomic, strong) NSArray *datasArray;

@end

@implementation CHMUserDetailController

#pragma mark - 点击操作
/**
 点击发消息的按钮
 */
- (void)sendMessageButtonClick {
    //新建一个聊天会话View Controller对象,建议这样初始化
    CHMConversationController *chatController = [[CHMConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:_friendModel.UserName];
    [chatController setHidesBottomBarWhenPushed:YES];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatController.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatController.targetId = _friendModel.UserName;
    //设置聊天会话界面要显示的标题
    chatController.title = _friendModel.NickName;
    //显示聊天会话界面
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - view life cycler
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
    
    [self initData];
}

/**
 设置控件
 */
- (void)setupAppearance {
    self.title = @"用户详情";
    // 设置尾部视图
    CHMUserDetailFooter *footer = [CHMUserDetailFooter footerWithTableView:self.tableView];
    // 点击发送消息的按钮
    footer.sendMessageBlock = ^{
        [self sendMessageButtonClick];
    };
    self.tableView.tableFooterView = footer;
    
    // register cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMMineDetailCell class]) bundle:nil] forCellReuseIdentifier:detailReuseablId];
    
    // auto estima height
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.backgroundColor = [UIColor chm_colorWithHexString:KTableViweBackgroundColor alpha:1.0];
}


/**
 初始化数据
 */
- (void)initData {
    if (_friendModel) {
    self.datasArray = @[@[@{KPortrait:_friendModel.HeaderImage, KNickName: _friendModel.NickName, KAccount: _friendModel.UserName}]];
    }
    
    if (_groupMemberModel) {
        self.datasArray = @[@[@{KPortrait:_groupMemberModel.HeaderImage, KNickName: _groupMemberModel.NickName, KAccount: _groupMemberModel.UserName}]];
    }
    
}


#pragma mark - table view data sourece
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *itemArray = self.datasArray[section];
    return itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMMineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailReuseablId];
    cell.infoDict = self.datasArray[indexPath.section][indexPath.row];
    cell.isHideRightArrow = YES;
    return cell;
}


#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor chm_colorWithHexString:KTableViweBackgroundColor alpha:1.0];
    return sectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
