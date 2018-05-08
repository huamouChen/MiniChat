//
//  RCDAddressBookTableViewCell.h
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCUserInfo;


typedef void(^AcceptButtonClickBlock)(NSIndexPath *selectedIndexPath);

@interface RCDAddressBookTableViewCell : UITableViewCell

/**
 *  cell高度
 *
 */
+ (CGFloat)cellHeight;

/**
 *  设置模型
 *
 *  @param user 设置用户信息模型，填充控件的数据
 */
- (void)setModel:(RCUserInfo *)user;

/**
 *  昵称
 */
@property(nonatomic, strong) UILabel *nameLabel;

/**
 *  头像
 */
@property(nonatomic, strong) UIImageView *portraitImageView;

/**
 *  “已接受”、“已邀请”
 */
@property(nonatomic, strong) UILabel *rightLabel;

/**
 *  右箭头
 */
@property(nonatomic, strong) UIImageView *arrow;

/**
 *  “接受”按钮
 */
@property(nonatomic, strong) UIButton *acceptBtn;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, copy) AcceptButtonClickBlock acceptButtonClickBlock;


@end
