//
//  Constants.h
//  MiniChat
//
//  Created by 陈华谋 on 29/04/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


// 融云 AppKey
#define RongCloudAppKey   @"cpj2xarlc74vn"
// 融云调试token
#define RongCloudTestToken      @"zEbrjwwUm+EDZcrWU8kj+JFo+JgPj1M/zSlaPtimCR62bPZKSfTJHCW4V1Sqi2jUAWzI9UB2Ql1s5F6tgEscEQ=="


#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif


#define KTouchBarHeight 34.0f
#define KIphoneXHeight 2436.0f
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)  


#endif /* Constants_h */
