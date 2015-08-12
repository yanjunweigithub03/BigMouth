//
//  AppDelegate.h
//  News
//
//  Created by lanou3g on 15/6/30.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UIImageView *redView;

+ (AppDelegate *)shareAppDelegate;
@end

