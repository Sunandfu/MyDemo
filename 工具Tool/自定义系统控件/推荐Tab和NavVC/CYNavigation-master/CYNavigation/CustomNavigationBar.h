//
//  NavigationBar.h
//  智能大棚
//
//  Created by 张春雨 on 16/8/15.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYNavigationConfig.h"
@interface CustomNavigationButton : UIButton
+ (instancetype)initWithType:(NSInteger)type;
@end

@interface CustomNavigationBar : UIView
/** 中间标题 */
@property (weak , nonatomic)UILabel *title;
/** 左按钮 */
@property (weak , nonatomic)CustomNavigationButton *leftBtn;
/** 右按钮 */
@property (weak , nonatomic)CustomNavigationButton *rightBtn;
/** 底部分割线 */
@property (nonatomic,weak) CAShapeLayer *border;

- (void)customNavigationLabelColor:(UIColor *)color;

@end



