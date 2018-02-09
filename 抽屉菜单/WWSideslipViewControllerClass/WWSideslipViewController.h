//
//  WWSideslipViewController.h
//  WWSideslipViewControllerSample
//
//  Created by 王维 on 14-8-26.
//  Copyright (c) 2014年 wangwei. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface WWSideslipViewController : UIViewController{
@private
    UIViewController * leftControl;
    UIViewController * mainControl;
    UIViewController * righControl;
    
    UIImageView * imgBackground;
    
    CGFloat scalef;
}


//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (assign,nonatomic) CGFloat speedf;

//是否允许点击视图恢复视图位置。默认为yes
@property (strong) UITapGestureRecognizer *sideslipTapGes;

//初始化
-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
                   andRightView:(UIViewController *)RighView
                    andBackgroundImage:(UIImage *)image;


//恢复位置
-(void)showMainView;

//显示左视图
-(void)showLeftView;

//显示右视图
-(void)showRighView;



@end
