//
//  ViewController.m
//  XSSemgmentedViewDemo
//
//  Created by Xaofly Sho on 16/1/26.
//  Copyright © 2016年 Xaofly Sho. All rights reserved.
//

#import "ViewController.h"
#import "XSSegmentedView.h"

@interface ViewController () <XSSegmentedViewDelegate>

@property (nonatomic, strong) IBOutlet XSSegmentedView *segmentedView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     使用说明：
     初始化：
     可以在代码中通过alloc-init的方法初始化；
     例如：
     //初始化
     self.segmentedView = [[XSSegmentedView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
     //设置标题
     [self.segmentedView setTitles:@[@"消息",@"电话",@"视频",@"空间",@"圈子"]];
     或者：
     //初始化并设置标题
     self.segmentedView = [[XSSegmentedView alloc]initWithFrame:CGRectMake(0, 0, 200, 44) titles:@[@"消息",@"电话",@"视频",@"空间",@"游戏"]];
     
     或者在Xib（Storyboard）中拖拽View，设置继承自 XSSegmentedView 类。
     在Xib（Storyboard）中可设置TintColor，改变主体颜色。
     
     设置代理：
     代码与Xib（Storyboard）均使用
     self.segmentedView.delegate = self;
     设置代理
     
     代理方法：
     提供
     - (void)xsSegmentedView:(XSSegmentedView *)XSSegmentedView selectTitleInteger:(NSInteger)integer;
     - (BOOL)xsSegmentedView:(XSSegmentedView *)XSSegmentedView didSelectTitleInteger:(NSInteger)integer;
     代理方法，
     具体功能见代码注释
     */
    
    //初始化
//    self.segmentedView = [[XSSegmentedView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    //设置标题
    [self.segmentedView setTitles:@[@"消息",@"电话",@"视频",@"空间",@"游戏"]];
    
    //初始化并设置标题
//    self.segmentedView = [[XSSegmentedView alloc]initWithFrame:CGRectMake(0, 0, 200, 44) titles:@[@"消息",@"电话",@"视频",@"空间",@"游戏"]];
    
    
    
    //设置代理
    self.segmentedView.delegate = self;
    
    //设置颜色
//    self.segmentedView.textColor = [UIColor redColor];
//    self.segmentedView.viewColor = [UIColor blueColor];
    
    //设置为导航栏titleView
//    self.navigationItem.titleView = self.segmentedView;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 120, 30);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"选中第二个标题" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)sender {
    
    [self.segmentedView setSelectNumber:1 animate:YES];
}

- (void)xsSegmentedView:(XSSegmentedView *)XSSegmentedView selectTitleInteger:(NSInteger)integer {
    
    NSLog(@"select:%ld",(long)integer);
    
}

- (BOOL)xsSegmentedView:(XSSegmentedView *)XSSegmentedView didSelectTitleInteger:(NSInteger)integer {
    
    NSLog(@"didSelect:%ld",(long)integer);
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
