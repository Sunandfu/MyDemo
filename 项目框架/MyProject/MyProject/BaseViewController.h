//
//  BaseViewController.h
//  MyProject
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//判断是否是push过去的，默认为是 model ＝ NO
@property (nonatomic, getter = isModal) BOOL modal;

@property (nonatomic, weak) UIButton *rightButton;

@property (strong, nonatomic) NSArray *navRightItems;
@property (nonatomic, copy) NSString *name;

//获得类名
-(NSString *) getCurrentClassName;

-(void)initViewBackgroundColor;

//left button
-(void)initNavigationLeftButton:(NSString*)_buttonImage;

//nav right button
-(void)initNavigationRightButton:(NSString*)_btTitle btWidth:(float)_btWidth;

-(void)backButtonTouchEvents;  //左侧返回按钮
-(void)rightButtonTouchEvents; //右侧按钮点击   子类重写

@end
