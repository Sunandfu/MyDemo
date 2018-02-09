//
//  SJAvatarBrowser.h
//  zhitu
//
//  Created by 陈少杰 QQ：417365260 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
@interface SJAvatarBrowser : NSObject

/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像所在的imageView
 *****************代码示例************************
//为对象图片添加手势
 UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
 
 [self.imageView addGestureRecognizer:tap];
 
 - (void)magnifyImage
 {
 NSLog(@"局部放大");
 [SJAvatarBrowser showImage:self.imageView];//调用方法
 }
 *************************************************
 */
+(void)showImage:(UIImageView*)avatarImageView;
+(void)showImageDetail:(UIImage *)avatarImageView;
@end
