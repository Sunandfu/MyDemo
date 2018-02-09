//
//  LSCutImage.h
//

#import <UIKit/UIKit.h>

@interface LSCutImage

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
//绘制layer截图
+ (UIImage *)captureView:(UIView *)view;
//绘制View截图
+ (UIImage *)snapshotScreenInView:(UIView *)contentView;

@end
