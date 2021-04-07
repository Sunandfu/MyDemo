//
//  ZQAutoReadViewController.h
//  ZQAutoReadBook
//
//  Created by zzq on 2018/9/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQAutoViewDelegate <NSObject>

- (void)finishReadPage:(UIViewController *)controller;

@end

@interface ZQAutoReadViewController : UIViewController

@property (nonatomic, weak) id<ZQAutoViewDelegate> delegate;

- (void)updateWithView:(UIImage *)image;
- (void)startAuto;

@end
