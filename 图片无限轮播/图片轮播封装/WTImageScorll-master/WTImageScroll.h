//
//  WTImageScroll.h
// 
//
//  Created by netvox-ios1 on 16/4/14.
//  Copyright © 2016年 netvox-ios1. All rights reserved.
//  

#import <UIKit/UIKit.h>

typedef enum{
    
    ImageShowStyleLocation=0,
    ImageShowStyleNetwork=1
    
}ImageShowStyle;

typedef void (^BtnClickBlock)(NSInteger tagValue);

@interface WTImageScroll : UIView<UIScrollViewDelegate>

/**
 *显示本地图片
 *rect:在父视图中的位置
 *array:加载的图片数组
 *btnClick:点击图片回调
 */
+(UIView *)ShowLocationImageScrollWithFream:(CGRect)rect andImageArray:(NSArray *)array andBtnClick:(BtnClickBlock)btnClick ;

/**
 *显示网络图片
 *rect:在父视图中的位置
 *array:加载的图片数组--(网络图片地址)
 *btnClick:点击图片回调
 */
+(UIView *)ShowNetWorkImageScrollWithFream:(CGRect)rect andImageArray:(NSArray *)array andBtnClick:(BtnClickBlock)btnClick ;

/**
 *清理网络缓存到内存中的图片
 */
+(void)clearNetImageChace;

@end
