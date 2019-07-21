//
//  TextViewController.m
//  SFScrollPageView
//
//  Created by jasnig on 16/5/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "SFTestViewController.h"
#import "UIViewController+SFScrollPageController.h"
#import "SFTest1Controller.h"
#import "SFTest2ViewController.h"
@interface SFTestViewController ()

@end

@implementation SFTestViewController
- (IBAction)testBtnOnClick:(UIButton *)sender {
    SFTest2ViewController *test = [SFTest2ViewController new];
    [self showViewController:test sender:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)sf_viewDidLoadForIndex:(NSInteger)index {
//    NSLog(@"%@",self.view);
//    NSLog(@"%@", self.sf_scrollViewController);
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testBtn.backgroundColor = [UIColor whiteColor];
    [testBtn setTitle:@"点击" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];

    self.sf_scrollViewController.title  = @"测试过";

    if (index%2==0) {
        self.view.backgroundColor = [UIColor blueColor];
    } else {
        self.view.backgroundColor = [UIColor greenColor];

    }
}

// 使用系统的生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear------%ld", self.sf_currentIndex);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear-----%ld", self.sf_currentIndex);

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear-----%ld", self.sf_currentIndex);

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear--------%ld", self.sf_currentIndex);

}

// 使用SFScrollPageViewChildVcDelegate提供的生命周期方法

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    NSLog(@"viewDidDisappear--------");
//
//}
//- (void)sf_viewWillAppearForIndex:(NSInteger)index {
//    NSLog(@"viewWillAppear------");
//    
//}
//
//
//- (void)sf_viewDidAppearForIndex:(NSInteger)index {
//    NSLog(@"viewDidAppear-----");
//    
//}
//
//
//- (void)sf_viewWillDisappearForIndex:(NSInteger)index {
//    NSLog(@"viewWillDisappear-----");
//
//}
//
//- (void)sf_viewDidDisappearForIndex:(NSInteger)index {
//    NSLog(@"viewDidDisappear--------");
//
//}


- (void)dealloc
{
//    NSLog(@"%@-----test---销毁", self.description);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
