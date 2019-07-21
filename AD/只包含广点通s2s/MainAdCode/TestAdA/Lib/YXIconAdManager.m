//
//  YXIconAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/6/11.
//  Copyright © 2018年 YX. All rights reserved.
//
#import "YXIconAdManager.h"
#import "NetTool.h"
#import "Network.h"
#import "YXImgUtil.h"
#import "YXGTMDefines.h"
#import "YXWebViewController.h"
#import <SafariServices/SafariServices.h>
#import "WXApi.h"
#import "YXMenuViewCell.h"
#import "YXPopupMenu.h"
#import "NetTool.h"

@interface YXIconAdManager()<YXIconAdManagerDelegate,YXWebViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,WXApiDelegate,YXPopupMenuDelegate>
{
    CGFloat _width;
    CGFloat _height;
    
    UIImageView *_imgView;
    UIWebView *_webView;
    NSString *_mediaId; 
    
}
@property (nonatomic, strong) NSDictionary *adDict;

@property (nonatomic, strong) NSMutableArray *adDictArray;

@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic) CGPoint currentPoint;

@end

@implementation YXIconAdManager

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = self.frame.size.width;
        _height = self.frame.size.height;
    }
    return self;
}
- (void)loadIconAd
{
    [self XZAD];
}
#pragma mark s2s
- (void)XZAD
{
    NSString *macId = [Network sharedInstance].ipStr;
    if (self.mediaId) {
        [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId width:_width height:_height macID:macId uid:[NetTool getOpenUDID] adCount:1];
        [self initXAD];
    } else {
        self.adDictArray = [NSMutableArray arrayWithCapacity:0];
        for (NSString *mediaId in self.mediaIdArray) {
            [[Network sharedInstance] prepareDataAndRequestWithadkeyString:mediaId width:_width height:_height macID:macId uid:[NetTool getOpenUDID] adCount:1];
            [self initXAD];
        }
    }
}

- (void)initXAD
{
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                NSArray * arr = json[@"adInfos"];
                if (arr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [self failedError:errors];
                    return ;
                }
                if (self.mediaId) {
                    self.adDict = arr.lastObject;
                } else {
                    [self.adDictArray addObject:arr.lastObject];
                }
                if ([json objectForKey:@"data"]) {
                    if ([[json objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                        NSMutableArray *muarray = [json objectForKey:@"data"];
                        if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
                        {
                            NSArray *viewS = muarray;
                            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                                [Network groupNotifyToSerVer:viewS];
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self   showNativeAd];
                });
            }else{
                NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                [self failedError:errors];
            }
         
        }else{
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            [self failedError:errors];
        }
    }];
}

-(void) showNativeAd
{
    if (self.mediaId) {
        if(!self.adDict){//40041无广告
            NSError *errors = [NSError errorWithDomain:@"暂无填充广告，请重试" code:400 userInfo:nil];
            [self failedError:errors];
            return;
        }
        _YXGTMDevLog(@"Func type 1 start") ;
        NSString *img_url = self.adDict[@"img_url"];
        //    NSString *click_url = self.adDict[@"click_url"];
        //    _returnDict = [NSDictionary dictionaryWithObjectsAndKeys:click_url,@"click_url",img_url,@"img_url",@"1",@"type", nil];
        //    if (self.adDict[@"logo_url"]) {
        //        NSString * logo_url = self.adDict[@"logo_url"] ;
        //        _returnDict = [NSDictionary dictionaryWithObjectsAndKeys:logo_url,@"logo_url",click_url,@"click_url",img_url,@"img_url",@"1",@"type", nil];
        //    }
        NSString *lastCompnoments = [[img_url componentsSeparatedByString:@"/"] lastObject];
        if([lastCompnoments hasSuffix:@"gif"]){
            [self showGif];
        }else{
            [self showJpgImage];
        }
    } else {
        if(self.adDictArray.count==0){//40041无广告
            NSError *errors = [NSError errorWithDomain:@"暂无填充广告，请重试" code:400 userInfo:nil];
            [self failedError:errors];
            return;
        }
        _YXGTMDevLog(@"Func type 1 start");
        self.iconArray = [NSMutableArray arrayWithCapacity:0];
        self.titleArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in self.adDictArray) {
            NSString *img_url = dict[@"img_url"];
            [self.iconArray addObject:img_url];
            NSString *title = dict[@"title"];
            [self.titleArray addObject:title];
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadIconAd:)]){
            [self.delegate didLoadIconAd:self];
        }
    }
    
}

-(void) showGif
{
    [self addWebView];
    NSString *urlstr = self.adDict[@"img_url"];
    if(urlstr && ![urlstr isEqualToString:@""]){
        // 1.加载
        [YXImgUtil gifImgWithUrl:urlstr successBlock:^(NSData *data) { 
            
            [self->_webView loadData:data MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:urlstr]];
            if (self.adDict[@"logo_url"]) {
                NSString * logo_url = self.adDict[@"logo_url"];
                UIImage *logoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logo_url]]];
                UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(self->_webView.frame.size.width - 24 , self->_webView.frame.size.height - 24, 24, 24)];
                logoView.image = logoImage ;
                [self->_webView addSubview:logoView];
            }
            // 2.显示成功
            // 2.显示成功
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadIconAd:)]){
                    [self.delegate didLoadIconAd:self];
                }
                // 3.上报
                [self groupNotify];
            });
            
        } failBlock:^(NSError *error) {
            NSError *errors = [NSError errorWithDomain:@"加载Gif失败,请重试" code:400 userInfo:nil];
            [self failedError:errors];
        }];
    }else{
        // 3.加载下一副广告,使用定时器
        NSError *errors = [NSError errorWithDomain:@"加载Gif失败,请重试" code:400 userInfo:nil];
        [self failedError:errors];
    }
}

-(void)showJpgImage
{
    [self addImgView];
    
    NSString *urlstr = self.adDict[@"img_url"];
    if(urlstr && ![urlstr isEqualToString:@""]){
        
        [YXImgUtil imgWithUrl:urlstr successBlock:^(UIImage *img) {
            self->_imgView.image =img;
            // 2.显示成功
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self->_delegate && [self->_delegate respondsToSelector:@selector(didLoadIconAd:)]){
                    
                    [self->_delegate didLoadIconAd:self];
                }
                // 3.上报
                [self groupNotify];
            });
            
        } failBlock:^(NSError *error) {
            NSError *errors = [NSError errorWithDomain:@"加载jpg失败,请重试" code:400 userInfo:nil];
            [self failedError:errors];
        }];
        
    }else{
        // 3.加载下一副广告,使用定时器 url不存在
        NSError *errors = [NSError errorWithDomain:@"加载jpg失败,请重试" code:400 userInfo:nil];
        [self failedError:errors];
    }
}

- (void)failedError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(didFailedLoadIconAd:)]) {
            
            [self->_delegate didFailedLoadIconAd:error];
        }
    });
    
}
-(void) addWebView
{
    if(_webView){
        [_webView removeFromSuperview];
        _webView = nil;
    }
    
    _webView = [[UIWebView alloc]initWithFrame:self.bounds];
    
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self ;
    [_webView setScalesPageToFit:YES];
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    [self addSubview:_webView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [_webView addGestureRecognizer:tap];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void) addImgView
{
    if(_imgView){
        [_imgView removeFromSuperview];
        _imgView = nil;
    }
 
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    _imgView = imgView;
    
#pragma mark 设置图片展示模式
    //    imgView.contentMode
    imgView.userInteractionEnabled = YES;
    [self addSubview:_imgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    tap.numberOfTapsRequired = 1;
    [_imgView addGestureRecognizer:tap];
}



// 点击图片信息
-(void)tapImg:(UITapGestureRecognizer *)recognizer
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGPoint point = [recognizer locationInView:window.rootViewController.view];
    NSString * x =  [NSString stringWithFormat:@"%f",point.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",point.y ];
    
    NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
    NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
    
    //    NSString *dicStr =  [NSString stringWithFormat:@"{%@:%@,%@:%@,%@:%@,%@:%@}",@"down_x",x,@"down_y",y,@"up_x",x,@"up_y",y];
    if(!self.adDict){
        return;
    }
    // 1.跳转链接
    NSString *urlStr = self.adDict[@"click_url"];
    
    NSString * click_position = [NSString stringWithFormat:@"%@",self.adDict[@"click_position"]];
    if ([click_position isEqualToString:@"1"]) {
        if (self.adDict[@"width"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",self.adDict[@"width"]]];
        }
        if (self.adDict[@"height"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",self.adDict[@"height"]]];
        }
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
        
    }
    
    NSString * ac_type = [NSString stringWithFormat:@"%@",self.adDict[@"ac_type"]];
    
    if ([ac_type isEqualToString:@"1"] || [ac_type isEqualToString:@"2"]) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
            [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
            
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if ([ac_type isEqualToString:@"6"]) {
        NSString *deeplick = self.adDict[@"deep_url"];
        NSURL *deeplickUrl = [NSURL URLWithString:deeplick];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:deeplickUrl options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    NSURL *url = [NSURL URLWithString:urlStr];
                    if (@available(iOS 9.0, *)) {
                        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
                        [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
                        
                    } else {
                        YXWebViewController *web = [YXWebViewController new];
                        web.URLString = urlStr;
                        [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
                    }
                }
            }];
        }else{
            NSURL *url = [NSURL URLWithString:urlStr];
            if (@available(iOS 9.0, *)) {
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
                [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
                
            } else {
                YXWebViewController *web = [YXWebViewController new];
                web.URLString = urlStr;
                [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
            }
        }
        
    } else if ([ac_type isEqualToString:@"7"]){//6。app。 7。 小程序
        
        NSString * miniPath = [NSString stringWithFormat:@"%@",self.adDict[@"miniPath"] ];
        miniPath = [miniPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * miniProgramOriginId = [NSString stringWithFormat:@"%@",self.adDict[@"miniProgramOriginId"]];
        
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = miniProgramOriginId;  //拉起的小程序的username
        launchMiniProgramReq.path = miniPath;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
        
        BOOL installWe = [WXApi isWXAppInstalled];
        if (installWe) {
            [WXApi sendReq:launchMiniProgramReq];
        }else{
            NSLog(@"未安装微信");
        }
        
        [Network notifyToServer:nil serverUrl:urlStr completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(connectionError){
                NSLog(@"#####%@\error",[connectionError debugDescription]);
            }else{
                NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (json) {
                    NSLog(@"%@",json);
                }
            }
        }]; 
    }else{
        if(urlStr && ![urlStr isEqualToString:@""]){
            
//            NSURL *url = [NSURL URLWithString:urlStr];
//             [[UIApplication sharedApplication] openURL:url];
            
            YXWebViewController *web = [YXWebViewController new];
            web.URLString = urlStr;
            web.delegate = self;
            [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
        }
    }
    
    //    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,dicStr];
    
    
    // 2.上报服务器
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        // 上报服务器
        NSArray *viewS = self.adDict[@"click_notice_urls"];
        if ([click_position isEqualToString:@"1"]) {
            
            if (self.adDict[@"width"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",self.adDict[@"width"]]];
            }
            if (self.adDict[@"height"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",self.adDict[@"height"]]];
            }
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
            
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
        }
        [Network groupNotifyToSerVer:viewS];
    }
    [self clikedADs2sPan];
}
-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]])
    {
//        NSString *string = resp.extMsg;
//        // 对应小程序组件 <button open-type="launchApp"> 中的 app-parameter 属性
    }
}

- (void)clikedADs2sPan
{
    if(_delegate && [_delegate respondsToSelector:@selector(didClickedIconAd)]){
        [_delegate didClickedIconAd];
    }
}

#pragma mark -webView delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    [self addTimer];
    //    if(_delegate && [_delegate respondsToSelector:@selector(showNativeFail:)]){
    //        [_delegate showNativeFail:error];
    //    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    // 3.上报
    [self groupNotify];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
//    [[UIApplication sharedApplication] openURL:request.URL];
    return YES;
}

#pragma mark -上报给指定服务器

-(void) groupNotify
{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        NSArray *viewS = self.adDict[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }
}
- (void)showCustomPopupMenuWithPoint:(CGPoint)point
{
    if (self.iconArray.count==0) {
        return;
    }
    self.currentPoint = point;
    [YXPopupMenu showAtPoint:self.currentPoint titles:self.titleArray icons:self.iconArray menuWidth:(self.itemWidth?self.itemWidth:80) otherSettings:^(YXPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.type = YXPopupMenuTypeDefault;
        popupMenu.priorityDirection = (int)self.popType;
        popupMenu.cornerRadius = 8;
        popupMenu.itemHeight = self.itemHeight?self.itemHeight:100;
//        popupMenu.rectCorner = UIRectCornerTopLeft| UIRectCornerTopRight;
        popupMenu.tag = 100;
        if (self.menuGroundColor) {
            popupMenu.backColor = self.menuGroundColor;
        }
        //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
//        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }];
}

#pragma mark - YXPopupMenuDelegate
- (void)ybPopupMenu:(YXPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    CGPoint point = self.currentPoint;
    NSString * x =  [NSString stringWithFormat:@"%f",point.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",point.y ];
    
    NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
    NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
    
    //    NSString *dicStr =  [NSString stringWithFormat:@"{%@:%@,%@:%@,%@:%@,%@:%@}",@"down_x",x,@"down_y",y,@"up_x",x,@"up_y",y];
    if(self.adDictArray.count==0){
        return;
    }
    // 1.跳转链接
    NSDictionary *adDic = self.adDictArray[index];
    NSString *urlStr = adDic[@"click_url"];
    
    NSString * click_position = [NSString stringWithFormat:@"%@",adDic[@"click_position"]];
    if ([click_position isEqualToString:@"1"]) {
        if (adDic[@"width"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",adDic[@"width"]]];
        }
        if (adDic[@"height"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",adDic[@"height"]]];
        }
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
        
    }
    
    NSString * ac_type = [NSString stringWithFormat:@"%@",adDic[@"ac_type"]];
    
    if ([ac_type isEqualToString:@"1"] || [ac_type isEqualToString:@"2"]) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
            [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
            
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if ([ac_type isEqualToString:@"6"]) {
        NSString *deeplick = adDic[@"deep_url"];
        NSURL *deeplickUrl = [NSURL URLWithString:deeplick];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:deeplickUrl options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    NSURL *url = [NSURL URLWithString:urlStr];
                    if (@available(iOS 9.0, *)) {
                        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
                        [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
                        
                    } else {
                        YXWebViewController *web = [YXWebViewController new];
                        web.URLString = urlStr;
                        [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
                    }
                }
            }];
        }else{
            NSURL *url = [NSURL URLWithString:urlStr];
            if (@available(iOS 9.0, *)) {
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
                [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
                
            } else {
                YXWebViewController *web = [YXWebViewController new];
                web.URLString = urlStr;
                [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
            }
        }
        
    } else if ([ac_type isEqualToString:@"7"]){
        
        NSString * miniPath = [NSString stringWithFormat:@"%@",adDic[@"miniPath"] ];
        miniPath = [miniPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * miniProgramOriginId = [NSString stringWithFormat:@"%@",adDic[@"miniProgramOriginId"]];
        
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = miniProgramOriginId;  //拉起的小程序的username
        launchMiniProgramReq.path = miniPath;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
        
        BOOL installWe = [WXApi isWXAppInstalled];
        if (installWe) {
            [WXApi sendReq:launchMiniProgramReq];
        }else{
            NSLog(@"未安装微信");
        }
        
        [Network notifyToServer:nil serverUrl:urlStr completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(connectionError){
                NSLog(@"#####%@\error",[connectionError debugDescription]);
            }else{
                NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (json) {
                    NSLog(@"%@",json);
                }
            }
        }];
    }else{
        if(urlStr && ![urlStr isEqualToString:@""]){
            YXWebViewController *web = [YXWebViewController new];
            web.URLString = urlStr;
            web.delegate = self;
            [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
        }
    }
    
    // 2.上报服务器
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        // 上报服务器
        NSArray *viewS = adDic[@"click_notice_urls"];
        if ([click_position isEqualToString:@"1"]) {
            
            if (adDic[@"width"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",adDic[@"width"]]];
            }
            if (adDic[@"height"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",adDic[@"height"]]];
            }
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
            
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
        }
        [Network groupNotifyToSerVer:viewS];
    }
    [self clikedADs2sPan];
}
- (UITableViewCell *)ybPopupMenu:(YXPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index
{
    if (ybPopupMenu.tag != 100) {
        return nil;
    }
    static NSString * identifier = @"YXMenuViewCell";
    YXMenuViewCell * cell = [ybPopupMenu.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YXMenuViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
//    if (self.menuGroundColor) {
//        cell.backgroundColor = self.menuGroundColor;
//    }
    if (self.titleColor) {
        cell.titleLabel.textColor = self.titleColor;
    }
    if (self.titleFont) {
        cell.titleLabel.font = self.titleFont;
    }
    if ([self.titleArray[index] isKindOfClass:[NSAttributedString class]]) {
        cell.titleLabel.attributedText = self.titleArray[index];
    }else if ([self.titleArray[index] isKindOfClass:[NSString class]]) {
        cell.titleLabel.text = self.titleArray[index];
    }else {
        cell.titleLabel.text = nil;
    }
    if (self.contentMode) {
        cell.iconImageView.contentMode = self.contentMode;
    }
    if (self.iconArray.count >= index + 1) {
        if ([self.iconArray[index] hasPrefix:@"http"]) {
            [NetTool setImage:cell.iconImageView WithURLStr:self.iconArray[index] placeholderImage:nil];
        }else if ([self.iconArray[index] isKindOfClass:[NSString class]]) {
            cell.iconImageView.image = [UIImage imageNamed:self.iconArray[index]];
        }else if ([self.iconArray[index] isKindOfClass:[UIImage class]]){
            cell.iconImageView.image = self.iconArray[index];
        }else {
            cell.iconImageView.image = nil;
        }
    }else {
        cell.iconImageView.image = nil;
    }
    return cell;
}

@end
