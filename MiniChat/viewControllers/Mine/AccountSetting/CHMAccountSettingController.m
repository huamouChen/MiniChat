//
//  CHMAccountSettingController.m
//  MiniChat
//
//  Created by 陈华谋 on 02/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMAccountSettingController.h"
#import "CHMAccountSettingCell.h"
#import "CHMLogoutCell.h"

static NSString *const settingCellReuseId = @"CHMAccountSettingCell";
static NSString *const logoutCellReuseId = @"CHMLogoutCell";
static int const rowHeight = 44;
static int const sectionHeaderHeight = 15;

@interface CHMAccountSettingController ()
@property (nonatomic, strong) NSArray *itemArray;
@end

@implementation CHMAccountSettingController

#pragma mark - view life cycler
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置外观
    [self setupAppearance];
    
    // 获取数据
    [self initData];
}


/**
 初始化外观
 */
- (void)setupAppearance {
    self.title = @"账号设置";
    // tableFooterView
    self.tableView.tableFooterView = [UIView new];
    // register cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMAccountSettingCell class]) bundle:nil] forCellReuseIdentifier:settingCellReuseId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMLogoutCell class]) bundle:nil] forCellReuseIdentifier:logoutCellReuseId];
    // row height
    self.tableView.rowHeight = rowHeight;
    // section view height
    self.tableView.sectionHeaderHeight = sectionHeaderHeight;
    // background color
    self.tableView.backgroundColor = [UIColor chm_colorWithHexString:KTableViweBackgroundColor alpha:1.0];
}


/**
 初始化数据
 */
- (void)initData {
    self.itemArray = @[@[@{KTitle: @"密码修改"},
                         @{KTitle: @"隐私"},
                         @{KTitle: @"新消息通知"},
                         @{KTitle: @"推送设置"}],
                       @[@{KTitle: @"清除缓存"}],
                       @[@{KTitle: @"退出登录"}]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.itemArray[section];
    return sectionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        CHMLogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:logoutCellReuseId];
        cell.infoDict = self.itemArray[indexPath.section][indexPath.row];
        return cell;
    }
    CHMAccountSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellReuseId];
    cell.infoDict = self.itemArray[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    sectionView.backgroundColor = [UIColor chm_colorWithHexString:KTableViweBackgroundColor alpha:1.0];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        // 退出登录
        [self logout];
    }
}


#pragma mark - cell 点击响应方法

/**
 退出登录
 */
- (void)logout {
    // 清空保存的数据
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KRongCloudToken];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KLoginToken];
    
    [CHMProgressHUD showWithInfo:@"正在退出登录..." isHaveMask:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CHMProgressHUD dismissHUD];
        // 退出融云
        [[RCIM sharedRCIM] logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:KSwitchRootViewController object:nil];
    });
    
    
}

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

@end
