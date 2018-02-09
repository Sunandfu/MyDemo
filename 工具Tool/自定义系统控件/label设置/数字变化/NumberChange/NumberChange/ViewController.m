//
//  ViewController.m
//  NumberChange
//
//  Created by 赵群涛 on 16/7/11.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "ViewController.h"
#import "UICountingLabel.h"
#define WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createLabel];
    [self createLabel2];
    [self createLabel3];
    [self creatLabel4];
}
#pragma mark 样式一
- (void)createLabel {
    UICountingLabel* myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 50, 200, 40)];
    myLabel.format = @"%d";
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.formatBlock = ^NSString* (CGFloat value) {
        NSInteger years = value / 12;
        NSInteger months = (NSInteger)value % 12;
        if (years == 0) {
            return [NSString stringWithFormat: @"%ld months", (long)months];
        }
        else {
            return [NSString stringWithFormat: @"%ld years, %ld months", (long)years, (long)months];
        }
    };
    [myLabel countFrom:50 to:100 withDuration:3.0f];
    [self.view addSubview:myLabel];
    
}

#pragma mark 整数样式数字的变化

- (void)createLabel2 {
    UICountingLabel *myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label1.frame) +20, WIDTH, 45)];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.font = [UIFont fontWithName:@"Avenir Next" size:48];
    myLabel.textColor = [UIColor colorWithRed:236/255.0 green:66/255.0 blue:43/255.0 alpha:1];
    [self.view addSubview:myLabel];
    //设置格式
    myLabel.format = @"%d";
    //设置变化范围及动画时间
    [myLabel countFrom:0 to:100 withDuration:2.0f];
    
}

#pragma mark 浮点数样式数字的变化
- (void)createLabel3 {
    UICountingLabel *myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label2.frame) +20, WIDTH, 45)];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.font = [UIFont fontWithName:@"Avenir Next" size:48];
    myLabel.textColor = [UIColor colorWithRed:236/255.0 green:66/255.0 blue:43/255.0 alpha:1];
    [self.view addSubview:myLabel];
    //设置格式
    myLabel.format = @"%.2f";
    //设置变化范围及动画时间
    [myLabel countFrom:0.0 to:3198.23 withDuration:12.0f];
}

#pragma mark 带有千分位分隔符的浮点数样式
- (void)creatLabel4 {
    UICountingLabel *myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label3.frame) +20, WIDTH, 45)];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.font = [UIFont fontWithName:@"Avenir Next" size:48];
    myLabel.textColor = [UIColor colorWithRed:236/255.0 green:66/255.0 blue:43/255.0 alpha:1];
    [self.view addSubview:myLabel];
    //设置格式
    myLabel.format = @"%.2f";
    //设置分隔符样式
    myLabel.floatingPositiveFormat = @"###,##0.00";
    //设置变化范围及动画时间
    [myLabel countFrom:0.00 to:3048.64   withDuration:20.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
