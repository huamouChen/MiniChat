//
//  CHMInfoProvider.h
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/6.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import <Foundation/Foundation.h>


#define CHMIMDataSourece [CHMInfoProvider shareInstance];

@interface CHMInfoProvider : NSObject


+ (instancetype)shareInstance;

@end
