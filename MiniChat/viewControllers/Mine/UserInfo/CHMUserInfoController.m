//
//  CHMUserInfoController.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/9.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMUserInfoController.h"
#import "CHMUserPortraitCell.h"
#import "CHMUserDetailCell.h"
#import "CHMEditUserInfoController.h"

static NSString *const portraitCellReuseId = @"CHMUserPortraitCell";
static NSString *const detailCellReuseId = @"CHMUserDetailCell";

@interface CHMUserInfoController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CHMUserInfoController

#pragma mark - view life cycler
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initLocalData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupAppearance];
}

/**
 初始化本地数据
 */
- (void)initLocalData {
    NSString *portraitString = [[NSUserDefaults standardUserDefaults] valueForKey:KPortrait];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:KNickName];
    NSString *mobileString = [[NSUserDefaults standardUserDefaults] valueForKey:KPhoneNum];
    
    self.dataArray = @[@{KItemName: @"头像", KItemValue: portraitString},
                       @{KItemName: @"昵称", KItemValue: nickName},
                       @{KItemName: @"手机", KItemValue: mobileString}];
    
    [self.tableView reloadData];
}

/**
 设置外观
 */
- (void)setupAppearance {
    self.title = @"个人信息";
    
    // table footer
    self.tableView.tableFooterView = [UIView new];
    // regsiter cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMUserPortraitCell class]) bundle:nil] forCellReuseIdentifier:portraitCellReuseId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMUserDetailCell class]) bundle:nil] forCellReuseIdentifier:detailCellReuseId];
    // row height
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CHMUserPortraitCell *cell = [tableView dequeueReusableCellWithIdentifier:portraitCellReuseId];
        cell.infoDict = _dataArray[indexPath.row];
        return cell;
    }
    
    CHMUserDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellReuseId];
    cell.infoDict = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: // 头像
            [self portraitClick];
            break;
        case 1: // 昵称
            [self nickNameClick];
            break;
        case 2:  //手机号
            [self mobileClcick];
            break;
        default:
            break;
    }
}


/**
 点击头像
 */
- (void)portraitClick {
    
}


/**
 点击昵称
 */
- (void)nickNameClick {
    CHMEditUserInfoController *editController = [CHMEditUserInfoController new];
    editController.isEditNickName = YES;
    [self.navigationController pushViewController:editController animated:YES];
}


/**
 点击手机号码
 */
- (void)mobileClcick {
    CHMEditUserInfoController *editController = [CHMEditUserInfoController new];
    editController.isEditNickName = NO;
    [self.navigationController pushViewController:editController animated:YES];
}


- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


@end
