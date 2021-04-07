//
//  ZQAutoReadToolBar.h
//  ZQAutoReadBook
//
//  Created by zzq on 2018/9/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutoReadToolBarDelegate <NSObject>

- (void)speedLow:(CGFloat)speed;
- (void)speedUp:(CGFloat)speed;
- (void)endAutoRead;

@end

@interface ZQAutoReadToolBar : UIView

@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, weak) id<AutoReadToolBarDelegate> delegate;

@end
