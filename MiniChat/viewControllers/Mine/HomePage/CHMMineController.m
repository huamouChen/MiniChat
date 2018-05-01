//
//  CHMMineController.m
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMMineController.h"
#import "CHMMineDetailCell.h"
#import "CHMMineItemCell.h"

static NSString *const detailReuseablId = @"CHMMineDetailCell";
static NSString *const itemReuseablId = @"CHMMineItemCell";

@interface CHMMineController ()

@end

@implementation CHMMineController


#pragma mark - view life cycler
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
}

/**
 设置控件
 */
- (void)setupAppearance {
    // 设置尾部视图
    self.tableView.tableFooterView = [UIView new];
    
    // register cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMMineDetailCell class]) bundle:nil] forCellReuseIdentifier:detailReuseablId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CHMMineItemCell class]) bundle:nil] forCellReuseIdentifier:itemReuseablId];
    
    // auto estima height
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


#pragma mark - table view data sourece
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CHMMineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailReuseablId];
        return cell;
    }
    
    CHMMineItemCell *cell = [tableView dequeueReusableCellWithIdentifier:itemReuseablId];
    return cell;
}


#pragma mark - table view delegate



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
