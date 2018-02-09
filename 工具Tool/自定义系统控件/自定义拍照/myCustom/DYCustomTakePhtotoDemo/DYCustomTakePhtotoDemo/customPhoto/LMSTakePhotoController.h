//
//  LMSTakePhotoController.h
//  LetMeSpend
//
//  Created by 袁斌 on 16/3/10.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TakePhotoPosition)
{
    TakePhotoPositionBack = 0,
    TakePhotoPositionFront
};


@protocol  LMSTakePhotoControllerDelegate<NSObject>

@optional
- (void)didFinishPickingImage:(UIImage *)image;

@end


@interface LMSTakePhotoController : UIViewController


@property (nonatomic,weak)id<LMSTakePhotoControllerDelegate> delegate;

@property (nonatomic,assign)TakePhotoPosition position;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com