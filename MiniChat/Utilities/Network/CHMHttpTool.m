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

// 单例
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
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"charset=utf-8", nil];
    }
    return self;
}


+ (void)requestWithMethod:(RequestMethodType)MethodType url:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure {
    // 百分比化 url
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:KLoginToken];
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
 上传图片
 
 @param urlString 上传地址
 @param params 参数
 @param image 图片
 @param imageName 图片名称
 @param success 成功
 @param failure 失败
 */
+ (void)postWithURLString:(NSString *)urlString params:(NSDictionary *)params image:(UIImage *)image imageName:(NSString *)imageName success:(successBlock)success failure:(failureBlock)failure {
    NSData *data = UIImageJPEGRepresentation(image, 0.2);
    
    
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:KLoginToken];
    if (tokenString) {
        [[CHMHttpTool shareManager].sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", tokenString] forHTTPHeaderField:@"Authorization"];
    }
    
    [[CHMHttpTool shareManager].sessionManager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:imageName fileName:@"file" mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {}
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                NSLog(@"上传文件---%@",responseObject);
                                                NSString *desc = responseObject[@"type"];
                                                if ([desc isEqualToString:@"SUCCESS"]) {
                                                    success(responseObject);
                                                }else{
                                                    failure(responseObject[@"desc"]);
                                                }
                                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                failure(error);
                                            }];
    
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


/**
 获取用户关系列表
 
 @param success 成功
 @param failure 失败
 */
+ (void)getUserRelationShipListWithSuccess:(successBlock)success failure:(failureBlock)failure {
    [CHMHttpTool requestWithMethod:RequestMethodTypeGet url:GetUserRelationshipListsURL params:@{} success:success failure:failure];
}


/**
 创建群组
 
 @param groupName 群组名称
 @param groupMembers 群组成员
 @param groupPortrait 群组头像
 @param success 成功
 @param failure 失败
 */
+ (void)createGroupWtihGroupName:(NSString *)groupName groupMembers:(NSArray *)groupMembers groupPortrait:(UIImage *)groupPortrait success:(successBlock)success failure:(failureBlock)failure {
    // 参数
    NSString *groupOwner = [[NSUserDefaults standardUserDefaults] valueForKey:KAccount];
    NSString *imgDataString = [UIImageJPEGRepresentation(groupPortrait, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *params = @{@"Owner": groupOwner, @"GroupName": groupName, @"GroupImgStream": imgDataString, @"Members":groupMembers };
    [CHMHttpTool requestWithMethod:RequestMethodTypePost url:CreateGroupURL params:params success:success failure:failure];
}


/**
 修改群组头像

 @param groupId 群组ID
 @param image 群组头像
 @param success 成功
 @param failure 失败
 */
+ (void)setGroupPortraitWithGroupId:(NSString *)groupId groupPortrait:(UIImage *)image success:(successBlock)success failure:(failureBlock)failure {
    
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:KLoginToken];
    if (tokenString) {
        [[CHMHttpTool shareManager].sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", tokenString] forHTTPHeaderField:@"Authorization"];
    }
    
    // 参数
    NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
    NSDictionary *params = @{@"GroupId": groupId, @"GroupImgStream": imgData};
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
//    [CHMHttpTool requestWithMethod:RequestMethodTypePost url:SetGroupPortraitURL params:params success:success failure:failure];
    
    [[CHMHttpTool shareManager].sessionManager POST:SetGroupPortraitURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"GroupImgStream" fileName:@"file" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--------%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--------%@",error);
    }];
}


/**
 把文本消息发送到服务器

 @param message 要发送的文本消息
 @param groupId 群组ID
 @param success 成功
 @param failure 失败
 */
+ (void)postTxtMessageToServiceWithMessage:(NSString *)message groupId:(NSString *)groupId success:(successBlock)success failure:(failureBlock)failure {
    NSDictionary *params = @{@"BettingMsg": message, @"GroupId": groupId};
    [CHMHttpTool requestWithMethod:RequestMethodTypePost url:BettingMessageURL params:params success:success failure:false];
}

@end
