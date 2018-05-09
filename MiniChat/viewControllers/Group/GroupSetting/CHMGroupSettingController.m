//
//  CHMGroupSettingController.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/6.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMGroupSettingController.h"
#import "CHMGroupModel.h"
#import "CHMGroupSettingHeaderCell.h"
#import "CHMGroupSettingCell.h"
#import "CHMGroupSettingFooter.h"
#import "CHMGroupMemberModel.h"
#import "CHMUserDetailController.h"
#import "CHMSelectMemberController.h"

static CGFloat const rowHeight = 44;
static CGFloat const sectionHeight = 15;

static NSString *const headerCellReuseId = @"CHMGroupSettingHeaderCell";  // 头部collection view 重用标识
static NSString *const itemCellReuseId = @"CHMGroupSettingHeaderCell";    // table view  cell 重用标识

static NSString *const addMember = @"GroupAdd";    // 添加成员
static NSString *const deleteMember = @"GroupCutdown";    // 删除成员


@interface CHMGroupSettingController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *headerView;
@property (nonatomic, strong) NSMutableArray *collectionViewResource;


@property (nonatomic, strong) CHMGroupSettingFooter *tableViewFooter;

@property (nonatomic, strong) NSArray *itemArray;  // 条目数组

@property (nonatomic, strong) UIViewController *deleteVC;  // 删除数组控制器

@end

@implementation CHMGroupSettingController

#pragma mark - 获取数据
/**
 获取群组成员
 */
- (void)startLoad {
    __weak typeof(self) weakSelf = self;
    [CHMHttpTool getGroupMembersWithGroupId:self.groupId success:^(id response) {
        NSLog(@"--------%@",response);
        NSNumber *codeId = response[@"Code"][@"CodeId"];
        if (codeId.integerValue == 100) {
            NSArray *groupMemberArray = [CHMGroupMemberModel mj_objectArrayWithKeyValuesArray:response[@"Value"]];
            weakSelf.collectionViewResource = [NSMutableArray arrayWithArray:groupMemberArray];
            // 加多 加号和减号
            CHMGroupMemberModel *addModel = [[CHMGroupMemberModel alloc] initWithUserName:addMember nickName:@"" headerImage:@"add_member" groupId:self.groupId];
            CHMGroupMemberModel *cutdownModel = [[CHMGroupMemberModel alloc] initWithUserName:deleteMember nickName:@"" headerImage:@"delete_member" groupId:self.groupId];
            [weakSelf.collectionViewResource addObject:addModel];
            [weakSelf.collectionViewResource addObject:cutdownModel];
            [weakSelf.headerView reloadData];
        } else {
            [CHMProgressHUD showErrorWithInfo:response[@"Code"][@"Description"]];
        }
    } failure:^(NSError *error) {
        [CHMProgressHUD showErrorWithInfo:[NSString stringWithFormat:@"错误码--%zd", error.code]];
    }];
}




/**
 获取群组消息
 */
- (void)getGroupInfo {
    [CHMHttpTool getGroupInfoWithGroupId:_groupId success:^(id response) {
        NSLog(@"--------%@",response);
        NSNumber *codeId = response[@"Code"][@"CodeId"];
        if (codeId.integerValue == 100) {
            self.groupName = response[@"Value"][@"GroupName"];
        } else {
            [CHMProgressHUD showErrorWithInfo:response[@"Code"][@"Description"]];
        }
    } failure:^(NSError *error) {
        [CHMProgressHUD showErrorWithInfo:[NSString stringWithFormat:@"错误码--%zd", error.code]];
    }];
}


/**
 点击底部退出按钮 或者解散按钮
 */
- (void)tableViewFooterViewDismissButtongClick {
    NSLog(@"--------退出或者解散");
}


/**
 群组添加成员
 */
- (void)addGroupMember {
    __weak typeof(self) weakSelf = self;
    CHMSelectMemberController *selectMemberVC = [CHMSelectMemberController new];
    selectMemberVC.isAddMember = YES;
    selectMemberVC.sourceArrar = self.collectionViewResource;
    selectMemberVC.groupId = self.groupId;
    selectMemberVC.groupName = self.groupName == nil ? @"" : self.groupName;
    selectMemberVC.addMemberBlock = ^(NSArray *groupMemberArray) {
        [weakSelf.collectionViewResource addObjectsFromArray:groupMemberArray];
        [weakSelf.headerView reloadData];
    };
    self.deleteVC = selectMemberVC;
    [self.navigationController pushViewController:selectMemberVC animated:YES];
}


/**
 群组踢人
 */
- (void)deleteMemberFromGroup {
    __weak typeof(self) weakSelf = self;
    CHMSelectMemberController *selectMemberVC = [CHMSelectMemberController new];
    selectMemberVC.isDeleteMember = YES;
    selectMemberVC.sourceArrar = self.collectionViewResource;
    selectMemberVC.groupId = self.groupId;
    selectMemberVC.deleteMemberBlock = ^(NSArray *groupMemberArray) {
        weakSelf.collectionViewResource = [self dealWithDeleteCompleteWithArray:groupMemberArray];
        [weakSelf.headerView reloadData];
    };
    self.deleteVC = selectMemberVC;
    [self.navigationController pushViewController:selectMemberVC animated:YES];
}



/**
 处理踢人之后的数据
 
 @param array 带标记的数组
 @return 处理好的数组
 */
- (NSMutableArray *)dealWithDeleteCompleteWithArray:(NSArray *)array {
    // 返回的数组是二维数组，是分好组的
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSArray *sectionArr = array[i];
        for (CHMGroupMemberModel *itemModel in sectionArr) {
            if (itemModel.isCheck) {
                continue;
            }
            [resultArr addObject:itemModel];
        }
    }
    return resultArr;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 拿出模型
    CHMGroupMemberModel *groupMemberModel = _collectionViewResource[indexPath.item];
    if ([groupMemberModel.UserName isEqualToString:addMember] ) {
        [self addGroupMember];
        return;
    }
    if ([groupMemberModel.UserName isEqualToString:deleteMember] ) {
        [self deleteMemberFromGroup];
        return;
    }
    CHMUserDetailController *userDetailVc = [CHMUserDetailController new];
    userDetailVc.groupMemberModel = groupMemberModel;
    [self.navigationController pushViewController:userDetailVc animated:YES];
}

#pragma mark - collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionViewResource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHMGroupSettingHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCellReuseId forIndexPath:indexPath];
    cell.groupMemberModel = _collectionViewResource[indexPath.item];
    return cell;
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itemArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = _itemArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMGroupSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellReuseId];
    cell.itemTitle = _itemArray[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sectionHeight)];
    view.backgroundColor = [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark view life cycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
    
    [self getGroupInfo];
}


/**
 设置外观
 */
- (void)setupAppearance {
    // 返回按钮
    CHMBarButtonItem *leftButton = [[CHMBarButtonItem alloc] initWithLeftBarButton:@"返回" target:self action:@selector(backBarButtonItemClicked:)];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    self.itemArray = @[@[@"群组头像", @"群组名称", @"群公告"],
                       @[@"查找聊天记录"],
                       @[@"消息免打扰", @"会话置顶", @"清除聊天记录"]];
    
    // collection view
    CGRect tempRect =
    CGRectMake(0, 0, SCREEN_WIDTH, 170);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4.0, 80);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.headerView = [[UICollectionView alloc] initWithFrame:tempRect collectionViewLayout:flowLayout];
    self.headerView.delegate = self;
    self.headerView.dataSource = self;
//    self.headerView.scrollEnabled = NO;
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.headerView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMGroupSettingHeaderCell class]) bundle:nil] forCellWithReuseIdentifier:headerCellReuseId];
    
    // table view
    self.tableView.backgroundColor = [UIColor chm_colorWithHexString:KTableViweBackgroundColor alpha:1.0];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMGroupSettingCell class]) bundle:nil] forCellReuseIdentifier:itemCellReuseId];
    // section height
    self.tableView.sectionHeaderHeight = sectionHeight;
    self.tableView.rowHeight = rowHeight;
    
    // footer
    __weak typeof(self) weakSelf = self;
    self.tableViewFooter = [CHMGroupSettingFooter groupSettingFooterViewTableView:self.tableView];
    self.tableViewFooter.dismissButtonClickBlock = ^{
        [weakSelf tableViewFooterViewDismissButtongClick];
    };
    [self.tableViewFooter.dismissButton setTitle:@"退出" forState:UIControlStateNormal];
    self.tableView.tableFooterView = _tableViewFooter;
    
}


/**
 点击返回按钮
 */
- (void)backBarButtonItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_collectionViewResource.count < 1) {
        [self startLoad];
    }
    if (_collectionViewResource.count > 0) {
        self.title = [NSString stringWithFormat:@"群组信息(%zd)", _collectionViewResource.count];
    } else {
        self.title = @"群组信息";
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

@end
