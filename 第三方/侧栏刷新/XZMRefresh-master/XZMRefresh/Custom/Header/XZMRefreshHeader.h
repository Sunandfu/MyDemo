//
//  XZMRefreshHeader.h
//  XZMRefreshExample
//
//  Created by 谢忠敏 on 16/1/23.
//  Copyright © 2016年 com.xiaomage.new. All rights reserved.
//

#import "XZMBaseRefreshView.h"

@interface XZMRefreshHeader : XZMBaseRefreshView
+ (instancetype)header;

#pragma 交给子类去实现
#pragma mark - 文字控件的可见性处理
/** 是否隐藏状态标签 */
@property (assign, nonatomic, getter=isStateHidden) BOOL stateHidden;
/** 是否隐藏刷新时间标签 */
@property (assign, nonatomic, getter=isUpdatedTimeHidden) BOOL updatedTimeHidden;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com