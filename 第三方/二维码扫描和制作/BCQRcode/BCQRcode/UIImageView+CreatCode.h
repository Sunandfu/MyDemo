//
//  UIImageView+CreatCode.h
//  BCQRcode
//
//  Created by Jack on 16/4/20.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CreatCode)
/**
 这里传入二维码的信息,image是加载二维码上方的图片,如果不要图片直接codeImage为nil即可,后面是图片的圆角
 */
- (void)creatCode:(NSString *)codeContent Image:(UIImage *)codeImage andImageCorner:(CGFloat)imageCorner;

@end
