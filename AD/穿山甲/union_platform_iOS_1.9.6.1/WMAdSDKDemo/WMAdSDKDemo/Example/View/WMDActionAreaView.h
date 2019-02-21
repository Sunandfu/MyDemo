//
//  WMDActionAreaView.h
//  WMDemo
//
//  Created by carl on 2017/12/4.
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WMDActionAreaView : UIView
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *actionButton;

- (void)configWitModel:(id)model;
@end
