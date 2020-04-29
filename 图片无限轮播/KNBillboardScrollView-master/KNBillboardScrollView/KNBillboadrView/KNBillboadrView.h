//
//  KNBillboadrView.h
//  KNBillboardScrollView
//
//  Created by 刘凡 on 2017/11/14.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage/YYImage.h>

@class KNBillboadrView;
//pageControll的显示位置
typedef NS_ENUM(NSInteger, KNPageControllPostion){
    KNPostionDefalut, //默认值 ==  PostionCenter
    KNPostionHide,      //隐藏控件
    KNPostionBottomLeft, //右下
    KNPostionBottomRtight,//左下
    KNPostionBottomCenter //中下
};


//gif播放方式
typedef NS_ENUM(NSInteger, KNGifPlayMode) {
    KNGifPlayModeAlways,          //始终播放
    KNGifPlayModeNever,           //从不播放
    KNGifPlayModePauseWhenScroll  //切换图片时不播放
};


//图片切换方式
typedef NS_ENUM(NSInteger, KNChangeMode){
    KNChangeModeDefault, //轮播滚动
    KNChangeModeFade //淡入淡出
};

@protocol KNBillboadrViewDelegate <NSObject>


/**
 该方法用来处理图片的点击，会返回图片在数组中的索引
 
 @param BillboadrView 控件本身
 @param index 当前点击图片的下标
 */
-(void)KNBillboadrView:(KNBillboadrView *)BillboadrView ClickImageForIndex:(NSInteger )index;

@end




@interface KNBillboadrView : UIView



#pragma mark - 方法
/**
 创建轮播View

 @param frame rect.位置设置大小
 @param imageArray 图片数组
 @param descArray 描叙数组,可为空,为空情况不显示描叙文字
 @param placeholdImage 默认图。网络图片没加载出来的时候使用
 */
-(instancetype)initKNBillboadrViewWithFrame:(CGRect )frame andImageArray:(NSArray *)imageArray andDescArray:(NSArray *)descArray andplaceholdImage:(UIImage *)placeholdImage;



/**
 创建轮播图

 @param frame 设置位置大小
 @param placeholdImage 默认图
 @return 轮播图
 */
-(instancetype)initKNBillboadrViewWithFrame:(CGRect )frame andplaceholdImage:(UIImage *)placeholdImage;



/**
 设置图片标签

 @param imageArray 设置图片数组
 @param descArray 设置标题数组
 */
-(void)setImageArray:(NSArray *)imageArray andDescArray:(NSArray *)descArray;


/**
 设置分也控件指示颜色
 
 @param color 其他页码颜色
 @param currentColor 当前页面的颜色
 */
-(void)setPageColor:(UIColor *)color andCurrentPageColor:(UIColor *)currentColor;


/**
 设置页码控件指示图片
 
 @param image 其他页码图片
 @param currentImage 当前页码图片
 */
-(void)setPageImage:(UIImage *)image andCurrentPageImage:(UIImage *)currentImage;

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
 清理沙盒中图片缓存
 */
+(void)clearDiskCache;

#pragma mark - 基本属性
///设置图片切换模式. 默认为KNChangeModeDefalut;
@property(nonatomic, assign)KNChangeMode KNChangeMode;

///设置图片内容模式, 默认为UIViewContentModeScaleToFill
@property(nonatomic, assign)UIViewContentMode contentMode;

///设置分页控件位置, 默认为PositionBottomCenter/一张图片时隐藏
@property(nonatomic, assign)KNPageControllPostion KNPageCotrollPostion;

//设置gif播放的方式//默认为KNGifPlayModeAlways.
@property(nonatomic, assign)KNGifPlayMode gifPlayMode;


///属性无法满足。自行设置分页的Positio
@property(nonatomic, assign)CGPoint pageOffset;



/**
 *  每一页停留时间，默认为3s，最少1s
 *  当设置的值小于1s时，则为默认值
 */
@property (nonatomic, assign) NSTimeInterval time;

///设置图片描叙的颜色 默认白色字体
@property(nonatomic, strong)UIColor *DescLableColor;

///设置图片描叙的字体大小 默认字体大小13
@property(nonatomic, strong)UIFont *DescLableFont;

///设置描叙的字体背景颜色 默认为 [UIColor colorWithWhite:0 alpha:0.5];
@property(nonatomic, strong)UIColor *DescLableBackgroundColor;

///设置自动缓存. 默认为打开
@property(nonatomic, assign)BOOL autoCache;

@property(nonatomic, weak) id<KNBillboadrViewDelegate> delegate;

@end
