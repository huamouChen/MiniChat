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


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define KTouchBarHeight 34.0f
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 弱引用、强引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


// 由角度转换弧度
#define KDegressToRadian(x)  (M_PI * x) / 180.0
// 由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / M_PI

#endif /* Constants_h */
