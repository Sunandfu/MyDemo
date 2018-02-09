//
//  ImageCropViewController.h
//  ptcommon
//
//  Created by 李超 on 16/6/8.
//  Copyright © 2016年 PTGX. All rights reserved.
//

#import "UIKit/UIKit.h"

@interface PTImageCropVC : UIViewController

/**
 *  @author fangbmian, 16-06-12 09:06:49
 *
 *  初始化
 *
 *  @param image         被裁剪照片
 *  @param cropScale     裁剪比例（高/宽）0:任意比例
 *  @param complentBlock 完成回调
 *  @param cancelBlock   取消回调
 *
 *  @return self
 */
- (instancetype)initWithImage:(UIImage*)image withCropScale:(CGFloat)cropScale complentBlock:(void (^)(UIImage* image))complentBlock cancelBlock:(void (^)(id sender))cancelBlock;

@end
