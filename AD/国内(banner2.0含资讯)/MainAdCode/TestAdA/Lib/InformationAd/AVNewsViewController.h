//
//  AVNewsViewController.h
//  TestAdA
//
//  Created by lurich on 2019/7/22.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AVNewsControllerDelegate <NSObject>

@optional;
//仅在半屏接入时有效，以方便客户添加 数据加载动画 HUD
- (void)newsDataRefreshSuccess;
- (void)newsDataRefreshFail:(NSError *)error;

@end

@interface AVNewsViewController : UIViewController

/** 必传参数 **/
// 控制滑动传递的 BOOL 值
@property (nonatomic, assign) BOOL vcCanScroll;
// 内容位 ID
@property (nonatomic, copy) NSString *mLocationId;

//回调代理
@property(weak, nonatomic)id<AVNewsControllerDelegate> delegate;

- (void)refreshNewsData;

@end

NS_ASSUME_NONNULL_END
