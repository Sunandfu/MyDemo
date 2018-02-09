# JS-OC
JS代码和OC代码的交互小案例


以下为个人愚见, 如有不妥,望大家斧正!!!
本文的GitHub源码下载地址:
https://github.com/DXSmile/JS-OC.git

如需转载,请注明转载自DXSmile的
GitHub项目https://github.com/DXSmile/JS-OC.git

###简述:
随着应用开发技术的日渐更新迭代, 特别是HTML5出来之后, 现在很多的移动端应用开发也越来越趋向于使用HTML5的技术来设计和完成相对复杂的UI页面设计和交互, 就像之前我又一篇文章写的一样, 
HTML5很可能就是下一个技术的焦点, 很多的语言,平台,都将会更加兼容HTML5技术,企业也将会越来越多的使用HTML5, 那么作为一名iOS移动开发攻城狮来说, 我们就需要不断的学习成长,尽快弄精通HTML5和OC,和swift的交互,从而来实现更多更新的技术;
前文链接如下:
[你不得不了解,甚至立马学习的HTML5](http://www.jianshu.com/p/18cc5847ad68)

今天我就来和大家简单的说一下HTML5中,JS代码和OC代码的交互, 由于时间关系,我这里只做简单的描述,具体深入的交互,需要大家后面不断的练习;

###JS和OC的交互方式简单来说有两种情况:
#### 交互前提: 在OC端使用webView!!!
####1.OC调用JS - OC执行JS代码
步骤1> 显示页面,其实就是加载请求 : 
            使用 [self.webView loadRequest:request];
       并且让控制器成为webView的代理, 监听网页加载完毕 :  使用<UIWebViewDelegate>的代理方法:
```
/**
 *  网页加载完毕
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView { }
 ```
步骤2> 让页面调用OC中的脚本,它属于webView的一个方法,特别提醒 : 执行JS脚本代码仅仅只有这一种方法:
```
       [webView stringByEvaluatingJavaScriptFromString:@“JS代码”];
 ```

举例 一:
```
/**
 *  网页加载完毕
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"document.getElementsByTagName('footer')[0].remove();";
    [webView stringByEvaluatingJavaScriptFromString:js];
}
```
举例 二: 
```
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *JS代码 = @"function login (username, pwd) {  "
                    "   return 10;"
                    "       }"
                    "   login();";
   //     在OC中调用JS的函数（执行JS代码）
   [webView stringByEvaluatingJavaScriptFromString:@“JS代码”];
}
 ```
####2. JS调用OC - 就是JS调用OC中的方法
步骤1> 需自定义href协议,可以指定方法名和参数 : 然后将OC方法和参数值拼接在一个URL中
如下: 自定义href协议
```
  NSString *onload = @"this.onclick = function() {"
       1> 打电话方法,有参数    "window.location.href = 'dx:call:&10086'"
       2> 发信息方法,有参数    "window.location.href = 'dx:sendMsg:&10010'"
       3> 关机方法,无参数      "window.location.href = 'dx:shutdown'"
                                "};";
[imgHtml appendFormat:@"<img onload=\"%@\" width=\"%d\" height=\"%d\" src=\"%@\"><div>",onload,width , height, img.src];
 ```
将OC方法和参数值拼接在一个URL中:
```
/*  通用url的设计
    1> 找一个固定的协议: 如  dx:
    2> 一般有2个参数   2.1> 方法名  2.2> 方法参数
*/
      window.location.href = 'dx:saveImageToAblum:&' + this.src
```
步骤2> 使用<UIWebViewDelegate>代理协议中的方法拦截请求 :  每次发送请求之前系统会自动调用该代理方法:
```
/**
    调用 : 每当webView发送一个请求之前都会先调用这个方法
参数说明:
    request : 即将发送的请求
    BOOL : Yes : 允许发送这个请求  No : 禁止发送这个请求
    navigationType : 是否在新窗口中打开
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//        a) 在这个代理方法中拦截JS请求的URL
//        b) 从URL中截取相应的方法名和参数
//        c) 调用方法，传递参数
 
      return YES/NO;
}
```

##### 小结: 通常情况来说, JS和OC的交互,就是上面两种情况, 理清思路,就可以很好的做好交互了;接下来就是需要写代码了;
下面我附上一份我自己写的代码: 

```
#pragma mark - 发送get请求 获取数据
/** 发送get请求,获取新闻的详情 */
- (void)getUpData {
    // 测试地址: http://c.m.163.com/nc/article/{docid}/full.html  
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", self.headline.docid];
    
    [[DXHTTPManager manager] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        [responseObject writeToFile:@"/Users/xiongdexi/Desktop/Data/newsDetail.plist" atomically:YES];
       
        // 根据对应的docid赋值
        self.detailNews = [DXDetail detailWithDict:responseObject[self.headline.docid]];
        
        // 显示到webView上
        [self showDetailForWebView];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"加载出错, %@", error);
    }];
    
}
```
接下来需要拼接html代码:
```
#pragma mark - 拼接html,显示数据到webView上
 /** 显示到webView上 */
- (void)showDetailForWebView {
    // 1.初始化一个可变字符串
    NSMutableString *html = [NSMutableString string];
    // 2.拼接html代码
    [html appendString:@"<html>"];
    // 2.1 头部内容
    [html appendString:@"<head>"];
    
    // 引入css文件
    NSURL *path = [[NSBundle mainBundle]URLForResource:@"DXDetail.css" withExtension:nil];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">", path];

    [html appendString:@"</head>"];
    
    // 2.2 具体内容
    [html appendString:@"<body>"];
    
    // 将图片插入插入body对应的标记中
    [html appendString:[self setupBody]];
    
    [html appendString:@"</body>"];
    
    // 2.3 尾部内容
    [html appendString:@"</html>"];
    
    // 3. 显示网页
    [self.webView loadHTMLString:html baseURL:nil];
    
}

/** 拼接body的内容  (也就是初始化body内容) */
- (NSString *)setupBody {
    
    NSMutableString *bodyM = [NSMutableString string];
    
    
    // 拼接标题
    [bodyM appendFormat:@"<div class=\"title\">%@</div>", self.detailNews.title];
    
    // 拼接时间
    [bodyM appendFormat:@"<div class=\"time\">%@</div>",self.detailNews.ptime];
    
    // 拼接图片  img.ref ==  <!--IMG#0-->  <!--IMG#0--> --> <img src=img.src>
    [bodyM appendString:self.detailNews.body];
    
    for (DXDetailImg *img in self.detailNews.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 定义图片的宽高比 550*344  用下面的方法切割尺寸字符串
        NSArray *pixel = [img.pixel componentsSeparatedByString:@"*"];
        int width = [[pixel firstObject] intValue];
        int height = [[pixel lastObject] intValue];
        int maxWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
        // 限制宽度
        if (width > maxWidth) {
            height = height * maxWidth / width; // 数学计算,等比例公式
            width = maxWidth;
        }
        
        // 拼接图片
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 给图片绑定点击事件onclick
        // 注意这里需要先定义一个虚假的协议标记, 让webView不执行跳转,而是只获取图片的url
        // 为了预防图片太大,没有加载完成就调用了下面的保存方法,可以添加一个限制,用onload来限制让图片下载完成之后再执行保存
        NSString *onload = @"this.onclick = function() {"
                            "window.location.href = 'dx://?src=' + this.src;"
                            "};";
        
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%d\" height=\"%d\" src=\"%@\">",onload, width, height, img.src];
        
        [imgHtml appendString:@"</div>"];
        
        // 用一个字符串代替另一个字符串   这样就可以让标记图片注释的部位用一张真正的图片来替代
        [bodyM replaceOccurrencesOfString:img.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, bodyM.length)];
    }
    return bodyM;
}

```
CSS代码: DXDetail.css文件
```
.title {
    text-align : center;
    font-size : 25px;
    color : black;
    font-weight : 5px;
}

.time {
    text-align :center;
    font-size : 15px;
    color :gray;
    margin-top : 5px;
    margin-bottom : 10px;
}

.img-parent {
    text-align :center;
}
```
JS与OC代码的交互:
```
#pragma mark - 用户点击图片后的事件 JS与OC代码的交互
/** 当用户点击图片时,弹出提示框 并将图片保存到相册 */
// 这里需要用到JS代码和OC代码的交互
- (void)saveImageToAlbum:(NSString *)imgSrc {
    
    // 1. 提示一个弹窗,提示用户是否需要保存图片
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您是否需要将图片保存到相册?" preferredStyle:UIAlertControllerStyleActionSheet];
    // 1.1 添加两个按钮到弹窗上
    [alert addAction:[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 保存图片到相册
        [self saveToAlbum:imgSrc];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    // 1.2 显示
    [self presentViewController:alert animated:YES completion:nil];

}

/** 保存图片到相册的代码封装 */
- (void)saveToAlbum:(NSString *)imgSrc {
    // UIWebView 的缓存由 NSURLCache 来管理
    // 获取缓存对象
    NSURLCache *cache = [NSURLCache sharedURLCache];
    // 在缓存中取得对应请求的图片
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgSrc]];
    NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
    NSData *imageData = response.data;
    
    // 保存图片
    UIImage *image = [UIImage imageWithData:imageData];
    // 调用保存到相册的方法 后面三个参数为空,表示保存之后什么都不做
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

}
```
执行<UIWebViewDelegate>的代理方法
```
#pragma mark - 实现<UIWebViewDelegate>的代理方法
// 调用webView的代理方法之一: 每当webView发送一个请求之前就会先执行一次的方法
// 返回值: YES 表示允许发送请求, NO表示不允许发送请求
// 在webView的代理方法中截取图片路径,调用保存图片到相册的方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 通过url来截图地址
    // 先将发送的请求里面的url转换成字符串
    NSString *url = request.URL.absoluteString;
    // 找到标记所在的方法,确定截取范围
    NSRange range = [url rangeOfString:@"dx://?src="];
    // 判断获得的range是否不为空,如果不为空,就不允许发送请求,并截图范围之后的字符串,那就是图片的url
    if (range.length > 0) {
        // 先确定获取范围的长度,
        NSUInteger loc = range.location + range.length;
        // 根据这个长度,取范围之后的字符串,就取得图片的路径了
        NSString *imgSrc = [url substringFromIndex:loc];
        // 根据路径,将其保存到相册
        [self saveImageToAlbum:imgSrc];
        
        return NO;
    }
  return YES;
}

```
效果图:
 
![效果图:首页](http://upload-images.jianshu.io/upload_images/1483059-f45bbb4a3dd2b197.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![效果图:webView页面](http://upload-images.jianshu.io/upload_images/1483059-cab96ffa5b667c1b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 上面的代码,只是实现了部分功能,而且还没有做代码的重构,如有不足之处,还望大家斧正!!!  360°感谢!!!
