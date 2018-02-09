//
//  SDBrowserImageView.h
//  SDPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWaitingView.h"


@interface SDBrowserImageView : UIImageView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;

- (void)eliminateScale; // 清除缩放

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doubleTapToZommWithScale:(CGFloat)scale;

- (void)clear;

/*
 使用步骤
 1. 导入头文件
 #import "SDPhotoBrowserConfig.h"
 #import "UIImageView+WebCache.h"
 2. 遵循代理
 SDPhotoBrowserDelegate
 3. 代码实现例子
 - (void)viewDidLoad {
 [super viewDidLoad];
 NSLog(@"%d",[[NSDate date] day]);
 self.urlArray = @[
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_1.jpg",
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_2.jpg",
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_3.jpg",
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_4.jpg",
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_5.jpg",
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_6.jpg",
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_7.jpg",
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_8.jpg",
 @"http://img.yun-xiang.net/hbguard/xiaowei_yskp_3_9.jpg",
 ];
 tmpView = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 300, 300)];
 [self.view addSubview:tmpView];
 UIView *pView = [[UIView alloc] initWithFrame:tmpView.frame];
 [self.view addSubview:pView];
 for (int i=0; i<3; i++) {
 for (int j=0; j<3; j++) {
 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*100, i*100, 100, 100)];
 [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[i*3+j]]];
 imageView.tag = i*3+j+10;
 [tmpView addSubview:imageView];
 UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 button.frame = CGRectMake(j*100, i*100, 100, 100);
 [button addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
 button.tag = i*3+j;
 [pView addSubview:button];
 
 }
 }
 NSLog(@"tmpView=%ld",tmpView.subviews.count);
 }
 - (void)imageClick:(UIButton *)sender{
 SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
 photoBrowser.delegate = self;
 photoBrowser.currentImageIndex = sender.tag;
 photoBrowser.imageCount = self.urlArray.count;
 photoBrowser.sourceImagesContainerView = tmpView;
 [photoBrowser show];
 }
 #pragma mark  SDPhotoBrowserDelegate
 
 // 返回临时占位图片（即原来的小图）
 - (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
 {
 NSLog(@"UIImage=%ld",index);
 // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
 UIImageView *cell = (UIImageView *)[self.view viewWithTag:index+10];
 
 return cell.image;
 
 }
 // 返回高质量图片的url
 - (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
 {
 NSString *urlStr = self.urlArray[index];
 return [NSURL URLWithString:urlStr];
 }
 */

@end
