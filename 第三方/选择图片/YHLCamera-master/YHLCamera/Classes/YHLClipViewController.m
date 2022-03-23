//
//  YHLClipViewController.m
//  YHLCamera_Example
//
//  Created by che on 2018/7/5.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import "YHLClipViewController.h"



@interface YHLClipViewController ()
- (IBAction)resetClick:(id)sender;
- (IBAction)okClick:(id)sender;

@end

@implementation YHLClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)resetClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(resetCameraClick)]) {
        [self.delegate resetCameraClick];
    }
}

- (IBAction)okClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(okCameraClick)]) {
        [self.delegate okCameraClick];
    }
}
@end
