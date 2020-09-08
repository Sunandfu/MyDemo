//
//  SCViewController.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/8.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "SCViewController.h"
#import "SCSwipeBackInteractionController.h"
#import "SCPushTransition.h"
#import "SCPresentTransition.h"

@interface SCViewController()<SCGestureBackInteractionDelegate>

@end

@implementation SCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    imageView.frame = CGRectMake(0, 64, width, width);
    [self.view addSubview:imageView];
    _avatarView = imageView;
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismissHandler:)];
    UIBarButtonItem *popItem = [[UIBarButtonItem alloc] initWithTitle:@"pop" style:UIBarButtonItemStylePlain target:self action:@selector(popHandler:)];
    self.navigationItem.leftBarButtonItems = @[dismissItem, popItem];
}

- (void)dismissHandler:(id)sender {
    [SCPresentTransition dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss done!!!");
    }];
}

- (void)popHandler:(id)sender {
    [SCPushTransition popViewControllerAnimated:YES completion:^{
        NSLog(@"pop done!!!");
    }];
}

#pragma mark - SCGestureBackInteractionDelegate

//- (BOOL)disableGuesture {
//    return YES;
//}

- (void)gestureBackBegin {
    NSLog(@"手势开始");
}

- (void)gestureBackCancel {
    NSLog(@"手势取消");
}

- (void)gestureBackFinish {
    NSLog(@"手势结束");
}

//- (void)fireGuestureBack {
//    NSLog(@"自定义手势行为");
//}

@end
