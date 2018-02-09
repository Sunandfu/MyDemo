//
//  MyHorizonRefreshView.h
//  test
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
// ====== 自定义的拉动效果视图 ======

#import <UIKit/UIKit.h>
#import "MSPadHorizonView.h"
#import "UIView+Utils.h"

// 实现这个协议即可当做左右拉刷新的视图
@interface MyHorizonRefreshView : UIView<MSPadHorizonRefreshViewDelegate>
@property (nonatomic, assign) BOOL isLeft; // 区分左右的标识，这个视图做成同时具有左右拉的效果
@end
