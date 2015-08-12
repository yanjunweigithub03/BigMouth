//
//  AppDelegate.m
//  News
//
//  Created by lanou3g on 15/6/30.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "MineViewController.h"
#import "ReadTVC.h"
#import "VideoTVC.h"
#import "UMSocial.h"
@interface AppDelegate ()

@end

static AppDelegate *_appDelegate;
@implementation AppDelegate

-(void)dealloc
{
    [_redView release];
    [_window release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor grayColor];
    [self.window makeKeyAndVisible];

    _appDelegate = self;
    _redView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _redView.backgroundColor = [UIColor blackColor];
    _redView.alpha = 0.0;
    
    [UMSocialData setAppKey:@"55af41e367e58e609b000a9b"];
    
    // 新闻 主界面
    RootViewController *root = [[RootViewController alloc] init];
    root.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:root];
    root.navigationItem.title = @"世间风云";
    [NC.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav-Bar"] forBarMetrics:(UIBarMetricsDefault)];

    //状态栏
    UIImageView *statueView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - 20, [UIScreen mainScreen].bounds.size.width, 20)];
    statueView.image = [UIImage imageNamed:@"statue"];
    //statueView.contentMode = UIViewContentModeScaleAspectFit;
    [NC.navigationBar addSubview:statueView];
    
    root.tabBarItem.title = @"新闻";
    root.tabBarItem.image = [UIImage imageNamed:@"iconfont-xinwen.png"];
    
    // 阅读 界面
    ReadTVC *read = [[ReadTVC alloc] init];
    read.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *readNC = [[UINavigationController alloc] initWithRootViewController:read];
    [readNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav-Bar"] forBarMetrics:(UIBarMetricsDefault)];
    
    UIImageView *statueView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, - 20, [UIScreen mainScreen].bounds.size.width, 20)];
    statueView2.image = [UIImage imageNamed:@"statue"];
    [readNC.navigationBar addSubview:statueView2];
    
    read.navigationItem.title = @"阅读";
    read.tabBarItem.title = @"阅读";
    read.tabBarItem.image = [UIImage imageNamed:@"iconfont-yuedu"];
    
    // 视频 界面
    VideoTVC *video = [[VideoTVC alloc] init];
    video.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *videoNC = [[UINavigationController alloc] initWithRootViewController:video];
    [videoNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav-Bar"] forBarMetrics:(UIBarMetricsDefault)];
    
    UIImageView *statueView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, - 20, [UIScreen mainScreen].bounds.size.width, 20)];
    statueView3.image = [UIImage imageNamed:@"statue"];
    [videoNC.navigationBar addSubview:statueView3];
    
    video.navigationItem.title = @"视频";
    video.tabBarItem.title = @"视频";
    video.tabBarItem.image = [UIImage imageNamed:@"iconfont-shipin.png"];
    
    // 设置 - （我的） - 界面
    MineViewController *mine = [[MineViewController alloc] init];
    mine.view.backgroundColor = [UIColor grayColor];
    UINavigationController *mineNC = [[UINavigationController alloc] initWithRootViewController:mine];
    [mineNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav-Bar"] forBarMetrics:(UIBarMetricsDefault)];
    
    //状态栏
    UIImageView *statueView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, - 20, [UIScreen mainScreen].bounds.size.width, 20)];
    statueView1.image = [UIImage imageNamed:@"statue"];
    [mineNC.navigationBar addSubview:statueView1];
    
    mine.navigationItem.title = @"设置";
    mine.tabBarItem.title = @"我的";
    mine.tabBarItem.image = [UIImage imageNamed:@"iconfont-wode.png"];
    
    UITabBarController *rootTB = [[UITabBarController alloc] init];
    rootTB.tabBar.backgroundImage = [UIImage imageNamed:@"Tab-Bar"];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [rootTB.tabBarItem setTitleTextAttributes:textAttrs forState:(UIControlStateNormal)];
    rootTB.tabBar.tintColor = [UIColor redColor];
    rootTB.viewControllers = @[NC,readNC,videoNC,mineNC];
    self.window.rootViewController = rootTB;
    
    [self.window addSubview:_redView];
    
    
    
    
    [_redView release];
    [rootTB release];
    [mineNC release];
    [mine release];
    [videoNC release];
    [video release];
    [readNC release];
    [read release];
    [statueView release];
    [statueView1 release];
    [statueView2 release];
    [statueView3 release];
    [NC release];
    [root release];
    [_window release];
    return YES;
}

+ (AppDelegate *)shareAppDelegate
{
    return _appDelegate;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
