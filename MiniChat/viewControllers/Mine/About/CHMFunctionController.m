//
//  CHMFunctionController.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/9.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMFunctionController.h"

@interface CHMFunctionController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CHMFunctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能介绍";
    
    self.textView.text = @"博信，给您非一般的感觉！";
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
