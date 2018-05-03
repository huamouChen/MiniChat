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

// 获取融云 token
#define RongTokenURL    @"api/Im/Token"

// 获取账号信息
#define GetUserInfoURL     @"api/User/GetUserInfo"

// 获取聊天室
#define GetChatRoomListURL  @"api/Im/ListChatroom"


// 获取用户关系列表
#define GetUserRelationshipListsURL       @"api/Im/ListFriends"








#endif /* HttpConstants_h */
