//
//  CZViewController.m
//  D12.MenuTest
//
//  Created by Vincent_Guo on 14-10-10.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import "CZViewController.h"
#import "CZBottomMenu.h"


@interface CZViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation CZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 所有按钮的中心点
    CZBottomMenu *bottomMenu = [CZBottomMenu bottomMenu];
    [self.bottomView addSubview:bottomMenu];
    
}



@end
