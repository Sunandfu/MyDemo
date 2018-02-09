//
//  ViewController.m
//  渐变的文字
//
//  Created by 周少文 on 15/10/26.
//  Copyright © 2015年 ZheJiangWangHang. All rights reserved.
//

#import "ViewController.h"
#import "FadeStringView.h"
#import "CopyiPhoneFadeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blackColor];
    FadeStringView *fadeStringView = [[FadeStringView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    fadeStringView.text = @"浙江万航运动世界";
    fadeStringView.foreColor = [UIColor whiteColor];
    fadeStringView.backColor = [UIColor redColor];
    fadeStringView.font = [UIFont systemFontOfSize:30];
    fadeStringView.alignment = NSTextAlignmentCenter;
    fadeStringView.center = self.view.center;
    [self.view addSubview:fadeStringView];

    [fadeStringView fadeRightWithDuration:2];
    
    
    CopyiPhoneFadeView *iphoneFade = [[CopyiPhoneFadeView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    iphoneFade.text = @"浙江万航运动世界";
    iphoneFade.foreColor = [UIColor whiteColor];
    iphoneFade.backColor = [UIColor redColor];
    iphoneFade.font = [UIFont systemFontOfSize:30];
    iphoneFade.alignment = NSTextAlignmentCenter;
    iphoneFade.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0+50); 
    
    [iphoneFade iPhoneFadeWithDuration:2];

}


@end
