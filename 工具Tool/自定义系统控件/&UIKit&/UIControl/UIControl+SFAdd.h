//
//  UIControl+SFAdd.h
//  SFKitDemo
//
//  Created by renbo on 2018/5/17.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (SFAdd)
/** 多少秒后可以继续响应事件（防止UI控件短时间多次激活事件） */
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;

@end
