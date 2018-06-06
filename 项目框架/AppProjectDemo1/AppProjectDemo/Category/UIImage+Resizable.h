//
//  UIImage+Resizable.h
//  WristBand
//
//  Created by tuner168-ios on 15/9/26.
//  Copyright © 2015年 JayZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizable)

+ (instancetype)resizableWithImageName:(NSString *)imageName;
/**
 *  返回提供的颜色的image
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  返回所提供的颜色与尺寸的图片
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/**
 *  image 按照指定size缩放
 *
 *  @param image 需要缩放的图片
 *  @param size  缩放size
 *
 *  @return 缩放后的image
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(CGSize)size;

@end
