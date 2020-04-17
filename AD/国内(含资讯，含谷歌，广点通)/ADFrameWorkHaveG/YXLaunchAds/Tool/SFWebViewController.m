//
//  SFWebViewController.m
//  TestAdA
//
//  Created by lurich on 2019/4/25.
//  Copyright © 2019 YX. All rights reserved.
//

#import "SFWebViewController.h"

@interface SFWebViewController ()

@property (nonatomic, strong) UIView *addCustomView;

@end

@implementation SFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (nil!=[YXAdSDKManager defaultManager].webCustomView) {
        NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:[YXAdSDKManager defaultManager].webCustomView];
        self.addCustomView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        self.addCustomView.autoresizesSubviews =YES;
        for (UIView *view in self.addCustomView.subviews) {
            view.autoresizingMask =
            UIViewAutoresizingFlexibleLeftMargin   |
            UIViewAutoresizingFlexibleWidth        |
            UIViewAutoresizingFlexibleRightMargin  |
            UIViewAutoresizingFlexibleTopMargin    |
            UIViewAutoresizingFlexibleHeight       |
            UIViewAutoresizingFlexibleBottomMargin ;
        }
        self.addCustomView.frame = CGRectMake(SF_ScreenW-self.addCustomView.bounds.size.width-10, SF_ScreenH-SF_TabbarHeight-self.addCustomView.bounds.size.height-10, self.addCustomView.bounds.size.width, self.addCustomView.bounds.size.height);
        self.addCustomView.layer.masksToBounds = YES;
        self.addCustomView.layer.cornerRadius = (self.addCustomView.bounds.size.height<self.addCustomView.bounds.size.width?self.addCustomView.bounds.size.height:self.addCustomView.bounds.size.width)/2.0;
        self.addCustomView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewClick)];
        [self.addCustomView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.addCustomView removeFromSuperview];
}

- (void)customViewClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customWebViewClicked)]) {
        [self.delegate customWebViewClicked];
    }
}

@end
