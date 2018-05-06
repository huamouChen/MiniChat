//
//  HttpConstants.h
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#ifndef HttpConstants_h
#define HttpConstants_h



#define BaseURL         @"http://dfgimapi.xxx8.cn/"
//#define BaseURL         @"http://172.16.44.21:8003"

// 登录
#define LoginURL        @"api/Log/Login"
// 注册
#define RegisterURL     @"Api/Team/AddUser"

// 获取融云 token
#define RongTokenURL    @"api/Im/Token"

// 获取账号信息
#define GetUserInfoURL     @"api/User/GetUserInfo"

// 获取聊天室
#define GetChatRoomListURL  @"api/Im/ListChatroom"


// 获取用户关系列表
#define GetUserRelationshipListsURL      @"api/Im/ListFriends"

// 创建群组
#define CreateGroupURL                   @"api/Im/CreateGroup"
// 解散群组
#define DismissGroupURL                   @"api/Im/DismissGroup"
// 获取某个群组信息
#define GetGroupInfoURL                  @"api/Im/GetGroup"
// 获取群组列表
#define GetGroupListURL                  @"api/Im/ListGroups"
// 邀请加入群组
#define InviteIntoGroupURL               @"api/Im/InviteGroup"
// 离开群组
#define QuitGroupURL                     @"api/Im/QuitGroup"
// 群组踢人
#define KickGroupMemberURL               @"api/Im/KickGroup"
// 群组成员
#define GetGroupMembersURL               @"api/Im/ListGroupUsers"
//设置群组头像
#define SetGroupPortraitURL               @"api/Im/SetGroupImg"


// 发送文本消息到服务器
#define BettingMessageURL                  @"api/Lottery/BettingIm"







#endif /* HttpConstants_h */
