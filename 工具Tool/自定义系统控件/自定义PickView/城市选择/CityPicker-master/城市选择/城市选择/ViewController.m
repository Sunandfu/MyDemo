//
//  ViewController.m
//  城市选择
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

#import "WSCityPicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, kScreenWidth-40, 40);
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"选择城市" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    

    
    
}


- (void)btnAction:(UIButton *)btn {
    
    
    WSCityPicker *wsPk = [[WSCityPicker alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:wsPk];
    
    
    [wsPk setBlock:^void(NSString *provinceStr,NSString *cityStr,NSString *districtStr){
        
        [btn setTitle:[NSString stringWithFormat:@"%@-%@-%@",provinceStr,cityStr,districtStr] forState:UIControlStateNormal];
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
