//
//  ZMEditPersonView.h
//  ZMAddressBook
//
//  Created by ZengZhiming on 2017/4/11.
//  Copyright © 2017年 菜鸟基地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMPersonModel.h"

@interface ZMEditPersonView : UIView

/**
 显示修改View
 
 @param personModel 修改前数据
 @param submitBlock 修改后回调
 */
- (void)showView:(ZMPersonModel *)personModel submitBlock:(void (^)(int code, ZMPersonModel *personModel))submitBlock;

/** 移除View */
- (void)dismissView;

@end
