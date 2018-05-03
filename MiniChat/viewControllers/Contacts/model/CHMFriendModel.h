//
//  CHMFriendModel.h
//  MiniChat
//
//  Created by 陈华谋 on 03/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHMFriendModel : NSObject

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *NickName;

@property (nonatomic, copy) NSString *HeaderImage;

@property (nonatomic, copy) NSString *IsOnLine;


- (instancetype)initWithUserId:(NSString *)userId nickName:(NSString *)nickName portrait:(NSString *)portrait;

@end
