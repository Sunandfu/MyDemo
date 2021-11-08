//
//  UIImage+SFAdd.h
//  TransferPlatform
//
//  Created by lurich on 2021/9/16.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SFImageCombineType) {
    SFImageCombineHorizental,
    SFImageCombineVertical
};

/**
 *  对UIImage的扩展
 *
 */

@interface UIImage (SFAdd)

/**
 *  纠正图片的方向
 *
 */
- (UIImage *)sf_fixOrientation;


/**
 *  根据颜色生成纯色图片
 *
 */
+ (UIImage *)sf_imageWithColor:(UIColor *)color;

/**
 *  取图片某一像素的颜色
 *
 */
- (UIColor *)sf_colorAtPixel:(CGPoint)point;

/**
 *  获得灰度图
 *
 */
- (UIImage *)sf_convertToGrayImage;


/**
 *  用一个Gif生成UIImage
 *
 *  @param theData 传入一个GIFData对象
 */
+ (UIImage *)sf_animatedImageWithAnimatedGIFData:(NSData *)theData;

/**
 *  用一个Gif生成UIImage
 *
 *  @param theURL 传入一个GIF路径
 */
+ (UIImage *)sf_animatedImageWithAnimatedGIFURL:(NSURL *)theURL;

/**
 *  按给定的方向旋转图片
 *
 */
- (UIImage*)sf_rotate:(UIImageOrientation)orient;

/**
 *  垂直翻转
 *
 */
- (UIImage *)sf_flipVertical;

/**
 *  水平翻转
 *
 */
- (UIImage *)sf_flipHorizontal;


/**
 *  将图片旋转degrees角度
 *
 */
- (UIImage *)sf_imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  将图片旋转radians弧度
 *
 */
- (UIImage *)sf_imageRotatedByRadians:(CGFloat)radians;

/**
 * 截取当前image对象rect区域内的图像
 *
 */
- (UIImage *)sf_subImageWithRect:(CGRect)rect;

/**
 * 压缩图片至指定尺寸
 *
 */
- (UIImage *)sf_rescaleImageToSize:(CGSize)size;

/**
 * 压缩图片至指定像素
 *
 */
- (UIImage *)sf_rescaleImageToPX:(CGFloat)toPX;

/**
 * 在指定的size里面生成一个平铺的图片
 *
 */
- (UIImage *)sf_getTiledImageWithSize:(CGSize)size;


/**
 * UIView转化为UIImage
 *
 */
+ (UIImage *)sf_imageFromView:(UIView *)view;

/**
 * 将两个图片生成一张图片
 *
 */
+ (UIImage*)sf_mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/**
 * 图片模糊处理
 *
 */
- (UIImage *)sf_applyBlurWithRadius:(CGFloat)blurRadius
                          tintColor:(UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                          maskImage:(UIImage *)maskImage;

/**
* 缩放图片
*/
-(UIImage *)sf_scaleImageToSize:(CGSize)size;

/**
* 裁剪图片
*/
-(UIImage *)sf_clipImageWithClipRect:(CGRect)clipRect;

/**
* 拼接图片
*/
+(UIImage *)sf_combineWithImages:(NSArray *)images orientation:(SFImageCombineType)orientation;

/**
* 局部收缩
 UIImage *newImage1 = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 40, 30, 60) resizingMode:UIImageResizingModeTile];//取正中间一个点

 @param capInsets UIEdgeInsetsMake
 @param actualSize 显示大小
 @return 处理后的图片
 */
- (UIImage *)sf_shrinkImageWithCapInsets:(UIEdgeInsets)capInsets actualSize:(CGSize)actualSize;

@end
