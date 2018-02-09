//
//  TYCircleProtocol.h
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYCircleProtocol <NSObject>

@optional
/**
 *  点击之后是否隐藏menu,YES为隐藏，NO为不隐藏
 *  默认不隐藏
 */
@property (nonatomic,assign) BOOL isDismissWhenSelected;

/**
 *  可见的item数量
 *  默认为4个
 */
@property (nonatomic,assign) unsigned int visibleNum;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com