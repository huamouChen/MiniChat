//
//  CHMHttpTool.m
//  MiniChat
//
//  Created by 陈华谋 on 01/05/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "CHMHttpTool.h"
#import <AFNetworking/AFNetworking.h>



@interface CHMHttpTool ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation CHMHttpTool

// 单利
static CHMHttpTool *instanse = nil;
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instanse) {
            instanse = [[CHMHttpTool alloc] init];
        }
    });
    return instanse;
}

- (instancetype)init {
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        // 设置请求以及相应的序列化
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        _sessionManager.requestSerializer.timeoutInterval = 10.0;
        // 设置响应内容的类型
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    }
    return self;
}


+ (void)requestWithMethod:(RequestMethodType)MethodType url:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure {
    // 百分比化 url
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:LoginToken];
    if (tokenString) {
        [[CHMHttpTool shareManager].sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", tokenString] forHTTPHeaderField:@"Authorization"];
    }
    
    switch (MethodType) {
        case RequestMethodTypeGet:
        {
            [[CHMHttpTool shareManager].sessionManager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        } break;
            
            
        case RequestMethodTypePost:
        {
            [[CHMHttpTool shareManager].sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
            
        } break;
            
        default:
            break;
    }
}


/**
 登录

 @param account 账号
 @param password 密码
 @param success 成功
 @param failure 失败
 */
+ (void)loginWithAccount:(NSString *)account password:(NSString *)password success:(successBlock)success failure:(failureBlock)failure {
    NSDictionary *params = @{@"Name": account, @"Pwd": password, @"RememerMe": @"false", @"loginType": @"imlogin"};
    [CHMHttpTool requestWithMethod:RequestMethodTypePost url:LoginURL params:params success:success failure:failure];
}


/**
 获取融云token

 @param success 成功
 @param failure 失败
 */
+ (void)getRongCloudTokenWithSuccess:(successBlock)success failure:(failureBlock)failure {
    [CHMHttpTool requestWithMethod:RequestMethodTypeGet url:RongTokenURL params:@{} success:success failure:failure];
}

/**
 获取用户信息
 
 @param success 成功
 @param failure 失败
 */
+ (void)getUserInfoWithSuccess:(successBlock)success failure:(failureBlock)failure {
    [CHMHttpTool requestWithMethod:RequestMethodTypeGet url:GetUserInfoURL params:@{} success:success failure:failure];
}

/**
 获取聊天室列表

 @param success 成功
 @param failure 失败
 */
+ (void)getChatRoomListsWithSuccess:(successBlock)success failure:(failureBlock)failure {
    [CHMHttpTool requestWithMethod:RequestMethodTypeGet url:GetChatRoomListURL params:@{} success:success failure:failure];
}

@end
