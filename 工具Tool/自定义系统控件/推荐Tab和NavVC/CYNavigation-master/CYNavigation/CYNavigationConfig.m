//
//  CYNavigationConfig.m
//  JKSDoctor
//
//  Created by 张 春雨 on 2017/5/4.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "CYNavigationConfig.h"

@implementation CYNavigationConfig

+ (instancetype)shared{
    static CYNavigationConfig *config = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        config = [[CYNavigationConfig alloc]init];
        //bar的高度
        config.height = 64.0;
        
        //bar的背景颜色
        config.backgroundColor = [UIColor blueColor];
        
        //是否存在bar底部分割线
        config.haveBorder = YES;
        
        //bar的底部分割线颜色
        config.bordergColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        
        //bar底部分割线的高度
        config.borderHeight = 1.0;
        
        //bar上的字体颜色
        config.fontColor = [UIColor blackColor];
        
        //默认返回图标
        config.defaultBackImage = [UIImage imageNamed:@"CYNavigation.bundle/navigationbar_back_light"];
        
        //标题字体
        config.titleFont = [UIFont systemFontOfSize:18.0];
        
        //其他字体
        config.outherFont = [UIFont systemFontOfSize:17.0];
        
        //返回驱动手势
        config.backGesture = ^UIPanGestureRecognizer *{
            UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc]init];
            [gesture setEdges:UIRectEdgeLeft];
            return gesture;
        };
        
        //过渡动画类型
        config.transitionAnimationClass = NSClassFromString(@"NormalTransitionAnimation");
    });
    return config;
}


@end
