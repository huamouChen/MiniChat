//
//  UIImageView+CHMImageView.m
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "UIImageView+CHMImageView.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (CHMImageView)

- (void)chm_imageViewWithURL:(NSString *)urlString placeholder:(NSString *)placeholder {
    NSString *resultString = [NSString stringWithFormat:@"%@%@", BaseURL, urlString];
//    NSString *urlPercentString = [resultString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    [self sd_setImageWithURL:[NSURL URLWithString:resultString] placeholderImage:[UIImage imageNamed:placeholder]];
}

@end
