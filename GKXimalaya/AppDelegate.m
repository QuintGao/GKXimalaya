//
//  AppDelegate.m
//  GKXimalaya
//
//  Created by gaokun on 2019/3/29.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "AppDelegate.h"
#import "GKHomeViewController.h"
#import "UIColor+GKCategory.h"
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GKConfigure setupCustomConfigure:^(GKNavigationBarConfigure *configure) {
        configure.titleColor            = [UIColor blackColor];
        configure.titleFont             = [UIFont systemFontOfSize:18.0f];
        configure.backgroundColor       = [UIColor whiteColor];
        configure.backStyle             = GKNavigationBarBackStyleBlack;
        configure.statusBarStyle        = UIStatusBarStyleDefault;
        configure.gk_navItemLeftSpace   = 8.0f;
        configure.gk_navItemRightSpace  = 8.0f;
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [GKHomeViewController new];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
