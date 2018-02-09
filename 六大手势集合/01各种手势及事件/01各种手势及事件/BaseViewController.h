//
//  BaseViewController.h
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController {
    //目的为了让_imageView 的权限变成受保护的
    UIImageView *_imageView;
}

@property (nonatomic, strong) UIImageView *imageView;

//添加手势
- (void)addGesture;

//创建视图
- (void)createView;


@end
