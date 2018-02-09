//
//  ZQResignVC.h
//  传值的几种方法
//
//  Created by lin zhi qing on 16/3/28.
//  Copyright © 2016年 linzhiqing. All rights reserved.
//

#import <UIKit/UIKit.h>
// block格式: 返回值(^block名字)(参数)
// (1)定义block
typedef void(^myBlcok)(NSArray *array);
@interface ZQResignVC : UIViewController
// (2)申明block属性
@property (strong, nonatomic) myBlcok block;
-(void)sendMessage:(myBlcok)block;
@end
