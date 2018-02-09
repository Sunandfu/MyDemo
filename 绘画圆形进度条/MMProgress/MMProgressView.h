//
//  MMProgressView.h
//  MMprogressView
//
//  Created by imac on 16/4/25.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMProgressView : UIView
/** 进度条后景颜色 */
@property(nonatomic,strong)UIColor*trackColor;
/** 进度条前景颜色 */
@property(nonatomic,strong)UIColor*progressColor;
/** 进度条宽度 */
@property(nonatomic,assign)CGFloat progressWidth;
/** 0-1的浮点数 */
@property(nonatomic,assign)CGFloat percent;

+ (instancetype )progressViewWithFrame:(CGRect )frame percent:(CGFloat )percent;
/*
 // percent 初始比例
 MMProgressView *progress = [MMProgressView progressViewWithFrame:CGRectMake(100, 100, 100, 100) percent:0.7];
 self.progress = progress;
 [self.view addSubview:progress];
 progress.trackColor = [UIColor orangeColor];//圆环背景颜色
 progress.progressColor = [UIColor blueColor];//圆环颜色
 progress.progressWidth = 10.0;
 self.progress.percent = 0.2;//设置绘制比例
 */
@end
