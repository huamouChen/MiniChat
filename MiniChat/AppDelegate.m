//
//  AppDelegate.m
//  MiniChat
//
//  Created by 陈华谋 on 29/04/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "CHMLoginController.h"
#import "CHMMainController.h"


@interface AppDelegate () <RCIMReceiveMessageDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupBarAppearance];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController) name:KSwitchRootViewController object:nil];
    
    
    NSLog(@"RongCloudAppKey-------------%@", RongCloudAppKey);
    
    // 初始化融云
    [[RCIM sharedRCIM] initWithAppKey:RongCloudAppKey];
    // 发送消息携带用户信息
//    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [self setIMInfoProvider];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    // IQKeyBoard 关闭toolBar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self switchRootViewController];
    
    return YES;
}

#pragma mark - 信息提供者
- (void)setIMInfoProvider {
    // 从沙盒中取登录时保存的用户信息
    NSString *nickName = [[NSUserDefaults standardUserDefaults] valueForKey:KNickName];
    NSString *account = [[NSUserDefaults standardUserDefaults] valueForKey:KAccount];
    NSString *portrait = [[NSUserDefaults standardUserDefaults] valueForKey:KPortrait];
    [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:account name:nickName portrait:portrait];
    
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = [CHMInfoProvider shareInstance];
    [RCIM sharedRCIM].groupInfoDataSource = CHMIMDataSourece;
    //群成员数据源
//    [RCIM sharedRCIM].groupMemberDataSource = CHMIMDataSourece;
}


- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    NSLog(@"-----------%@",message);
}



/**
 设置跟控制器
 */
- (void)switchRootViewController {
    NSString *token =  [[NSUserDefaults standardUserDefaults] valueForKey:KRongCloudToken];
    if (token) {
        
        CHMMainController *mainController = (CHMMainController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"];
        [mainController preferredStatusBarStyle];
        self.window.rootViewController = mainController;
    } else {
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:[CHMLoginController new]];
        self.window.rootViewController = navCon;
    }
}


/**
 设置 navigationBar 和 tabBar 的样式
 */
- (void)setupBarAppearance {
    // navigationBar
    [[UINavigationBar appearance] setBarTintColor:[UIColor chm_colorWithHexString:KMainColor alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // tabBar
    [[UITabBar appearance] setTintColor:[UIColor chm_colorWithHexString:KMainColor alpha:1.0]];
    
    UIImage *tmpImage = [UIImage imageNamed:@"back"];
    
    CGSize newSize = CGSizeMake(12, 20);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    [tmpImage drawInRect:CGRectMake(2, -2, newSize.width, newSize.height)];
    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
