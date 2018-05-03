//
//  CHMContactCell.h
//  MiniChat
//
//  Created by 陈华谋 on 03/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHMFriendModel;

@interface CHMContactCell : UITableViewCell
@property (nonatomic, strong) CHMFriendModel *friendModel;
@end
