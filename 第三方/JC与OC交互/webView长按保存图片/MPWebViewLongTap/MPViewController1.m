//
//  MPViewController1.m
//  MPWebViewLongTap
//
//  Created by Plum on 16/4/26.
//  Copyright © 2016年 ManPao. All rights reserved.
//

#import "MPViewController1.h"


@interface MPViewController1 ()<UIWebViewDelegate,UIActionSheetDelegate>
{
    int _gesState;
    NSString *_imgURL;
    NSTimer *_timer;
}
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation MPViewController1
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initWebView];
}

- (void)initWebView{
    
    
    //添加一个webview
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scrollView.clipsToBounds = NO;
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES;
    [webView setUserInteractionEnabled:YES];
    [webView setOpaque:NO];
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"http://mp.weixin.qq.com/s?__biz=MjM5NTE0ODc2Nw==&mid=2650424225&idx=2&sn=45a94033c5c68f0c195fbc8c7657512e&scene=0#wechat_redirect"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

#pragma mark --- webview delegate ---
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
    [webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    
}
// 功能：UIWebView响应长按事件
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {
    
    [_timer invalidate];
    _timer = nil;
    _gesState = GESTURE_STATE_END;
    
    NSString *requestString = [[_request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //NSLog(@"you are touching!");
            //NSTimeInterval delaytime = Delaytime;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                _gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
                if (_imgURL) {
                    _timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
        }
        else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
            [_timer invalidate];
            _timer = nil;
            _gesState = GESTURE_STATE_END;
            NSLog(@"touch end");
        }
        return NO;
    }
    
    return YES;
//    return [super webView:webView shouldStartLoadWithRequest:_request navigationType:navigationType];
}
// 功能：如果点击的是图片，并且按住的时间超过1s，执行handleLongTouch函数，处理图片的保存操作。
- (void)handleLongTouch {
    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
// 功能：保存图片到手机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存到手机"]) {
        if (_imgURL) {
            NSLog(@"imgurl = %@", _imgURL);
        }
        NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:_imgURL];
        NSLog(@"image url = %@", urlToSave);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        UIImage* image = [UIImage imageWithData:data];
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        NSLog(@"UIImageWriteToSavedPhotosAlbum = %@", urlToSave);
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
// 功能：显示对话框
-(void)showAlert:(NSString *)msg {
    NSLog(@"showAlert = %@", msg);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}
// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
        [self showAlert:@"保存失败..."];
    }else {
        NSLog(@"OK");
        [self showAlert:@"保存成功！"];
    }
}


@end
