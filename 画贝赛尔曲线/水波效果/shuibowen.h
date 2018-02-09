//
//  shuibowen.h
//  wuxiangundongview
//
//  Created by 小富 on 16/5/4.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shuibowen : UIView

@property (nonatomic, assign) int num;
@property (nonatomic, assign) float beishu;
@property (nonatomic, strong) UIColor *colorName;

/**
 shuibowen *shuibo = [[shuibowen alloc]initWithFrame:CGRectMake(-10, 100, 500, 300)];
 [shuibo setNeedsDisplay];
 shuibo.num = 6;
 shuibo.beishu = 0.023;
 shuibo.colorName = [UIColor blueColor];
 shuibo.alpha = 0.3;
 shuibo.backgroundColor = [UIColor clearColor];
 [self.view addSubview:shuibo];
 
 shuibowen *shuibo2 = [[shuibowen alloc]initWithFrame:CGRectMake(-30, 110, 500, 290)];
 [shuibo2 setNeedsDisplay];
 shuibo2.num = 4;
 shuibo2.beishu = 0.025;
 shuibo2.colorName = [UIColor blueColor];
 shuibo2.alpha = 0.4;
 shuibo2.backgroundColor = [UIColor clearColor];
 [self.view addSubview:shuibo2];
 */

@end
