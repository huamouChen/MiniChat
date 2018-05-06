//
//  CHMInfoProvider.m
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/6.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMInfoProvider.h"

@implementation CHMInfoProvider

+ (instancetype)shareInstance {
    static CHMInfoProvider *infoProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!infoProvider) {
            infoProvider = [[CHMInfoProvider alloc] init];
        }
    });
    return infoProvider;
}

@end
