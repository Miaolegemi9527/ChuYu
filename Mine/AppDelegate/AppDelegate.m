//
//  AppDelegate.m
//  Mine
//
//  Created by 廖毅 on 15/12/14.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "AppDelegate.h"
//#import "HomeViewController2.h"
//#import "ImageSayCollViewController.h"
//#import "RadioViewController.h"
//#import "TimeViewController.h"
#import "RadioPlayViewController.h"
#import "WelcomeViewController.h"
//侧滑栏
#import "SettingViewController.h"

//锁屏界面控制电台
#import "RadioManager.h"
#import "RadioStreamer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //指定跟视图
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //全部背景统一颜色可以在这赋值
    //日夜间模式
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        self.window.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        
        
    }
    else
    {
        self.window.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    [self.window makeKeyAndVisible];

    if (![[NSUserDefaults standardUserDefaults] floatForKey:@"xx"] && ![[NSUserDefaults standardUserDefaults] floatForKey:@"ww"] && ![[NSUserDefaults standardUserDefaults] floatForKey:@"hh"]) {
        NSLog(@"xx不存在");
        //默认窄屏
        [[NSUserDefaults standardUserDefaults] setFloat:15*SCALE_X forKey:@"xx"];
        [[NSUserDefaults standardUserDefaults] setFloat:(WIDTH-30)*SCALE_X forKey:@"ww"];
        [[NSUserDefaults standardUserDefaults] setFloat:(HEIGHT-64-64)*SCALE_Y forKey:@"hh"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"]) {
        //默认日间模式
        [[NSUserDefaults standardUserDefaults] setObject:@"day" forKey:@"DAN"];
    }
    
    //隐藏顶部导航栏底部黑线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
//    HomeViewController2 *homeVC = [[HomeViewController2 alloc] init];
//    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
//    homeNC.tabBarItem.title = @"Say";
//    TimeViewController *timeVC = [[TimeViewController alloc] init];
//    UINavigationController *timeNC = [[UINavigationController alloc] initWithRootViewController:timeVC];
//    timeNC.tabBarItem.title = @"Time";
//    ImageSayCollViewController *imageSayCVC = [[ImageSayCollViewController alloc] init];
//    UINavigationController *imageSayCNC = [[UINavigationController alloc] initWithRootViewController:imageSayCVC];
//    imageSayCNC.tabBarItem.title = @"Image";
//    RadioViewController *radioVC = [[RadioViewController alloc] init];
//    UINavigationController *radioNC = [[UINavigationController alloc] initWithRootViewController:radioVC];
//    radioNC.tabBarItem.title = @"Radio";
//    //统一设置导航栏颜色和透明
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
//        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1]];
//    }
//    else
//    {
//        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:1]];
//    }
//    [[UINavigationBar appearance] setTranslucent:NO];
//    UITabBarController *tabbarController = [[UITabBarController alloc] init];
//    tabbarController.viewControllers = [NSArray arrayWithObjects:homeNC,timeNC,imageSayCNC,radioNC, nil];
//    //隐藏tabbar顶部黑线
//    [tabbarController.tabBar setBackgroundImage:[[UIImage alloc] init]];
//    [tabbarController.tabBar setShadowImage:[[UIImage alloc] init]];
//    //设置侧滑栏
//    SettingViewController *settingVC = [[SettingViewController alloc] init];
//    settingVC.view2 = tabbarController;//把tabbarController添加到View2上
//    self.window.rootViewController = settingVC;
    

//    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
//    [self.window addSubview:welcomeVC.view];
    
    
    WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
    self.window.rootViewController = welcomeVC;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //程序进入后台 申请backgroundTask 实现一个可以运行几分钟的权限
    //[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    
    //后台播放音频 让app支持接受远程控制事件 
    [application beginReceivingRemoteControlEvents];
    RadioPlayViewController *radioPVC = [[RadioPlayViewController alloc] init];
    [radioPVC becomeFirstResponder];

}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //程序进入前台
    [application endReceivingRemoteControlEvents];
    RadioPlayViewController *radioPVC = [[RadioPlayViewController alloc] init];
    [radioPVC resignFirstResponder];
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        
        if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){
            [[RadioManager shareManager] finishNotificationAction];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause){
            [[RadioStreamer shareManager] pause];
        }else if (event.subtype == UIEventSubtypeRemoteControlPlay){
            [[RadioStreamer shareManager] play];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack){
            [[RadioManager shareManager] playPreviousTrack];
        }
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
