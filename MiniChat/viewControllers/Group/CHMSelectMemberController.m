//
//  CHMSelectMemberController.m
//  MiniChat
//
//  Created by 陈华谋 on 04/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMSelectMemberController.h"
#import "CHMSelectMemberCell.h"
#import "CHMFriendModel.h"
#import "CHMContactCell.h"
#import "CHMSectionHeaderView.h"
#import "CHMBarButtonItem.h"
#import "CHMCreateGroupController.h"

static NSString *const selectMemberReuseId = @"CHMSelectMemberCell";
static int const rowHeight = 55;
static int const sectionHeaderHeight = 28;
static CGFloat const KIndexViewWidth = 55 / 2.0;

@interface CHMSelectMemberController () <UITableViewDataSource, UITableViewDelegate>
/**
 数据数组
 */
@property (strong, nonatomic) NSMutableArray *dataArr;

/**
 tableView
 */
@property (strong, nonatomic) UITableView *tableView;

/**
 索引数组
 */
@property (strong, nonatomic) NSMutableArray *indexArr;

/**
 右边索引条容器视图
 */
@property (strong, nonatomic) UIView *indexContentView;

/**
 中间indexLabel
 */
@property (strong, nonatomic) UILabel *indexLabelCenter;

@end

@implementation CHMSelectMemberController

#pragma mark - 点击右边确定按钮
- (void)comfirmButtonClick {
    // 调到创建群组界面
    CHMCreateGroupController *createGroupController = [CHMCreateGroupController new];
    createGroupController.selectedMembersArray = [self dealWithSelectedArray];
    [self.navigationController pushViewController:createGroupController animated:YES];
}


/**
 处理选中的成员数据

 @return 处理好的数组
 */
- (NSMutableArray *)dealWithSelectedArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < self.dataArr.count; i++) {
        NSArray *sectionArray = self.dataArr[i];
        for (int j = 0; j < sectionArray.count; j++) {
            // 如果是选中状态就加入数组
            CHMFriendModel *friendModel = sectionArray[j];
            if (friendModel.isCheck) {
                [resultArray addObject:friendModel];
            }
        }
    }
    return resultArray;
}

#pragma mark - 获取数据
/**
 获取好友列表
 */
- (void)fetchFriendList {
    __weak typeof(self) weakSelf = self;
    [CHMHttpTool getUserRelationShipListWithSuccess:^(id response) {
        NSLog(@"------------%@", response);
        NSNumber *codeId = response[@"Code"][@"CodeId"];
        if (codeId.integerValue == 100) {
            NSMutableArray *friendsArray = [CHMFriendModel mj_objectArrayWithKeyValuesArray:response[@"Value"]];
            // 排序
            [weakSelf.dataArr addObjectsFromArray:[weakSelf testSortWithArray:friendsArray]];
            [weakSelf.tableView reloadData];
        } else {
            // 失败暂时不提醒
        }
    } failure:^(NSError *error) {
        [CHMProgressHUD showErrorWithInfo:[NSString stringWithFormat:@"错误码--%zd", error.code]];
    }];
}

#pragma mark - 排序
- (NSArray *)testSortWithArray:(NSArray *)array {
    // 获取当前位置索引
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //1.获取获取section标题  ABCD
    NSArray *titleArr = collation.sectionTitles;
    
    //2.构建每个section数组  ABCD对应的下属数组
    NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:titleArr.count];
    for (int i = 0; i < titleArr.count; i++) {
        // 即每个分组下的数组
        NSMutableArray *subArr = [NSMutableArray array];
        [sectionArr addObject:subArr];
    }
    
    //3.排序
    //3.1 按照将需要排序的对象放入到对应分区数组 即把首字母相同的放到一个数组中
    for (CHMFriendModel *friendModel in array) {
        NSInteger section = [collation sectionForObject:friendModel collationStringSelector:@selector(NickName)];
        NSMutableArray *subArr = sectionArr[section];
        [subArr addObject:friendModel];
    }
    
    //3.2 分别对分区进行排序  对同一组的再排序 tank taoBao
    for (NSMutableArray *subArr in sectionArr) {
        NSArray *sortArr = [collation sortedArrayFromArray:subArr collationStringSelector:@selector(NickName)];
        [subArr removeAllObjects];
        [subArr addObjectsFromArray:sortArr];
    }
    return [NSArray arrayWithArray:sectionArr];
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.dataArr[section];
    if (sectionArray) {
        return [self.dataArr[section] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMSelectMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:selectMemberReuseId];
    cell.friendModel = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CHMSectionHeaderView *header = [CHMSectionHeaderView headerWithTableView:tableView];
    header.title = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.dataArr[section] count] > 0) {
        return sectionHeaderHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 替换原来的数据
    NSMutableArray *sectionArr = self.dataArr[indexPath.section];
    CHMFriendModel *selectedFriendModel = sectionArr[indexPath.row];
    selectedFriendModel.isCheck = !selectedFriendModel.isCheck;
    [sectionArr replaceObjectAtIndex:indexPath.row withObject:selectedFriendModel];
    [self.dataArr replaceObjectAtIndex:indexPath.section withObject:sectionArr];
    [self.tableView reloadData];
}

#pragma mark - section 不停留
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    }else if (scrollView.contentOffset.y >= sectionHeaderHeight){
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

#pragma mark - view life cycler
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取数据
    [self fetchFriendList];
    
    // 获取本地数据
    [self initLocalData];
    
    // 设置外观
    [self setupAppearance];
}

/**
 设置外观
 */
- (void)setupAppearance {
    self.title = @"选择群组成员";
    
    [self setupRightBarButtonItem];
    
    // footer view
    self.tableView.tableFooterView = [UIView new];
    // register cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMSelectMemberCell class]) bundle:nil] forCellReuseIdentifier:selectMemberReuseId];
    // row height
    self.tableView.rowHeight = rowHeight;
    [self.view addSubview:self.tableView];
    
    // 添加索引中心提醒Label
    self.indexLabelCenter.center = self.tableView.center;
    [self.view addSubview:self.indexLabelCenter];
    // 创建索引视图
    [self creatIndexView];
}


/**
 设置右边 BarButtonItem
 */
- (void)setupRightBarButtonItem {
    CHMBarButtonItem *rightButton = [[CHMBarButtonItem alloc] initWithbuttonTitle:@"确定" titleColor:[UIColor whiteColor] buttonFrame:CGRectMake(0, 0, KNavigationBar44, KNavigationBar64) target:self action:@selector(comfirmButtonClick)];
    
    self.navigationItem.rightBarButtonItems = @[rightButton];
}


/**
 初始化本地写死的数据
 */
- (void)initLocalData {
}

#pragma mark - 创建索引条
- (void)creatIndexView {
    // 高度
    CGFloat labelHeight = self.indexContentView.bounds.size.height / self.indexArr.count;
    
    for (int i = 0; i < self.indexArr.count; i++) {
        NSString *str = self.indexArr[i];
        UILabel *indexLabel = [UILabel initWithString:str fontSize:12 textColor:[UIColor chm_colorWithHexString:KColor7 alpha:1.0]];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        // 计算frame
        indexLabel.frame = CGRectMake(0, i * labelHeight, KIndexViewWidth, labelHeight);
        [self.indexContentView addSubview:indexLabel];
    }
    [self.view addSubview:self.indexContentView];
}

#pragma mark - touch方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 没有数据， 防止崩溃
    if (self.dataArr.count <= 0) {
        return;
    }
    [self myTouch:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 没有数据， 防止崩溃
    if (self.dataArr.count <= 0) {
        return;
    }
    
    [self myTouch:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 设置透明度为 0
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.75 animations:^{
        weakSelf.indexLabelCenter.alpha = 0;
    }];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - 点击索引视图回调
-(void)myTouch:(NSSet *)touches{
    __weak typeof(self) weakSelf = self;
    //    让中间的索引view出现
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.indexLabelCenter.alpha = 1;
    }];
    //    获取点击的区域
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_indexContentView];
    
    CGFloat navigationBarHeight = KIsiPhoneX ? KNavigationBar88 : KNavigationBar64;
    CGFloat tabBarHeight = KIsiPhoneX ? KTouchBarHeight + KTabBar49 : KTabBar49;
    int index = (int)((point.y / (SCREEN_HEIGHT - navigationBarHeight - tabBarHeight)) * self.indexArr.count);
    if (index > 26 || index < 0)return;
    //    给显示的view赋标题
    _indexLabelCenter.text= _indexArr[index];
    //    跳到tableview指定的区
    NSIndexPath *indpath=[NSIndexPath indexPathForRow:0 inSection:index];
    
    // 如果存在元素
    BOOL isHaveElement = [self.dataArr[index] count] > 0;
    if (isHaveElement) {
        [_tableView  scrollToRowAtIndexPath:indpath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


#pragma mark - setter && getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

/**
 [[UILocalizedIndexedCollation currentCollation] sectionTitles]  即可生成 26个字母 + #
 */
- (NSMutableArray *)indexArr {
    if (!_indexArr) {
        _indexArr = [NSMutableArray array];
        // 添加26个字母
        for (int i = 0; i < 26; i++) {
            NSString *str = [NSString stringWithFormat:@"%c",i+65];
            [_indexArr addObject:str];
        }
        // 添加 # 号
        [_indexArr addObject:@"#"];
    }
    return _indexArr;
}

- (UILabel *)indexLabelCenter {
    if (!_indexLabelCenter) {
        _indexLabelCenter = [UILabel initWithString:@"" fontSize:24 textColor:[UIColor whiteColor]];
        _indexLabelCenter.frame = CGRectMake(0, 0, 55, 55);
        _indexLabelCenter.layer.cornerRadius = 5;
        _indexLabelCenter.layer.masksToBounds = YES;
        // 背景颜色
        _indexLabelCenter.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _indexLabelCenter.textAlignment = NSTextAlignmentCenter;
        _indexLabelCenter.alpha = 0;
    }
    return _indexLabelCenter;
}

- (UIView *)indexContentView {
    if (!_indexContentView) {
        CGFloat navigationBarHeight = KIsiPhoneX ? KNavigationBar88 : KNavigationBar64;
        CGFloat tabBarHeight = KIsiPhoneX ? KTouchBarHeight : KTabBar49;
        _indexContentView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - KIndexViewWidth, navigationBarHeight, KIndexViewWidth, SCREEN_HEIGHT - navigationBarHeight - tabBarHeight)];
    }
    return _indexContentView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end