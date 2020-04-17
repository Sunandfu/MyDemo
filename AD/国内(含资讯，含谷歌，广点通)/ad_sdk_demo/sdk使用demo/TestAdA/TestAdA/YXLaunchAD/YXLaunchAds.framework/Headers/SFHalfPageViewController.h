//
//  SFHalfPageViewController.h
//  TestAdA
//
//  Created by lurich on 2019/4/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SFHalfPageControllerDelegate <NSObject>

@optional;
//仅在半屏接入时有效，以方便客户添加 数据加载动画 HUD
- (void)newsDataRefreshSuccess;
- (void)newsDataRefreshFail:(NSError *)error;

@end

@interface SFHalfPageViewController : UIViewController
// 控制滑动传递的 BOOL 值
@property (nonatomic, assign) BOOL vcCanScroll;
// 是否显示全部的频道： YES -> 所有频道 ; NO -> 只有一个推荐频道
@property (nonatomic, assign) BOOL isShowAllChannels;
// 用户 ID
@property (nonatomic, copy) NSString *mediaId;
// 内容位 ID
@property (nonatomic, copy) NSString *mLocationId;

// 顶部推荐资讯 view 的高度
@property (nonatomic, assign) CGFloat headerViewHeight;

//若想 修改 资讯推荐 部分 View  可传入自定义 View
@property(weak, nonatomic)id<SFHalfPageControllerDelegate> halfDelegate;

///自定义设置  （可选，当isShowAllChannels为 YES 时，可显示效果）
/** 是否显示分割线条 默认为YES*/
@property (assign, nonatomic) BOOL showDemarcationLine;
/** 分割线条的颜色 */
@property (strong, nonatomic) UIColor *scrollDemarcationLineColor;
/** 是否显示滚动条 默认为NO*/
@property (assign, nonatomic) BOOL showLine;
/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat scrollLineHeight;
/** 滚动条的颜色 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** 标题之间的间隙 */
@property (assign, nonatomic) CGFloat titleMargin;
/** 标题的字体 */
@property (strong, nonatomic) UIFont *titleFont;
/** 标题缩放倍数, 默认1.2 */
@property (assign, nonatomic) CGFloat titleBigScale;
/** 标题一般状态的颜色 */
@property (strong, nonatomic) UIColor *normalTitleColor;
/** 标题选中状态的颜色 */
@property (strong, nonatomic) UIColor *selectedTitleColor;

//刷新新闻数据
- (void)refreshNewsData;

@end

NS_ASSUME_NONNULL_END

