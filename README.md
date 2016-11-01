# WebViewJavascriptBridgeDemo
>**描述**

- WebViewJavascriptBridge的简单Demo

>**使用步骤**

- 1.OC端需要做的工作

```
1.首先需要pod这个框架
2.导入头文件
    #import "WebViewJavascriptBridge.h"
3.声明一个属性
    @property (nonatomic,strong) WebViewJavascriptBridge *bridge;
4.开启日志
    [WebViewJavascriptBridge enableLogging];
5.创建一个webView，并在此基础上实例化WebViewJavascriptBridge并且带上一个webView，如果需要使用代理方法的话就设置代理
    WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [bridge setWebViewDelegate:self];
    self.bridge = bridge;
6.下面的两步，就是注册供JS调用和调用JS的方法了。（JS里面也有类似的操作）
    1.注册供JS调用的方法，JS里面通过callHandler来调用，
      data是JS调用时所传的参数，OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
      [bridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {//getUserIdFromObjC
        NSLog(@"OC收到JS的信息%@----------",data);
        if (responseCallback)
        {
             // 反馈给JS         responseCallback(@{@"blogName": @"标哥的技术博客"});
        }
    }];
    2.调用JS的方法，前提是JS里面也注册了对应的方法才能调用
      data是传递给JS的参数，responseData是JS回调传过来的数据
        [bridge callHandler:@"getUserInfos" data:@{@"name": @"标哥"} responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
        }];
```

- 2.JS端需要做的工作

```
1.需要计入一段固定的代码
    /*这段代码是固定的，必须要放到js中*/
    function setupWebViewJavascriptBridge(callback) {
             if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
             if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
             window.WVJBCallbacks = [callback];
             var WVJBIframe = document.createElement('iframe');
             WVJBIframe.style.display = 'none';
             WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
             document.documentElement.appendChild(WVJBIframe);
             setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
           }
2.在下面的方法里面写相关的JS代码
  与OC交互的所有JS方法都要放在此处注册，才能调用通过JS调用OC或者让OC调用这里的JS
     setupWebViewJavascriptBridge(function(bridge) {
         /* Initialize your app here */
         所有与iOS交互的JS代码放这里！
     })
3.上面的方法中JS里面的注册和调用的写法
     1.JS注册供OC调用的方法，OC通过 bridge callHandler来调用
     data是OC调用时传过来的参数，responseCallback毁掉给OC的数据
         bridge.registerHandler('getUserInfos', function(data, responseCallback) {
                  log("Get user information from ObjC: ", data)
                  responseCallback({'userId': '123456', 'blog': '标哥的技术博客'})
                })
     2.JS调用OC的方法。下面的第一个没有参数，第二个有参数，参数是传递给OC的，responseData是OC回调传过来的数据
         bridge.callHandler('getUserIdFromObjC', function(responseData) {
                  log("JS call ObjC's getUserIdFromObjC function, and js received response:", responseData)
                })
         bridge.callHandler('getBlogNameFromObjC', {'blogURL': 'http://www.henishuo.com'}, function(response) {
                                   log('JS got response', response)
                                   })
       }
```


