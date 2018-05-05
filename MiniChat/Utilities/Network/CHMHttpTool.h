//
//  CHMHttpTool.h
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethodType) {
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2
};

typedef void(^successBlock)(id response);
typedef void(^failureBlock)(NSError *error);

@interface CHMHttpTool : NSObject


/**
 单例

 @return 当前唯一实例对象
 */
+ (instancetype)shareManager;

+ (void)requestWithMethod:(RequestMethodType)MethodType
                      url:(NSString *)url
                   params:(NSDictionary *)params
                  success:(successBlock) success
                  failure:(failureBlock)failure;



/**
 登录

 @param account 账号
 @param password 密码
 @param success 成功
 @param failure 失败
 */
+ (void)loginWithAccount:(NSString *)account password:(NSString *)password success:(successBlock)success failure:(failureBlock)failure;


/**
 获取融云 token

 @param success 成功
 @param failure 失败
 */
+ (void)getRongCloudTokenWithSuccess:(successBlock)success failure:(failureBlock)failure;


/**
 获取用户信息

 @param success 成功
 @param failure 失败
 */
+ (void)getUserInfoWithSuccess:(successBlock)success failure:(failureBlock)failure;

/**
 获取聊天室列表

 @param success 成功
 @param failure 失败
 */
+ (void)getChatRoomListsWithSuccess:(successBlock)success failure:(failureBlock)failure;

/**
 获取用户关系列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)getUserRelationShipListWithSuccess:(successBlock)success failure:(failureBlock)failure;

/**
 创建群组
 
 @param groupName 群组名称
 @param groupMembers 群组成员
 @param groupPortrait 群组头像
 @param success 成功
 @param failure 失败
 */
+ (void)createGroupWtihGroupName:(NSString *)groupName groupMembers:(NSArray *)groupMembers groupPortrait:(UIImage *)groupPortrait success:(successBlock)success failure:(failureBlock)failure;


/**
 修改群组头像
 
 @param groupId 群组ID
 @param image 群组头像
 @param success 成功
 @param failure 失败
 */
+ (void)setGroupPortraitWithGroupId:(NSString *)groupId groupPortrait:(UIImage *)image success:(successBlock)success failure:(failureBlock)failure;

/**
 获取群聊列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)getGroupListWithSuccess:(successBlock)success failure:(failureBlock)failure;


/**
 把文本消息发送到服务器
 
 @param message 要发送的文本消息
 @param groupId 群组ID
 @param success 成功
 @param failure 失败
 */
+ (void)postTxtMessageToServiceWithMessage:(NSString *)message groupId:(NSString *)groupId success:(successBlock)success failure:(failureBlock)failure;
@end
