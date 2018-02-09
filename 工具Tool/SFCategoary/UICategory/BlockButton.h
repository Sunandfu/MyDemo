//
//  BlockButton.h
//  customButton
//
//  Created by 冯亮 on 16/5/6.
//  Copyright © 2016年 冯亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^DGCompletionHandler)(UIButton *sender);
@interface  BlockButton: UIButton
/**
 *  按钮以block样式返回的触发方法
 *
 *  @param controlEvents UIControlEvents
 *  @param completion    响应的回调
 */
- (void)addActionforControlEvents:(UIControlEvents)controlEvents respond:(DGCompletionHandler)completion;
@end
