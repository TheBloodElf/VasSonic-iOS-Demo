//
//  AppDelegate.m
//  WebViewDemo
//
//  Created by Mac on 2017/7/17.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "Sonic.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //让Sonic接管请求请求数据流，在适当的时候返回给WebKit
    //NSURLProtocol只能拦截UIURLConnection、NSURLSession和UIWebView 中的请求，
    [NSURLProtocol registerClass:[SonicURLProtocol class]];
    UINavigationController *uINavigationController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = uINavigationController;
    [_window makeKeyAndVisible];
    return YES;
}

@end
