//
//  CHMSearchController.h
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/16.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMSearchController : UITableViewController

@property (nonatomic, assign) RCConversationType conversationType;

@property (nonatomic, strong) NSString *targetId;

@end
