//
//  JCKeyBoardNum.h
//  JCKeyBoard
//
//  Created by QB on 16/4/26.
//  Copyright © 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  说明
 *
 *  1.此demo只是为了方便学习，如有问题，欢迎指正
 *  2.demo中的block块和属性 show 必须调用
 *
 *
 */


typedef void (^JCCompletedBlock)(NSString *btnText,NSInteger btnTag);

@interface JCKeyBoardNum : UIView


//1 为普通数字键盘  0 为安全支付随机键盘  默认为支付键盘
@property (nonatomic, getter=isNormolNumber) BOOL normolNumber;
/**
 *  隐藏键盘
 */
- (void)dismiss;

/**
 *  类方法
 */

+(instancetype)allocNew;

- (void)show;
/**
 *  block
 */

@property (nonatomic, copy) JCCompletedBlock completeBlock;

@end
