//
//  BlueToothViewTipView.h
//  HBGuard
//
//  Created by 李帅 on 16/1/21.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueToothViewTipView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong)UILabel *tipLabel;

+ (void)showAlertWithStr:(NSString*)string;
+ (void)showWithTitle:(NSString*)title;
+ (void)dismiss;

+ (BlueToothViewTipView *)sharedManager;

@end
