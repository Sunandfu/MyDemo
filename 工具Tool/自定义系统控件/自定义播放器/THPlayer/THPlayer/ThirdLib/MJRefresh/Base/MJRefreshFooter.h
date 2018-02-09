//  THPlayer
//
//  Created by inveno on 16/3/22.
//  Copyright © 2016年 inveno. All rights reserved.
//


#import "MJRefreshComponent.h"

@interface MJRefreshFooter : MJRefreshComponent
/** 创建footer */
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建footer */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData;
- (void)noticeNoMoreData MJRefreshDeprecated("使用endRefreshingWithNoMoreData");

/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 忽略多少scrollView的contentInset的bottom */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;

/** 自动根据有无数据来显示和隐藏（有数据就显示，没有数据隐藏） */
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden;
@end
 // 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com