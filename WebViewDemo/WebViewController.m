//
//  WebViewController.m
//  WebViewDemo
//
//  Created by Mac on 2017/8/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "WebViewController.h"
#import "Sonic.h"
#import "CustemSonicConnection.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@interface WebViewController ()<SonicSessionDelegate,UIWebViewDelegate> {
    WebViewJavascriptBridge *webViewJavascriptBridge;
}

@property (weak, nonatomic ) IBOutlet UIWebView *webView;
@property (nonatomic,assign) long long clickTime;

@end

@implementation WebViewController
//初始化
- (instancetype)init{
    if (self = [super init]) {
        //记录现在的时候，在页面加载完成后用此计算出打开页面的时间
        self.clickTime = (long long)([[NSDate date]timeIntervalSince1970]);
        //添加域名-地址对应关系
        [[SonicClient sharedClient] addDomain:@"localhost" withIpAddress:@"127.0.0.1"];
        //注册自己的请求连接方式
//        [SonicSession registerSonicConnection:[CustemSonicConnection class]];
        //使用sonic链接创建一个会话，在此sonic已发出请求，可以查看源码
        [[SonicClient sharedClient] createSessionWithUrl:@"http://localhost/sonic-php/sample/index.php" withWebDelegate:self];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/sonic-php/sample/index.php"]];
    [WebViewJavascriptBridge enableLogging];
    webViewJavascriptBridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    //为什么是nil 问题就出现在这里
    if ([[SonicClient sharedClient] sessionWithWebDelegate:self]) {
        [self.webView loadRequest:sonicWebRequest(request)];
    }else{
        [self.webView loadRequest:request];
    }
    __weak typeof(webViewJavascriptBridge) weakWebViewJavascriptBridge = webViewJavascriptBridge;
    //简单动态数据变化，传给前端
    [[SonicClient sharedClient] sonicUpdateDiffDataByWebDelegate:self completion:^(NSDictionary *result) {
        __strong typeof(webViewJavascriptBridge) strongWebViewJavascriptBridge = weakWebViewJavascriptBridge;
        if (result) {
            NSData *json = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
            [strongWebViewJavascriptBridge callHandler:@"getDiffDataCallback" data:jsonStr];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [webViewJavascriptBridge setWebViewDelegate:self];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [webViewJavascriptBridge setWebViewDelegate:nil];
}
- (void)dealloc {
    [[SonicClient sharedClient] removeSessionWithWebDelegate:self];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = self.title ?: [NSString stringWithFormat:@"%.2f秒\n",([NSDate new].timeIntervalSince1970 - self.clickTime)];
}
#pragma mark - Sonic Session Delegate
/*
 * sonic请求发起前回调
 */
- (void)sessionWillRequest:(SonicSession *)session{
    //可以在请求发起前同步Cookie等信息
}
/*
 * sonic要求webView重新load指定request
 */
- (void)session:(SonicSession *)session requireWebViewReload:(NSURLRequest *)request{
    [self.webView loadRequest:request];
}

@end
