//
//  NewViewController.m
//  GCD
//
//  Created by lurich on 2019/3/15.
//  Copyright © 2019 ZiPeiYi. All rights reserved.
//

#import "NewViewController.h"
#import "GCD.h"

@interface NewViewController ()

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [GCDQueue executeInGlobalQueue:^{
        
        // download task, etc
        NSLog(@"下载图片");
        [GCDQueue executeInMainQueue:^{
            NSLog(@"显示UI");
            // update UI
        }];
    }];
    
    //信号处理。按顺序执行
    GCDSemaphore *semaphore = [[GCDSemaphore alloc] initWithValue:1];
    
    [GCDQueue executeInGlobalQueue:^{
        [semaphore wait];
        NSLog(@"GCDSemaphore_Request_1_start");
        sleep(1);
        // task oneUI
        NSLog(@"GCDSemaphore_Request_1");
        [semaphore signal];
    }];
    
    [GCDQueue executeInGlobalQueue:^{
        [semaphore wait];
        NSLog(@"GCDSemaphore_Request_2_start");
        sleep(1);
        // task oneUI
        NSLog(@"GCDSemaphore_Request_2");
        [semaphore signal];
    }];
    
    [GCDQueue executeInGlobalQueue:^{
        [semaphore wait];
        NSLog(@"GCDSemaphore_Request_3_start");
        sleep(1);
        // task oneUI
        NSLog(@"GCDSemaphore_Request_3");
        [semaphore signal];
        
        [GCDQueue executeInMainQueue:^{
            NSLog(@"请求结束");
        }];
    }];
    
    //按组的方式。 所有都请求完
    // init group
    GCDGroup *group = [GCDGroup new];
    // add to group
    [[GCDQueue globalQueue] execute:^{
        [group enter];
        NSLog(@"Request_1_start");
        sleep(1);
        // task oneUI
        NSLog(@"Request_1");
        [group leave];
    } inGroup:group];

    // add to group
    [[GCDQueue globalQueue] execute:^{
        [group enter];
        NSLog(@"Request_2_start");
        sleep(1);
        // task oneUI
        NSLog(@"Request_2");
        [group leave];
    } inGroup:group];

    // add to group
    [[GCDQueue globalQueue] execute:^{
        [group enter];
        NSLog(@"Request_3_start");
        sleep(1);
        // task oneUI
        NSLog(@"Request_3");
        [group leave];
    } inGroup:group];
    
    // notify in mainQueue
    [[GCDQueue mainQueue] notify:^{

        // task three
        NSLog(@"请求结束");
    } inGroup:group];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"页面被销毁");
}

@end
