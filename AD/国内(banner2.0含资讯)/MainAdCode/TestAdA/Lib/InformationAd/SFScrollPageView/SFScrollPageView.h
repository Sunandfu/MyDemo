//
//  SFScrollPageView.h
//  SFScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SFFrame.h"
#import "SFContentView.h"
#import "SFTitleView.h"


@interface SFScrollPageView : UIView
typedef void(^ExtraBtnOnClick)(UIButton *extraBtn);

@property (copy, nonatomic) ExtraBtnOnClick extraBtnOnClick;
@property (weak, nonatomic, readonly) SFContentView *contentView;
@property (weak, nonatomic, readonly) SFScrollSegmentView *segmentView;

/** 必须设置代理并且实现相应的方法*/
@property(weak, nonatomic)id<SFScrollPageViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(SFSegmentStyle *)segmentStyle titles:(NSArray<NSString *> *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<SFScrollPageViewDelegate>) delegate ;

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/**  给外界重新设置的标题的方法(同时会重新加载页面的内容) */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles;
@end
