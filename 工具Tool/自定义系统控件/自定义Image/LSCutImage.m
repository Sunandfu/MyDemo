//
//  LSCutImage.m
//

#import "LSCutImage.h"

@implementation LSCutImage

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView
{
    UIImage * image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [UIScreen mainScreen].scale);
    
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)captureView:(UIView *)view
{
    UIImage * image = nil;
    /*
     size:为新创建的位图上下文的大小，它同时是由UIGraphicsGetImageFromCurrentImageContext函数返回的图形大小。
     该函数的功能同UIGraphicsBeginImageContextWithOptions的功能相同，相当于UIGraphicsBeginImageContextWithOptions的opaque参数为NO,scale因子为1.0。
     UIGraphicsBeginImageContext(<#CGSize size#>)
     
     opaque:透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
     scale:缩放因子
     UIGraphicsBeginImageContextWithOptions(<#CGSize size#>, <#BOOL opaque#>, <#CGFloat scale#>)
     */
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)snapshotScreenInView:(UIView *)contentView
{
    UIImage * image = nil;
    CGRect rect = contentView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    //自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates:它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
