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
#import <Photos/Photos.h>

static CGFloat const rowHeight = 44;
static CGFloat const sectionHeight = 15;

static NSString *const headerCellReuseId = @"CHMGroupSettingHeaderCell";  // 头部collection view 重用标识
static NSString *const itemCellReuseId = @"CHMGroupSettingHeaderCell";    // table view  cell 重用标识

static NSString *const addMember = @"GroupAdd";    // 添加成员
static NSString *const deleteMember = @"GroupCutdown";    // 删除成员


@interface CHMGroupSettingController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) CHMGroupModel *cuurentGroupModel;

@property (nonatomic, strong) UICollectionView *headerView;
@property (nonatomic, strong) NSMutableArray *collectionViewResource;


@property (nonatomic, strong) CHMGroupSettingFooter *tableViewFooter;

@property (nonatomic, strong) NSArray *itemArray;  // 条目数组

@property (nonatomic, strong) UIViewController *deleteVC;  // 删除数组控制器

@property (nonatomic, strong) UIImagePickerController *imagePickerController; // 为了群头像

@end

@implementation CHMGroupSettingController

#pragma mark - load data
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
    cell.infoDict = _itemArray[indexPath.section][indexPath.row];
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 群头像
            [self portraitClick];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 2) {
            [self clearChatCache];
        }
    }
}

#pragma mark - 清除聊天记录
/**
 清除聊天记录
 */
- (void)clearChatCache {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定清除聊天记录？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // cancle action
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    // comfirm action
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self clearMessageCache];
    }];
    
    [alertController addAction:comfirmAction];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)clearMessageCache {
    __weak typeof(self) weakSelf = self;
    NSArray *latestMessages = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_GROUP targetId:_groupId count:1];
    if (latestMessages.count > 0) {
        [CHMProgressHUD showWithInfo:@"正在清除中..." isHaveMask:YES];
//        RCMessage *message = (RCMessage *)[latestMessages firstObject];
        
        
        [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_GROUP
                                             targetId:weakSelf.groupId
                                              success:^{
                                                  [CHMProgressHUD showSuccessWithInfo:@"清除成功"];
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:KClearHistoryMsg object:nil];
                                                  
                                              }
                                                error:^(RCErrorCode status) {
                                                    [CHMProgressHUD dismissHUD];
                                                }];
        
        // 远程消息需要开通增值服务才可以
//        [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:ConversationType_GROUP
//                                                        targetId:weakSelf.groupId
//                                                      recordTime:message.sentTime
//                                                         success:^{
//                                                             [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_GROUP
//                                                                                                  targetId:weakSelf.groupId
//                                                                                                   success:^{
//                                                                                                       [CHMProgressHUD showSuccessWithInfo:@"清除成功"];
//                                                                                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearHistoryMsg" object:nil];
//
//                                                                                                   }
//                                                                                                     error:^(RCErrorCode status) {
//                                                                                                         [CHMProgressHUD dismissHUD];
//                                                                                                     }];
//                                                         }
//                                                           error:^(RCErrorCode status) {
//                                                               [CHMProgressHUD showErrorWithInfo:@"清除失败"];
//                                                           }];
    }
}



#pragma mark - 显示头像弹出框
/**
 显示头像弹出框
 */
- (void)portraitClick {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    // 可编辑
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    
    UIAlertController *alertController = [[UIAlertController alloc] init];
    // 取消
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }];
    // 拍照
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCamera];
    }];
    // 从相册选择
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePicker];
    }];
    [alertController addAction:cancleAction];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 拍照
 */
- (void)showCamera {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        // 没有权限
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else {
        // 是否支持相机功能
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        } else {
            [CHMProgressHUD showErrorWithInfo:@"相机功能不可用"];
        }
    }
}
/**
 从相册选中照片
 */
- (void)showImagePicker {
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    if (authorizationStatus == PHAuthorizationStatusDenied || authorizationStatus == PHAuthorizationStatusRestricted) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        } else {
            [CHMProgressHUD showErrorWithInfo:@"相册功能不可用"];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self imagePickerControllerDidCancel:picker];
    UIImage *selectedImage = nil;
    selectedImage = picker.allowsEditing ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    [self uploadPortraitWithImage:selectedImage];
}

/**
 上传头像
 */
- (void)uploadPortraitWithImage:(UIImage *)image {
    // 上传头像到服务器
    [CHMProgressHUD showWithInfo:@"正在上传中..." isHaveMask:YES];
    __weak typeof(self) weakSelf = self;
    
    [CHMHttpTool setGroupPortraitWithGroupId:_groupId groupPortrait:image success:^(id response) {
        NSLog(@"-------------%@",response);
        NSNumber *codeId = response[@"Code"][@"CodeId"];
        if (codeId.integerValue == 100) {
            [CHMProgressHUD dismissHUD];
            NSString *headerImageString = [NSString stringWithFormat:@"%@%@", BaseURL, response[@"Value"][@"GroupImage"]];
            // 保存到本地
            CHMGroupModel *groupModel = [[CHMGroupModel alloc] initWithGroupId:weakSelf.groupId groupName:weakSelf.groupName groupPortrait:headerImageString];
            [[CHMDataBaseManager shareManager] insertGroupToDB:groupModel];
            // 刷新cell
            [weakSelf initLocalData];
            [weakSelf.tableView reloadData];
        } else {
            [CHMProgressHUD showErrorWithInfo:response[@"Code"][@"Description"]];
        }
    } failure:^(NSError *error) {
        [CHMProgressHUD showErrorWithInfo:[NSString stringWithFormat:@"错误码--%ld",(long)error.code]];
    }];
}


#pragma mark - view life  cycler
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [CHMProgressHUD dismissHUD];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLocalData];
    
    [self setupAppearance];
    
    [self getGroupInfo];
}

/**
 获取本地数据
 */
- (void)initLocalData {
    self.cuurentGroupModel = [[CHMDataBaseManager shareManager] getGroupByGroupId:_groupId];
    
    self.itemArray = @[@[@{KItemName: @"群组头像", KItemIsShowSwitch: @"o", KItemPortrait: _cuurentGroupModel.GroupImage, KItemSwitch: @"0", KItemValue:@""},
                         @{KItemName: @"群组名称", KItemIsShowSwitch: @"o", KItemPortrait: @"", KItemSwitch: @"0", KItemValue:_cuurentGroupModel.GroupName},
                         @{KItemName: @"群公告", KItemIsShowSwitch: @"o", KItemPortrait: @"", KItemSwitch: @"0", KItemValue:@""}
                         ],
                       
                       @[@{KItemName: @"查找聊天记录", KItemIsShowSwitch: @"o", KItemPortrait: @"", KItemSwitch: @"0", KItemValue:@""},],
                       
                       @[@{KItemName: @"消息免打扰", KItemIsShowSwitch: @"1", KItemPortrait: @"", KItemSwitch: @"0", KItemValue:@""},
                         @{KItemName: @"会话置顶", KItemIsShowSwitch: @"1", KItemPortrait: @"", KItemSwitch: @"0", KItemValue:@""},
                         @{KItemName: @"清除聊天记录", KItemIsShowSwitch: @"o", KItemPortrait: @"", KItemSwitch: @"0", KItemValue:@""}
                         ]
                       ];
}


/**
 设置外观
 */
- (void)setupAppearance {
    // 返回按钮
    //    CHMBarButtonItem *leftButton = [[CHMBarButtonItem alloc] initWithLeftBarButton:@"返回" target:self action:@selector(backBarButtonItemClicked:)];
    //    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    
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


@end
