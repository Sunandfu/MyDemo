//
//  BaseViewController.h
//  JinJiangInn
//
//  Created by xie aki on 12-11-2.
//  Copyright (c) 2012年 JJInn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController{

}

@property (assign, nonatomic) float tableViewMaxHeight;
@property (nonatomic, getter = isModal) BOOL modal;


@property (nonatomic, weak) UIButton *rightButton;
@property (strong, nonatomic) NSString *pageViewName;
@property (nonatomic, getter = isFirstLoad) BOOL firstLoad;

@property (strong, nonatomic) NSArray *navRightItems;


@property(nonatomic, strong) UIView *emptyView;


-(void)initViewBackgroundColor;

//left button
-(void)initNavigationLeftButton:(NSString*)_buttonImage;

//nav right button
-(void)backButtonTouchEvents;
-(void)rightButtonTouchEvents;
-(void)initNavigationRightButton:(NSString*)_btTitle btWidth:(float)_btWidth;

//custome autolayout
-(CGRect)customeLayout:(CGRect)rect;



//empty view
-(void)loadEmptyView:(NSString*)noteText;

//根据内容获取label宽度
-(float)getLabelDWidth:(UILabel*)label content:(NSString*)content;

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

-(void)showMessageTwoButton:(NSString*)_title message:(NSString*)_message delegate:(id)_delegate tag:(int)_tag title1:(NSString*)_title1 title2:(NSString*)_title2;
-(void)addItemWithCustomView:(NSArray *)arry isLeft:(BOOL)isLeft;

@end
