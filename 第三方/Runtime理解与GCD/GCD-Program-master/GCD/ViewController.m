//
//  ViewController.m
//  GCD
//
//  Created by YouXianMing on 15/10/19.
//  Copyright © 2015年 ZiPeiYi. All rights reserved.
//

#import "ViewController.h"
#import "GCD.h"
#import "NewViewController.h"

@interface ViewController (){
    int count;
}

@property (nonatomic, strong) GCDTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    count = 0;
    // init timer
    self.timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    
    // timer event
    [self.timer event:^{
        self->count++;
        // task
        if (self->count==3) {
            [self.timer destroy];
        }
        NSLog(@"定时器倒计时");
    } timeInterval:NSEC_PER_SEC * 3 delay:NSEC_PER_SEC * 3];
    
    // start timer
    [self.timer start];
    
    
    
    
    // init semaphore
    GCDSemaphore *semaphore = [GCDSemaphore new];
    semaphore = [semaphore initWithValue:2];
    // wait
    [GCDQueue executeInGlobalQueue:^{
        
        [semaphore wait];
        
        // todo sth else
    }];
    
    // signal
    [GCDQueue executeInGlobalQueue:^{
        
        // do sth
        [semaphore signal];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self presentViewController:[NewViewController new] animated:YES completion:nil];
}

@end
