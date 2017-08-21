//
//  OldWebViewController.m
//  WebViewDemo
//
//  Created by Mac on 2017/8/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OldWebViewController.h"

@interface OldWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,assign)long long clickTime;

@end

@implementation OldWebViewController
/*
 * 在初始化ViewController的时候发起sonic的请求
 */
- (instancetype)init{
    if (self = [super init]) {
         self.clickTime = (long long)([[NSDate date]timeIntervalSince1970]);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/sonic-php/sample/index.php"]];
    [self.webView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = self.title ?: [NSString stringWithFormat:@"%.2f秒\n",([NSDate new].timeIntervalSince1970 - self.clickTime)];
}

@end
