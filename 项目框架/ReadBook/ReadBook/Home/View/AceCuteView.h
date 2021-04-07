//
//  AceCuteView.h
//  LayerDemo1
//
//  Created by AceWei on 16/3/9.
//  Copyright © 2016年 AceWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AceCuteView : UIView

/**
 *  显示文字
 */
@property (nonatomic,strong)NSString *bubbleText;

/**
 *  背景颜色
 */
@property UIColor *bgColor;


/**
 *  黏性距离，不设置默认50，允许设置范围30~90
 */
@property CGFloat viscosity;

@end
