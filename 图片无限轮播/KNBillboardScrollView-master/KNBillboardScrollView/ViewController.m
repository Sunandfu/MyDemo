//
//  ViewController.m
//  KNBillboardScrollView
//
//  Created by 刘凡 on 2017/11/14.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "ViewController.h"
#import "KNBillboadrView.h"

@interface ViewController ()<KNBillboadrViewDelegate>

@property(nonatomic, strong)KNBillboadrView *bollboadrView;

@property (nonatomic, strong) UIButton * LoadDataButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSArray *imageArray = @[
                            [YYImage imageNamed:@"3.jpg"],
                            @"http://pic1.win4000.com/wallpaper/2017-11-15/5a0bac8b71131.jpg",
                            //使用本地gif图片的时候。需要调用这个方法
                            [YYImage imageNamed:@"2.gif"],
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510747412310&di=308b1b2e2d6ccb6a35796275fc185eaf&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01f90e593a4ad4a8012193a3dcf03d.gif"
                            ];
    
    NSArray *descArray = @[@"本地看星星",@"网络图片",@"本地gif图片",@"网络gif图片"];
    
    //第一种方式创建广告栏。图片数据已经存在的情况下
    _bollboadrView = [[KNBillboadrView alloc]initKNBillboadrViewWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) andImageArray:imageArray andDescArray:descArray andplaceholdImage:[UIImage imageNamed:@"KNBilboardDefalutImge.png"]];
    
    
    //第二种方式创建广告栏。 图片数据暂时没有的情况下
  
    /** _bollboadrView = [[KNBillboadrView alloc]initKNBillboadrViewWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) andplaceholdImage:[UIImage imageNamed:@"KNBilboardDefalutImge.png"]];
     */
    
    
    
    [_bollboadrView setBackgroundColor:[UIColor grayColor]];
    
    //设置代理
    _bollboadrView.delegate = self;
    _bollboadrView.KNPageCotrollPostion = KNPostionBottomLeft;
    [_bollboadrView setPageImage:[UIImage imageNamed:@"4"] andCurrentPageImage:[UIImage imageNamed:@"5"]];
    _bollboadrView.time = 5.f;
    
    // 设置滑动时gif停止播放
    _bollboadrView.gifPlayMode = KNGifPlayModePauseWhenScroll;
    
    [self.view addSubview:_bollboadrView];
    
    [self.view addSubview:self.LoadDataButton];
    
    
}

-(void)ClickLoad:(UIButton *)sender{
    //定义两个数组。
    NSArray *imageArray = @[
                            [YYImage imageNamed:@"3.jpg"],
                            @"http://pic1.win4000.com/wallpaper/2017-11-15/5a0bac8b71131.jpg",
                            //使用本地gif图片的时候。需要调用这个方法
                            [YYImage imageNamed:@"2.gif"],
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510747412310&di=308b1b2e2d6ccb6a35796275fc185eaf&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01f90e593a4ad4a8012193a3dcf03d.gif"
                            ];
    
    NSArray *descArray = @[@"本地看星星",@"网络图片",@"本地gif图片",@"网络gif图片"];
    
    [_bollboadrView setImageArray:imageArray andDescArray:descArray];
    
}

-(void)KNBillboadrView:(KNBillboadrView *)BillboadrView ClickImageForIndex:(NSInteger)index
{
    NSLog(@"index %ld",index);
}




-(UIButton *)LoadDataButton{
    if (!_LoadDataButton) {
        _LoadDataButton = [[UIButton alloc]initWithFrame:CGRectMake(20,300, 60, 40)];
        [_LoadDataButton setTitle:@"加载数据" forState:(UIControlStateNormal)];
        _LoadDataButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_LoadDataButton setBackgroundColor:[UIColor redColor]];
        /*
        [_LoadDataButton addTarget:self action:@selector(ClickLoad:) forControlEvents:UIControlEventTouchUpInside];
         */
    }
    return _LoadDataButton;
}


@end
