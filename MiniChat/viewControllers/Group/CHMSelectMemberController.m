//
//  CHMSelectMemberController.m
//  MiniChat
//
//  Created by 陈华谋 on 04/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMSelectMemberController.h"

@interface CHMSelectMemberController ()

@end

@implementation CHMSelectMemberController

#pragma mark - view life cycler
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
}


/**
 设置外观
 */
- (void)setupAppearance {
    self.title = @"选择群组成员";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
