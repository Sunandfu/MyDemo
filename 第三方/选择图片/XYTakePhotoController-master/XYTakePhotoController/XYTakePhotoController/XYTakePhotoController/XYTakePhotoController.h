//
//  XYTakePhotoController.h
//  XYTakePhotoController
//
//  Created by 渠晓友 on 2020/3/29.
//  Copyright © 2020 渠晓友. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYTakePhotoMode) {
    XYTakePhotoModeSingleFront, ///< 拍摄一张正面
    XYTakePhotoModeSingleBack,  ///< 拍摄一张反面
    XYTakePhotoModeFrontRear,   ///< 拍摄两张正反面
};

@interface XYTakePhotoController : UIViewController

/// 推出拍照控制器去拍摄图片
/// @param fromVC 从哪个控制器推出
/// @param mode 拍照模式
/// @param reslutHandler 拍照结果，若有 errorMsg 则拍照失败，反之拍照成功正确返回images
+ (void)presentFromVC:(UIViewController*)fromVC
                 mode:(XYTakePhotoMode)mode
        resultHandler:(void(^)(NSArray <UIImage *> *images, NSString *errorMsg))reslutHandler;

@end

NS_ASSUME_NONNULL_END
