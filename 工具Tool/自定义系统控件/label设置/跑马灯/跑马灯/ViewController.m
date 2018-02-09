//
//  ViewController.m
//  跑马灯
//
//  Created by 耿岩 on 16/4/25.
//  Copyright © 2016年 耿岩. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) NSTimer* timer;// 定义定时器
@property(nonatomic,strong) UIView *viewAnima; //装 滚动视图的容器
@property(nonatomic,weak) UILabel *customLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加页面控件
    [self addChildView];
    // 启动NSTimer定时器来改变UIImageView的位置
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self selector:@selector(changePos)
                                                userInfo:nil repeats:YES];

    

}
- (void) addChildView {
    self.view.backgroundColor= [UIColor whiteColor];
    //定义视图大小
    CGFloat viewX = (self.view.frame.size.width-200)/2;
    UIView *viewAnima = [[UIView alloc] initWithFrame:CGRectMake(viewX, 100, 200, 40)];
    viewAnima.backgroundColor = [UIColor  yellowColor];
    self.viewAnima = viewAnima;
    self.viewAnima.clipsToBounds = YES;
    
    //定义视图容器
    //     [self.view addSubview:viewAnima];
    //    self.navigationItem.titleView = self.viewAnima;
    [self.view addSubview:self.viewAnima];
    
    CGFloat customLabY = (self.viewAnima.frame.size.height - 30)/2;
    UILabel *customLab = [[UILabel alloc] init];
    customLab.frame = CGRectMake(self.viewAnima.frame.size.width, customLabY, 250, 30);
    [customLab setTextColor:[UIColor redColor]];
    [customLab setText:@"跑马灯效果，滚动文本！"];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    self.customLab = customLab;
    
    
    
    //添加视图
    [self.viewAnima addSubview:customLab];
    
}
- (void) changePos
{
    CGPoint curPos = self.customLab.center;
    NSLog(@"%f",self.customLab.center.x);
    // 当curPos的x坐标已经超过了屏幕的宽度
    if(curPos.x <  -100 )
    {
        CGFloat jianJu = self.customLab.frame.size.width/2;
        // 控制蝴蝶再次从屏幕左侧开始移动
        self.customLab.center = CGPointMake(self.viewAnima.frame.size.width + jianJu, 20);
       
    }
    else
    {
        // 通过修改iv的center属性来改变iv控件的位置
        self.customLab.center = CGPointMake(curPos.x - 5, 20);
    }
    //其实蝴蝶的整个移动都是————靠iv.center来去设置的
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
