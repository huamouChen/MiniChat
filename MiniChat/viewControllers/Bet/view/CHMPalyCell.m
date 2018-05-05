//
//  CHMPalyCell.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/4.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMPalyCell.h"
#import "CHMPlayItemModel.h"

@interface CHMPalyCell ()
@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@end

@implementation CHMPalyCell


- (void)setPlayItemModel:(CHMPlayItemModel *)playItemModel {
    _playItemModel = playItemModel;
    _itemButton.titleLabel.text = _playItemModel.playName;
    NSLog(@"-----%@",_itemButton.titleLabel.text);
    [_itemButton setSelected:_playItemModel.isCheck];
    _itemButton.layer.borderColor = _playItemModel.isCheck ? [UIColor chm_colorWithHexString:KMainColor alpha:1.0].CGColor : [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0].CGColor;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self bringSubviewToFront:self.itemButton];
    
    _itemButton.layer.masksToBounds = YES;
    _itemButton.layer.cornerRadius = 5;
    _itemButton.layer.borderColor = [UIColor chm_colorWithHexString:KSeparatorColor alpha:1.0].CGColor;
    _itemButton.layer.borderWidth = 0.5;
    _itemButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _itemButton.titleLabel.textColor = [UIColor chm_colorWithHexString:KColor6 alpha:1.0];
    
}

@end
