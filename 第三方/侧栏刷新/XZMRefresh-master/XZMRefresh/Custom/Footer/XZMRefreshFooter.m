

//
//  XZMRefreshFooter.m
//  XZMRefreshExample
//
//  Created by 谢忠敏 on 16/1/23.
//  Copyright © 2016年 com.xiaomage.new. All rights reserved.
//

#import "XZMRefreshFooter.h"

@implementation XZMRefreshFooter
+ (instancetype)footer
{
    return [[self alloc] init];
}

- (void)setStateHidden:(BOOL)stateHidden
{
    _stateHidden = stateHidden;
    
    self.statusLabel.hidden = stateHidden;
    [self setNeedsLayout];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com