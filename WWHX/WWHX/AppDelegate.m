//
//  AppDelegate.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/28.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "AppDelegate.h"
#import "WWContactsTableViewController.h"

@interface AppDelegate ()<EMClientDelegate,EMContactManagerDelegate,EMChatManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1162161224115224#chatdemo"];
    
    options.apnsCertName = nil;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (isAutoLogin) {
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [mainSB instantiateViewControllerWithIdentifier:@"WWTabBar"];
        
        self.window.rootViewController = tabBarController;
        
        
    }
    
    
    //添加回调监听代理:
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    
    //设置添加好友的操作
    
    //设置代理
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //移除好友回调
    //    [[EMClient sharedClient].contactManager removeDelegate:self];
    
    //消息回调:EMChatManagerDelegate
    
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    
    return YES;
}




// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


#pragma mark - EMContactManagerDelegate
/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
//- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
//                                       message:(NSString *)aMessage;

//上边的方法过期了
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加好友请求" message:[NSString stringWithFormat:@"收到来自%@的好友请求，附加信息%@",aUsername,aMessage] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!error) {
            NSLog(@"发送同意成功");
            
            //同意加别人为好友的时候需要刷新联系人列表
            UITabBarController *tabBarC = self.window.rootViewController;
            
            WWContactsTableViewController *contactTVC = tabBarC.childViewControllers[1].childViewControllers[0];
            
            //WWAnnotation:在这里只能是通过这种方式才能够刷新数据
            [contactTVC getUserFromServer];
        }
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error2 = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!error2) {
            NSLog(@"发送拒绝成功");
        }
        
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    
}



/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
//- (void)didReceiveAgreedFromUsername:(NSString *)aUsername;
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"好友通知" message:[NSString stringWithFormat:@"%@已经成为您的好友",aUsername] preferredStyle:UIAlertControllerStyleAlert];
    
    [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
    
    //刷新联系人列表
    UITabBarController *tabBarC = self.window.rootViewController;
    
    WWContactsTableViewController *contactTVC = tabBarC.childViewControllers[1].childViewControllers[0];
    
    //WWAnnotation:在这里只能是通过这种方式才能够刷新数据
    [contactTVC getUserFromServer];
    
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertC dismissViewControllerAnimated:YES completion:nil];
        
    });
    
    
    
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
//- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername;
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"好友通知" message:[NSString stringWithFormat:@"%@拒绝了您的好友请求",aUsername] preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertC dismissViewControllerAnimated:YES completion:nil];
    });
    
    
}

#pragma mark - 用户B删除与用户A的好友关系后，用户A，B会收到这个回调
- (void)friendshipDidRemoveByUser:(NSString *)aUsername{
    
    UITabBarController *tabBarC = self.window.rootViewController.childViewControllers[1];
    WWContactsTableViewController *contactTVC = tabBarC.childViewControllers[0];
    [contactTVC getUserFromServer];
    
}


- (void)messagesDidReceive:(NSArray *)aMessages{
    
    NSLog(@"接收到消息");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"WWHXDidReceiveMessageNote" object:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"WWHXDidSendMessageNote" object:nil];
}


/*!
 *  自动登录返回结果
 *
 *  @param aError 错误信息
 */
//- (void)didAutoLoginWithError:(EMError *)aError;
- (void)autoLoginDidCompleteWithError:(EMError *)aError{
    if(aError == nil){
        NSLog(@"自动登录成功");
    }
}

#pragma mark - EMClientDelegate
/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *  wz：貌似当进行账号切换的时候也会调用这个方法
 *  @param aConnectionState 当前状态
 */
//- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState;
//WWAnnotation:上边的方法过期了，使用下边的方法代替
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState{
    NSLog(@"连接状态发生变化");
    
}



@end
