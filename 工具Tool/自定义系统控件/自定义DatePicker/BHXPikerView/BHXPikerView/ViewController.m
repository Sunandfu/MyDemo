//
//  ViewController.m
//  BHXPikerView
//
//  Created by 包红旭 on 2017/2/7.
//  Copyright © 2017年 包红旭. All rights reserved.
//

#import "ViewController.h"
#import "BHXPikerView.h"
#import "Masonry.h"
@interface ViewController ()<BHXDatePikerViewDelegate>
@property (nonatomic,strong) UIButton *chooseTimeBtn;
@property (nonatomic,strong)BHXPikerView *timeV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseTimeBtn = [[UIButton alloc]init];
    [self.chooseTimeBtn setTitle:@"选 择 时 间" forState:UIControlStateNormal];
    [self.chooseTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.chooseTimeBtn];
    [self.chooseTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@200);
    }];
    
    [self.chooseTimeBtn addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)chooseTime:(UIButton *)sender {
    self.timeV = [[BHXPikerView alloc]initWithFrame:self.view.bounds type:UIDatePickerModeDate];
    self.timeV.delegate = self;
    [self.view addSubview:self.timeV];
    //初始化时间
    if (sender.titleLabel.text.length != 0 && ![sender.titleLabel.text isEqualToString:@"选 择 时 间"]) {
        [self.timeV setNowTime:sender.titleLabel.text];
    }
}

#pragma mark - TXTimeDelegate
//当时间改变时触发
- (void)changeTime:(NSDate *)date{
    [self.chooseTimeBtn setTitle:[self.timeV stringFromDate:date] forState:UIControlStateNormal];

    NSLog(@"%@",date);
}

//确定时间
- (void)determine:(NSDate *)date{
    [self.chooseTimeBtn setTitle:[self.timeV stringFromDate:date] forState:UIControlStateNormal];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
