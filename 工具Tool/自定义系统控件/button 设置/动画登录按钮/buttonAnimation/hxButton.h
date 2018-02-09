//
//  hxButton.h
//  zongjie
//
//  Created by 黄鑫 on 16/4/14.
//  Copyright © 2016年 hx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseView.h"

@interface hxButton : UIButton

/** 是否在加载*/
@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, retain)baseView *hxView;
@property(nonatomic, retain)UIColor *contentColor;
@property(nonatomic, retain)UIColor *progressColor;

@property(nonatomic, retain)UIButton *forDisplayButton;

- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor*)color;
/*
 self.hxbt = [[hxButton alloc] initWithFrame:CGRectMake(100, 200, 140, 36) withColor:[self getColor:@"e13536"]];
 [self.hxbt.forDisplayButton setTitle:@"微信注册" forState:UIControlStateNormal];
 [self.hxbt.forDisplayButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
 [self.hxbt.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [self.hxbt.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
 [self.hxbt.forDisplayButton setImage:[UIImage imageNamed:@"微信logo@2x.png"] forState:UIControlStateNormal];
 
 [self.hxbt addTarget:self action:@selector(btnEvent) forControlEvents:UIControlEventTouchUpInside];
 [self.view addSubview:self.hxbt];
 */
@end
