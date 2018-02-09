//  THPlayer
//
//  Created by inveno on 16/3/22.
//  Copyright © 2016年 inveno. All rights reserved.
//

#import "MJRefreshComponent.h"

@interface MJRefreshHeader : MJRefreshComponent
/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 这个key用来存储上一次下拉刷新成功的时间 */
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
/** 上一次下拉刷新成功的时间 */
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;
@end
 // 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com