//
//  CHMSelectMemberCell.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/4.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMSelectMemberCell.h"
#import "CHMFriendModel.h"


@interface CHMSelectMemberCell ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end


@implementation CHMSelectMemberCell

- (void)setFriendModel:(CHMFriendModel *)friendModel {
    _friendModel = friendModel;
    [_portraitImg chm_imageViewWithURL:_friendModel.HeaderImage placeholder:@""];
    _nameLabel.text = _friendModel.NickName;
    [_checkButton setSelected:_friendModel.isCheck];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
