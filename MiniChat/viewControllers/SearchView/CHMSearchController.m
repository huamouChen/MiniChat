//
//  CHMSearchController.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/16.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMSearchController.h"
#import "CHMSearchResultModel.h"

static NSString *const reuseId = @"searchCell";

@interface CHMSearchController () <UISearchBarDelegate>
// bar 原始的颜色
@property (nonatomic, strong) UIColor *navagationBarOriginalColor;

// 搜索的结果数组
@property (nonatomic, strong) NSMutableArray *resultArray;


@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CHMSearchController

#pragma mark - view life cycler

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navagationBarOriginalColor = self.navigationController.navigationBar.barTintColor;
    [self.navigationController.navigationBar setBarTintColor:[UIColor chm_colorWithHexString:KSectionBgColor alpha:1.0]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:self.navagationBarOriginalColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.showsCancelButton = YES;
    self.searchController.searchBar.tintColor = [UIColor chm_colorWithHexString:KMainColor alpha:1.0];
    self.searchController.searchBar.delegate = self;
}



#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.resultArray = nil;
    NSArray *array = [[RCIMClient sharedRCIMClient] searchMessages:self.conversationType
                                                          targetId:self.targetId
                                                           keyword:searchText
                                                             count:50
                                                         startTime:0];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (RCMessage *message in array) {
        CHMSearchResultModel *messegeModel = [[CHMSearchResultModel alloc] init];
        messegeModel.conversationType = self.conversationType;
        messegeModel.targetId = self.targetId;
        messegeModel.otherInformation = [RCKitUtility formatMessage:message.content];
        messegeModel.time = message.sentTime;
        messegeModel.searchType = 1;
        
        if (self.conversationType == ConversationType_GROUP) {
            RCUserInfo *user = [[CHMDataBaseManager shareManager] getUserByUserId:message.senderUserId];
            messegeModel.name = user.name;
            messegeModel.portraitUri = user.portraitUri;
        } else if (self.conversationType == ConversationType_PRIVATE) {
            RCUserInfo *user = [[CHMDataBaseManager shareManager] getUserByUserId:self.targetId];
            messegeModel.name = user.name;
            messegeModel.portraitUri = user.portraitUri;
        }
        [resultArray addObject:messegeModel];
    }
    self.resultArray = resultArray;
    [self.tableView reloadData];
//    [self refreshSearchView:searchText];
    if (self.resultArray.count < 50) {
//        self.isLoading = NO;
    } else {
//        self.isLoading = YES;
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
