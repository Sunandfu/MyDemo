//
//  JKSideSlipView.h
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "MenuCell.h"

@interface JKSideSlipView : UIView
{
    BOOL isOpen;
    UITapGestureRecognizer *_tap;
    UISwipeGestureRecognizer *_leftSwipe, *_rightSwipe;
    UIImageView *_blurImageView;
    UIViewController *_sender;
    UIView *_contentView;
}
- (instancetype)initWithSender:(UIViewController*)sender;
- (instancetype)initWithSender:(UIViewController*)sender Button:(UIButton *)button;
-(void)show;
-(void)hide;
-(void)switchMenu;
-(void)setContentView:(UIView*)contentView;
/*
 ***********************示例代码****************************
 _sideSlipView = [[JKSideSlipView alloc]initWithSender:self];
 
 MenuView *menu = [MenuView menuView];
 [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
 NSLog(@"click");
 [_sideSlipView hide];
 NextViewController *next = [[NextViewController alloc]init];
 [self presentViewController:next animated:YES completion:^{
 NSLog(@"弹出新页面");
 
 }];
 }];
 menu.items = @[@{@"title":@"1",@"imagename":@"1"},
                @{@"title":@"2",@"imagename":@"2"},
                @{@"title":@"3",@"imagename":@"3"},
                @{@"title":@"4",@"imagename":@"4"}];
 [_sideSlipView setContentView:menu];
 [self.view addSubview:_sideSlipView];
 */
@end
