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

- (void)closeDBForDisconnect;

#pragma mark - 用户信息
/**
 存储用户信息

 @param user 要存储的用户
 */
- (void)insertUserToDB:(RCUserInfo *)user;
/**
 存储一组用户信息

 @param userList 要存储的用户信息组
 @param result 是否成功
 */
- (void)insertUserListToDB:(NSMutableArray *)userList complete:(void (^)(BOOL))result;

#pragma mark - 好友信息
/**
 存储好友信息

 @param friendInfo 要存储的好友
 */
- (void)insertFriendToDB:(RCUserInfo *)friendInfo;

/**
 存储一组好友信息

 @param FriendList 要存储的一组好友信息
 @param result 是否成功
 */
- (void)insertFriendListToDB:(NSMutableArray *)FriendList complete:(void (^)(BOOL))result;






// 获取所有好友
- (NSArray *)getAllFriends;

//从表中获取所有群组信息
- (NSMutableArray *)getAllGroup;

//从表中获取所有用户信息
- (NSArray *)getAllUserInfo;

//从表中获取某个好友的信息
- (RCUserInfo *)getFriendInfo:(NSString *)friendId;

//存储群组成员信息
- (void)insertGroupMemberToDB:(NSMutableArray *)groupMemberList
                      groupId:(NSString *)groupId
                     complete:(void (^)(BOOL))result;

@end
