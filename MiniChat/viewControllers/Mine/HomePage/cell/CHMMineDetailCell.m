//
//  CHMMineDetailCell.m
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMMineDetailCell.h"



@interface CHMMineDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;


@end


@implementation CHMMineDetailCell

- (void)setInfoDict:(NSDictionary *)infoDict {
    _infoDict = infoDict;
    [_headerImg chm_imageViewWithURL:infoDict[KPortrait] placeholder:@""];
    _nicknameLabel.text = [NSString stringWithFormat:@"昵称：%@", infoDict[KNickName]];
    _accountLabel.text = [NSString stringWithFormat:@"iM账号：%@",infoDict[KAccount]];
    
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
