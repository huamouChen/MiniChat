//
//  CHMSearchDataManager.h
//  MiniChat
//
//  Created by 陈华谋 on 2018/5/16.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CHMSearchType) {
    CHMSearchFriend = 0,
    CHMSearchGroup,
    CHMSearchChatHistory,
    CHMSearchAll,
};

@interface CHMSearchDataManager : NSObject

@end
