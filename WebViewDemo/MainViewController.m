//
//  MainViewController.m
//  WebViewDemo
//
//  Created by Mac on 2017/8/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MainViewController.h"
#import "OldWebViewController.h"
#import "WebViewController.h"
#import "Sonic.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
}
- (IBAction)oldOpenWebView:(id)sender {
    [self.navigationController pushViewController:[OldWebViewController new] animated:YES];
}
- (IBAction)newOpenWebView:(id)sender {
    [self.navigationController pushViewController:[WebViewController new] animated:YES];
}
- (IBAction)clearCache:(id)sender {
    [[SonicClient sharedClient] clearAllCache];
}

@end
