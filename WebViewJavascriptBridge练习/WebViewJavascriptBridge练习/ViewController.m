/*
 1.引入头文件
 */
#import "ViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ViewController ()<UIWebViewDelegate>
//2.声明一个属性
@property (nonatomic,strong) WebViewJavascriptBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //调用初始化方法
    [self setUpUI];
}

#pragma mark 初始化方法
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSString *html = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:html encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:html];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    // 开启日志
    [WebViewJavascriptBridge enableLogging];
    
    //3.实例化WebViewJavascriptBridge并且带上一个UIWebView
    WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [bridge setWebViewDelegate:self];
    self.bridge = bridge;
    
    [bridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {//getUserIdFromObjC
        NSLog(@"JS传递给OC的信息%@----------",data);
        if (responseCallback)
        {
            NSLog(@"OC反馈给JS的信息：%@-----",responseCallback);
        }
        
    }];
    [bridge registerHandler:@"getBlogNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {//getBlogNameFromObjC
        NSLog(@"js来OC获取博客名字-------getBlogNameFromObjC, data from js is %@", data);
        if (responseCallback)
        {
            // 反馈给JS
            responseCallback(@{@"blogName": @"标哥的技术博客"});
        }
    }];
    //4.直接调用JS端注册的HandleName
//    [bridge callHandler:@"getUserInfos" data:@{@"name": @"标哥"} responseCallback:^(id responseData) {
//        NSLog(@"from js: %@", responseData);
//    }];
//
//    [self.bridge callHandler:@"openWebviewBridgeArticle" data:nil];
    
}


@end
