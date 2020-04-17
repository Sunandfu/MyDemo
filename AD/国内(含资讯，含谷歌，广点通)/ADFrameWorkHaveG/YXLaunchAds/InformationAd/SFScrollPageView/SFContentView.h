//
//  SFContentView.h
//  SFScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFScrollPageViewDelegate.h"
#import "SFCollectionView.h"
#import "SFScrollSegmentView.h"
#import "UIViewController+SFScrollPageController.h"



@interface SFContentView : UIView

/** 必须设置代理和实现相关的方法*/
@property(weak, nonatomic)id<SFScrollPageViewDelegate> delegate;
@property (strong, nonatomic, readonly) SFCollectionView *collectionView;
// 当前控制器
@property (strong, nonatomic, readonly) UIViewController<SFScrollPageViewChildVcDelegate> *currentChildVc;

/**初始化方法
 *
 */
- (instancetype)initWithFrame:(CGRect)frame segmentView:(SFScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<SFScrollPageViewDelegate>) delegate;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;
/** 给外界 重新加载内容的方法 */
- (void)reload;


@end
