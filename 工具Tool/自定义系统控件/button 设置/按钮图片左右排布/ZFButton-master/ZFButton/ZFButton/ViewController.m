//
//  ViewController.m
//  ZFButton
//
//  Created by renzifeng on 15/8/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import "ViewController.h"
#import "ZFButton.h"

@interface ViewController ()
{
    BOOL isShow;//YES已展开，NO已收起
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float ww = self.view.frame.size.width/3;
    float hh = 50;
    NSArray *titleArr = @[@"无",@"左边",@"右边"];
    NSArray *colorArr = @[[UIColor lightGrayColor],[UIColor cyanColor],[UIColor greenColor]];
    for (int i = 0; i < 3; i++) {
        ZFButton* btn = [[ZFButton alloc] initWithFrame:CGRectMake(ww*i, 100, ww, hh)];
        btn.backgroundColor = (UIColor *)colorArr[i];
        btn.tag = 100 + 1;
        [btn setTitle:titleArr[i]];
        [btn setMarkImg:[UIImage imageNamed:@"mark1.png"]];
        [btn setMarkAlignment:i];
        [self.view addSubview:btn];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfTap:)];
        [btn addGestureRecognizer:tap];
        
    }
}

- (void)actionOfTap:(UITapGestureRecognizer *)sender
{
    ZFButton* btn = (ZFButton*)sender.view;
    isShow = !isShow;
    if (isShow) {
        isShow = YES;
        [UIView animateWithDuration:.3 animations:^{
            [btn setMarkImg:[UIImage imageNamed:@"mark2.png"]];
            btn.markImgView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else {
        isShow = NO;
        [UIView animateWithDuration:.3 animations:^{
            btn.markImgView.transform = CGAffineTransformIdentity;
            [btn setMarkImg:[UIImage imageNamed:@"mark1.png"]];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
