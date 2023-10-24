//
//  SFFocusImage.h
//  AdDemo
//
//  Created by lurich on 2021/6/11.
//

#import <UIKit/UIKit.h>

@class SFFocusImage;

typedef enum {
    SFBannerScrollViewPageContolAlimentRight,
    SFBannerScrollViewPageContolAlimentCenter,
    SFBannerScrollViewPageContolAlimentLeft
} SFBannerScrollViewPageContolAliment;

typedef enum {
    SFBannerScrollViewPageContolStyleClassic,        // 系统自带经典样式
    SFBannerScrollViewPageContolStyleAnimated,       // 动画效果--直接显示
    SFBannerScrollViewPageControlHorizontal,         // 水平动态滑块
    SFBannerScrollViewPageImageRotation,             // 旋转前进
    SFBannerScrollViewPageImageJump,                 // 以半圆跳跃前进
    SFBannerScrollViewPageImageAnimated,             // 动画滑动前进
    SFBannerScrollViewPageContolStyleNone            // 不显示pagecontrol
} SFBannerScrollViewPageContolStyle;

//pageControll的显示位置
typedef NS_ENUM(NSInteger, SFPageControllPostion){
    SFPostionBottomCenter = 0,  //中下
    SFPostionBottomRight = 1,   //右下
    SFPostionBottomLeft = 2,    //左下
    SFPostionHide = 3,          //隐藏控件
};


//图片切换方式
typedef NS_ENUM(NSInteger, SFChangeMode){
    SFChangeModeDefault, //轮播滚动
    SFChangeModeFade //淡入淡出
};

@protocol SFFocusImageDelegate <NSObject>

@optional
/*
 该方法用来处理图片的点击，会返回图片在数组中的索引
 @param index 当前点击图片的下标
 */
- (void)tapFocusWithIndex:(NSInteger)index;
/*
 * 该方法会返回当前显示的图片在数组中的索引
 * @param index 图片的下标
 */
- (void)loopFocusWithIndex:(NSInteger)index;

@end




@interface SFFocusImage : UIView



#pragma mark - 方法
/**
 设置视图数组

 @param viewArray 视图数组
 */
- (void)reloadWithViews:(NSArray<UIView *> *)viewArray;

/**
 打开定时器,默认打开
  调用该方法会重新开启
 */
-(void)startTimer;

/**
 停止定时器
 */
-(void)stopTimer;

/**
 刷新大小
 */
- (void)reloadSize;

#pragma mark - 基本属性
///设置图片切换模式. 默认为SFChangeModeDefalut;
@property(nonatomic, assign)SFChangeMode changeMode;

///属性无法满足。自行设置分页的Positio
@property(nonatomic, assign)CGPoint pageOffset;

/**
 *  自动滚动间隔时间,默认3s
 *  每一页停留时间，默认为3s，最少1s
 *  当设置的值小于1s时，则为默认值
 */
@property (nonatomic, assign) NSTimeInterval time;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;

/** pagecontrol 样式，默认为SFBannerScrollViewPageContolStyleClassic */
@property (nonatomic, assign) SFBannerScrollViewPageContolStyle pageControlStyle;
/** 分页控件位置 */
@property (nonatomic, assign) SFBannerScrollViewPageContolAliment pageControlAliment;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;


@property(nonatomic, weak) id<SFFocusImageDelegate> delegate;

@end
