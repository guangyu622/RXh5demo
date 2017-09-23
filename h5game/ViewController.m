//
//  ViewController.m
//  h5game
//
//  Created by 光宇 on 2017/6/19.
//  Copyright © 2017年 光宇. All rights reserved.
//

#import "ViewController.h"
#import "HLparameter.h"
#import <AdSupport/AdSupport.h>
#import "HLparameter.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "RSAEncryptor.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "IPAddress.h"

NSString *a = @"a";
NSString *b = @"l";
NSString *c = @"i";
NSString *d = @"p";
NSString *e = @"a";
NSString *f = @"y";
NSString *g = @":";
NSString *h = @"/";
NSString *i = @"/";
NSString *j = @"s";
NSString *k = @"l";
NSString *l = @"i";
NSString *m = @"p";
NSString *n = @"a";
NSString *o = @"y";
NSString *p = @"c";
NSString *q = @"l";
NSString *r = @"i";
NSString *s = @"e";
NSString *t = @"n";
NSString *u = @"t";
NSString *v = @"s";

NSString *a1 = @"w";
NSString *a2 = @"e";
NSString *a3 = @"i";
NSString *a4 = @"x";
NSString *a5 = @"i";
NSString *a6 = @"n";
NSString *a7 = @":";
NSString *a8 = @"/";
NSString *a9 = @"/";
NSString *a10 = @"w";
NSString *a11 = @"a";
NSString *a12 = @"p";
NSString *a13 = @"/";
NSString *a14 = @"p";
NSString *a15 = @"a";
NSString *a16 = @"y";
NSString *a17 = @"?";
char *add;
int static cpp = 1;
NSString *gamecode;
#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height


@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>


@property (nonatomic,strong) WKWebView *gameView;

@end


@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self sendidfa];
    [self showgame];
    
      }


-(void)showgame{
    
    [self getIPAddress];

    NSString *idfaString = [self getSaveAdIDFromKeyChain];
    
    //使用.der和.p12中的公钥私钥加密解密
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
//    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    
    NSString *encryptStr = [RSAEncryptor encryptString:idfaString publicKeyWithContentsOfFile:public_key_path];
//    NSLog(@"加密前:%@", idfaString);
//    NSLog(@"加密后:%@", encryptStr);
//    NSLog(@"解密后:%@", [RSAEncryptor decryptString:encryptStr privateKeyWithContentsOfFile:private_key_path password:@"123"]);
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //    不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
//    encryptStr
    //     Do any additional setup after loading the view, typically from a nib.?uuid=%@
    
    _gameView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,screenWidth,   screenHeight)];
        _gameView.navigationDelegate = self;
    
    NSString *gameuuidString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)encryptStr,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    if (add == nil){
        gamecode = [NSString stringWithFormat:@"%@?pkg=ios1.0&uuid=%@",HL_GAMEENTRANCE_SERVER_URL,gameuuidString];
    }else{
        gamecode = [NSString stringWithFormat:@"%@?pkg=ios1.0&uuid=%@&ip=%s",HL_GAMEENTRANCE_SERVER_URL,gameuuidString,add];
    }
    
    NSLog(@"%@", gamecode);
    NSMutableURLRequest *gamerequest =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:gamecode]];
    gamerequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                            diskCapacity:200 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [self.view addSubview: _gameView];
    _gameView.scrollView.bounces =NO;
    _gameView.opaque = NO;
    _gameView.backgroundColor = [UIColor clearColor];
    _gameView.scrollView.scrollEnabled = false ;
    self.gameView.scrollView.delegate = self;   
    [_gameView loadRequest:gamerequest];
}



- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSMutableDictionary *mutableUserInfo = [[cachedResponse userInfo] mutableCopy];
    NSMutableData *mutableData = [[cachedResponse data] mutableCopy];
    NSURLCacheStoragePolicy storagePolicy = NSURLCacheStorageAllowedInMemoryOnly;
    
    // ...
    
    return [[NSCachedURLResponse alloc] initWithResponse:[cachedResponse response]
                                                    data:mutableData
                                                userInfo:mutableUserInfo
                                           storagePolicy:storagePolicy];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"webview开始收到响应");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)sendidfa{

    NSString *idfaString = [self getSaveAdIDFromKeyChain];
    
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
//    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    
    NSString *encryptStr = [RSAEncryptor encryptString:idfaString publicKeyWithContentsOfFile:public_key_path];
//    NSLog(@"加密前:%@", idfaString);
//    NSLog(@"加密后:%@", encryptStr);
//    NSLog(@"解密后:%@", [RSAEncryptor decryptString:encryptStr privateKeyWithContentsOfFile:private_key_path password:@"123"]);
    
    NSString *strKey = [NSString stringWithFormat:@"%@%@", HF_INSTALLACTIVEFLAG, APPID];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *value = [userDef objectForKey:strKey];
  
    //
//        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    
        long timet = time;
        NSString *stime =  [NSString stringWithFormat:@"%ld\n",timet];   //NSTimeInterval返回的是double类型
        NSString *appkey = @"NmuTSeLXHiTjg18fEk@jj3!n#bNP#guE";
        NSString *md5str= [appkey stringByAppendingString:stime];
        NSString *sign = [self md5:md5str];//MD5加密后的字符串
    if ([value isEqualToString:@"1"]) {
        NSLog(@"不发");
        return;
    }else {
        [userDef setObject:@"1" forKey:strKey];
        [userDef synchronize];
        NSLog(@"%@", idfaString);
        NSLog(@"发送");
        NSString *uuidstring = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)encryptStr,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));
            // 1.设置请求路径
            NSURL *url=[NSURL URLWithString:HF_INSTALLSTATISTIC_SERVER_URL];
            //不需要传递参数
            //    2.创建请求对象
           NSMutableURLRequest *tongjirequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [tongjirequest setHTTPMethod:@"POST"];
             //设置请求体
             NSString *param=[NSString stringWithFormat:@"appid=%@&os=%@&time=%@&sign=%@&uuid=%@&do=%@",@"2",@"ios",stime,sign,uuidstring,@"active"];
             //把拼接后的字符串转换为data，设置请求体
            NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", param);
            [tongjirequest setHTTPBody:data];
           NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:tongjirequest delegate:self];
        [connection start];
    }
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    _gameView.scrollView.frame =  CGRectMake(0, 0,screenWidth,screenHeight+10);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

#pragma mark- WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:[[[[[[[[a1 stringByAppendingString:a2]stringByAppendingString:a3 ]stringByAppendingString:a4]stringByAppendingString:a5]stringByAppendingString:a6]stringByAppendingString:a7]stringByAppendingString:a8]stringByAppendingString:a9]] || [navigationAction.request.URL.absoluteString hasPrefix:[[[[[[[[[a stringByAppendingString:b]stringByAppendingString:c]stringByAppendingString:d]stringByAppendingString:e]stringByAppendingString:f]stringByAppendingString:g]stringByAppendingString:h]stringByAppendingString:i]stringByAppendingString:j]] || [navigationAction.request.URL.absoluteString hasPrefix:[[[[[[[[a stringByAppendingString:b]stringByAppendingString:c]stringByAppendingString:d]stringByAppendingString:e]stringByAppendingString:f]stringByAppendingString:g]stringByAppendingString:h]stringByAppendingString:i]]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            if (iOS10) {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                }];
            } else {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            }
        }
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
        _Loading = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)];
        [_Loading setTag:108];
        [_Loading setBackgroundColor:[UIColor blackColor]];
        [_Loading setAlpha:0.5];
        [self.view addSubview:_Loading ];
        NSLog(@"webViewDidStartLoad");
    
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [activityIndicator setCenter:_Loading.center];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_Loading  addSubview:activityIndicator];
        [activityIndicator startAnimating];

}

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持的旋转方向
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


//当内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    if (cpp== 2){
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    }else {
        return;
    }
}

//页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    if (cpp == 1){
        [activityIndicator stopAnimating];
        UIView *view = (UIView*)[self.view viewWithTag:108];
        view.alpha = 0;
        [view removeFromSuperview];
        _Loading.hidden =YES;
        //    _gameView.navigationDelegate = self;
        cpp = 2;
    }else{
        [activityIndicator stopAnimating];
        UIView *view = (UIView*)[self.view viewWithTag:108];
        view.alpha = 0;
        [view removeFromSuperview];
        _Loading.hidden =YES;
        //    _gameView.navigationDelegate = self;
    }
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    UIAlertView *reg_alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络不给力哦~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [reg_alert show];
    NSLog(@"didFail");
}



- (NSString *)getSaveAdIDFromKeyChain{
    //读取保存到钥匙串中的广告id
  NSString  *strAdID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        //保存创建的广告id
    
    return strAdID;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {//点击按钮的，根据下标确定点了哪一个按钮
    if (buttonIndex == 0) {//点击取消按钮
        [self showgame];
    }
}

- (void)exitApplication {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:0.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}

//获取IP地址
- (void)getIPAddress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        static unsigned long localHost = 0x7F000001;            // 127.0.0.1
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
        NSLog(@"Name: %s MAC: %s IP: %s\n", if_names[i], hw_addrs[i], ip_names[i]);
    }
        if (ip_names[2]!= nil){
            add = ip_names[1];
        }else{
            if (ip_names[1]!=nil){
            if (strlen(if_names[1])  == 7){
                add = ip_names[1];
            }else{
                add = nil;
            }
            }else{
                add = nil;
            }
        }
    NSLog(@"IP ======== %s", add);
    }

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


@end
