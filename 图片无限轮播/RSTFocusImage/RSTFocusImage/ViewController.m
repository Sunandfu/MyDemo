//
//  ViewController.m
//  RSTFocusImage
//
//  Created by rong on 16/4/28.
//  Copyright © 2016年 rong. All rights reserved.
//

#import "ViewController.h"
#import "RSTFocusImage.h"
#import "SFLoopView.h"
#import "SDCycleScrollView.h"
#import "DDPhotoDetailController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<RSTFocusImageDelegate,SDCycleScrollViewDelegate,SFLoopViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *images = @[
                        @"http://img1.3lian.com/img013/v4/96/d/50.jpg",
                        @"http://img15.3lian.com/2015/f2/15/d/142.jpg",
                        @"http://img2.3lian.com/2014/f4/143/d/103.jpg",
                        @"http://www.51wendang.com/pic/11e7e567603f46269949ebe9/1-810-jpg_6-1080-0-0-1080.jpg",
                        @"http://image.tianjimedia.com/uploadImages/2013/235/3K652B0WH4M5.jpg",
                        @"http://image.tianjimedia.com/uploadImages/2013/256/ILCF68501494_1000x500.jpg"];

    
    //第一种 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200.0) delegate:nil placeholderImage:[UIImage imageNamed:@"123"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    cycleScrollView.titlesGroup = ({
        NSMutableArray *titleArrayM = [NSMutableArray array];
        for (int i = 0; i < images.count; i++) {
            [titleArrayM addObject:[NSString stringWithFormat:@"图片轮播第%d个",i]];
        }
        titleArrayM;
    });
    
    cycleScrollView.imageURLStringsGroup = ({
        NSMutableArray *urlArrayM = [NSMutableArray array];
        for (int i = 0; i < images.count; i++) {
            [urlArrayM addObject:images[i]];
        }
        urlArrayM;
    });
    
    [self.view addSubview:cycleScrollView];
    cycleScrollView.delegate = self;
    
    //第二种   加载网络图片无限轮播
    RSTFocusImage *focus = [[RSTFocusImage alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 200.0) Images:images Placeholder:[UIImage imageNamed:@"123"]];
    focus.delegate = self;
    [self.view addSubview:focus];

    //第三种   加载本地图片无限轮播
    SFLoopView *fecad = [[SFLoopView alloc] initWithFrame:CGRectMake(0, 440, SCREEN_WIDTH, 200.0) images:images autoPlay:YES delay:3.0];
    fecad.delegate = self;
    [self.view addSubview:fecad];
    
}
/** SDCycleScrollView轮播点击事件代理 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
     NSLog(@"%ld",index);
    DDPhotoDetailController *deafe = [[DDPhotoDetailController alloc] init];
    deafe.index = index;
    [self presentViewController:deafe animated:YES completion:nil];
}
- (void)tapFocusWithIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    DDPhotoDetailController *deafe = [[DDPhotoDetailController alloc] init];
    deafe.index = index;
    [self presentViewController:deafe animated:YES completion:nil];
}
- (void)loopViewDidSelectedImage:(SFLoopView *)loopView index:(int)index{
    NSLog(@"%d",index);
    DDPhotoDetailController *deafe = [[DDPhotoDetailController alloc] init];
    deafe.index = index;
    [self presentViewController:deafe animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
