//
//  CHMDataBaseManager.h
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/7.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHMDataBaseManager : NSObject

+ (instancetype)shareManager;

// 获取所有好友
- (NSArray *)getAllFriends;

//从表中获取所有群组信息
- (NSMutableArray *)getAllGroup;

//从表中获取所有用户信息
- (NSArray *)getAllUserInfo;

//存储群组成员信息
- (void)insertGroupMemberToDB:(NSMutableArray *)groupMemberList
                      groupId:(NSString *)groupId
                     complete:(void (^)(BOOL))result;

@end
