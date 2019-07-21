//
//  SFPageViewController.h
//  SFScrollPageView
//
//  Created by ZeroJ on 16/8/31.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SFPageViewControllerDelegate <NSObject>

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView;

@end

@interface SFPageViewController : UIViewController
// 代理
@property(weak, nonatomic)id<SFPageViewControllerDelegate> delegate;

@property (strong, nonatomic) UIScrollView *scrollView;

@end
