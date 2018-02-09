//
//  DXStatusBarHUD.m
//  JS-网易新闻案例
//
//  Created by xiongdexi on 16/3/5.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import "DXStatusBarHUD.h"

// 定义全局的window
UIWindow *_window;

#define DXWindowHeight 20   // 提示框的高度
#define DXDuration 1.0      // 动画执行的时间
#define DXDelay 1.0         // 提示窗口停留的时间
#define DXFont [UIFont systemFontOfSize:12] // 字体大小

@implementation DXStatusBarHUD

/**
 *  显示加载
 *
 *  @param msg 文字信息
 */
+ (void)showLoading:(NSString *)msg {
    if (_window) return;
    // 创建窗口
    _window = [[UIWindow alloc] init];
    _window.backgroundColor = [UIColor blackColor];
    _window.windowLevel = UIWindowLevelAlert;
    _window.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, -DXWindowHeight);
    _window.hidden = NO;
    
    // 文字
    UILabel *label = [[UILabel alloc] init];
    label.frame = _window.bounds;
    label.font = DXFont;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [_window addSubview:label];
    
    // 加载指示器
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView startAnimating]; // 开启动画
    indicatorView.frame = CGRectMake(20, 0, DXWindowHeight, DXWindowHeight);
    [_window addSubview:indicatorView];
    
    // 动画效果
    [UIView animateWithDuration:DXDuration animations:^{
        CGRect frame = _window.bounds;
        frame.origin.y = 0;
        _window.frame = frame;
    }];

}
/**
 *  隐藏加载窗口
 */
+ (void)hideLoading {
    // 动画效果
    [UIView animateWithDuration:DXDuration animations:^{
        CGRect frame = _window.bounds;
        frame.origin.y = -DXWindowHeight;
        _window.frame = frame;
    } completion:^(BOOL finished) {
        _window = nil;
    }];

}

/**
 *  显示信息
 *
 *  @param msg   文字内容
 *  @param image 图片对象
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image {
    // 解决重复调用的问题
    if (_window) return;
    
    // 使用button来展示 使用自定义button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor grayColor];
    btn.titleLabel.font = DXFont;
    // 设置文字的内边距,让显示有一点空隙
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    // 设置数据
    [btn setTitle:msg forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    // 获取主窗口
    _window = [[UIWindow alloc] init];
    _window.windowLevel = UIWindowLevelAlert; // 设置优先层级
    _window.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, -DXWindowHeight);
    btn.frame = _window.bounds;
    
    [_window addSubview:btn];
    _window.hidden = NO;
    
    // 动画
    [UIView animateWithDuration:DXDuration animations:^{
        CGRect frame = _window.frame;
        frame.origin.y = 0;
        _window.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:DXDuration delay:DXDelay options:kNilOptions animations:^{
            CGRect frame = _window.frame;
            frame.origin.y = -DXWindowHeight;
            _window.frame = frame;
        } completion:^(BOOL finished) {
            _window = nil;
        }];
    }];


}

/**
 *  显示信息
 *
 *  @param msg     文字内容
 *  @param imgName 图片名称 (图片高度最好在 20 以内, 仅限于本地图片)
 */
+ (void)showMessage:(NSString *)msg imgName:(NSString *)imgName {
    [self showMessage:msg image:[UIImage imageNamed:imgName]];
}

/**
 *  显示成功信息: 传入需要展示信息的文字字符串
 */
+ (void)showSuccess:(NSString *)msg {
    [self showMessage:msg imgName:@"DXStatusBarHUD.bundle/success"];
}

/**
 *  显示失败的信息: 传入需要展示信息的文字字符串
 */
+ (void)showError:(NSString *)msg {
    [self showMessage:msg imgName:@"DXStatusBarHUD.bundle/error"];
}



@end
