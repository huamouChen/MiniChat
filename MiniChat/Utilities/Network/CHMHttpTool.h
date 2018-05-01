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

@end
