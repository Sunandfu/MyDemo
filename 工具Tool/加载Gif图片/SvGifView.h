//
//  SvGifView.h
//  SvGifSample
//
//  Created by maple on 3/28/13.
//  Copyright (c) 2013 smileEvday. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SvGifView : UIView

/*
 * @brief desingated initializer
 */
- (id)initWithCenter:(CGPoint)center fileURL:(NSURL*)fileURL;
/*
 * @brief start Gif Animation
 */
- (void)startGif;
/*
 * @brief stop Gif Animation
 */
- (void)stopGif;
/*
 * @brief get frames image(CGImageRef) in Gif
 */
+ (NSArray*)framesInGif:(NSURL*)fileURL;

/*
 加载gif图片的三种方法
 1. webView形式
 // 设定位置和大小
 CGRect frame = CGRectMake(50,50,0,0);
 frame.size = [UIImage imageNamed:@"hub.gif"].size;
 // 读取gif图片数据
 NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"hub" ofType:@"gif"]];
 // view生成
 UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
 webView.userInteractionEnabled = NO;//用户不可交互
 [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
 webView.center = self.view.center;
 [self.view addSubview:webView];
 2. imageView 动画形式
 UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 NSArray *gifArray = [NSArray arrayWithObjects:
 [UIImage imageNamed:@"1"],
 [UIImage imageNamed:@"2"],
 [UIImage imageNamed:@"3"],
 [UIImage imageNamed:@"4"],
 [UIImage imageNamed:@"5"],
 [UIImage imageNamed:@"6"],
 [UIImage imageNamed:@"7"],
 [UIImage imageNamed:@"8"],
 [UIImage imageNamed:@"9"],,nil];
 gifImageView.animationImages = gifArray; //动画图片数组
 gifImageView.animationDuration = 5; //执行一次完整动画所需的时长
 gifImageView.animationRepeatCount = 1;  //动画重复次数
 [gifImageView startAnimating];
 [self.view addSubview:gifImageView];
 3. SvGifView形式
 SvGifView *showGif = [[SvGifView alloc] initWithCenter:self.view.center fileURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hub" ofType:@"gif"]]];
 [self.view addSubview:showGif];
 [showGif startGif];
 */

@end