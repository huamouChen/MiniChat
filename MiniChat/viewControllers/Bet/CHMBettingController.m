//
//  CHMBettingController.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/4.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMBettingController.h"
#import "CHMPalyCell.h"
#import "CHMPlayItemModel.h"

static NSString *const playCellReuseId = @"CHMPalyCell";

@interface CHMBettingController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *playCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

// 玩法数组
@property (strong, nonatomic) NSMutableArray *playArray;
// 上一个选中的玩法item
@property (nonatomic, strong) NSIndexPath *preIndexpath;
// 上一个选中的固定金额按钮
@property (nonatomic, strong) UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *button10;
@property (weak, nonatomic) IBOutlet UIButton *button100;
@property (weak, nonatomic) IBOutlet UIButton *button500;
@property (weak, nonatomic) IBOutlet UIButton *button1000;
@end

@implementation CHMBettingController

#pragma mark - 点击事件 collection view data sourece
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _playArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHMPalyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:playCellReuseId forIndexPath:indexPath];
    cell.playItemModel = self.playArray[indexPath.item];
    return cell;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 如果有上一个，就把上一个选为未选中
    if (_preIndexpath) {
        CHMPlayItemModel *selectedModel = self.playArray[_preIndexpath.item];
        selectedModel.isCheck = NO;
        [self.playArray replaceObjectAtIndex:_preIndexpath.item withObject:selectedModel];
    }
    
//    if (_preIndexpath.item == indexPath.row) { // 如果选中是同一个
//        _preIndexpath = indexPath;
//        [self.playCollectionView reloadItemsAtIndexPaths:@[_preIndexpath]];
//    }
    
    
    
    // 替换原来的数据
    CHMPlayItemModel *selectedModel = self.playArray[indexPath.item];
    selectedModel.isCheck = !selectedModel.isCheck;
    [self.playArray replaceObjectAtIndex:indexPath.item withObject:selectedModel];
    // 刷新数据
    if (_preIndexpath) {
        [self.playCollectionView reloadItemsAtIndexPaths:@[indexPath, _preIndexpath]];
    } else {
        [self.playCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
    
    _preIndexpath = indexPath;
}



#pragma mark - 点击事件
/**
 点击固定金额按钮

 @param sender 固定金额按钮
 */
- (IBAction)fixedMoneyButtonClick:(UIButton *)sender {
    if (_preButton) {
        [_preButton setSelected:NO];
        _preButton.layer.borderColor =  [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0].CGColor;
    }
    // 选中状态取反
    [sender setSelected:!sender.isSelected];
    sender.layer.borderColor = sender.isSelected ? [UIColor chm_colorWithHexString:KMainColor alpha:1.0].CGColor : [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0].CGColor;
    _preButton = sender;
}

/**
 点击遮罩视图

 @param sender tap 手势
 */
- (IBAction)tapMaskView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 点击确定按钮
 */
- (IBAction)comfirmButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - view life cycler
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLocalData];
    
    [self setupAppearance];
}

/**
 初始化本地数据
 */
- (void)initLocalData {
    NSArray *playItemNameArray = @[@"极大", @"极小", @"大双", @"小双", @"大单", @"小单", @"大", @"小", @"双", @"单", @"豹子", @"蓝波", @"绿波", @"红波",];
    self.playArray = [NSMutableArray array];
    for (int i = 0; i < playItemNameArray.count; i++) {
        CHMPlayItemModel *playModel = [[CHMPlayItemModel alloc] initWithPlayName:playItemNameArray[i] isCheck:NO];
        [self.playArray addObject:playModel];
    }
}

/**
 设置外观
 */
- (void)setupAppearance {
    self.navigationController.navigationBar.translucent = NO;
    
    
    // register cell
    [self.playCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMPalyCell class]) bundle:nil] forCellWithReuseIdentifier:playCellReuseId];
    
    // 每个item的大小
    self.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4.0, 41.0);
    self.flowLayout.minimumLineSpacing = 0.0;
    self.flowLayout.minimumInteritemSpacing = 0.0;
    
    _button10.layer.borderColor = [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0].CGColor;
    _button100.layer.borderColor = [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0].CGColor;
    _button500.layer.borderColor = [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0].CGColor;
    _button1000.layer.borderColor = [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0].CGColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.maskView.backgroundColor = [UIColor chm_colorWithHexString:@"#000000" alpha:0.4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
