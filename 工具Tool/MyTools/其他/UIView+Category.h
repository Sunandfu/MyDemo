//
//  UIView+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)
/**
 *  截屏,截取当前view的快照
 */
- (UIImage *)snapshotImage;

/**
 *  截屏,是否在当前view渲染完毕后再截屏
 */
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
/**
 *  设置view的阴影
 */
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 返回当前view的控制器,有可能是空
 */
@property (nonatomic, readonly) UIViewController *viewController;
/**
 *  一个点 从当前坐标系迁移到另一个view或window上的坐标系
 */
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view;

/**
 *  一个点 从另一个view或window坐标系上点迁移到当前view的坐标系
 */
- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;

/**
 *  一个rect 从当前坐标系迁移到另一个view或window上的坐标系
 */
- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(UIView *)view;


/**
 *  一个rect 从另一个view或window坐标系上点迁移到当前view的坐标系
 */
- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view;
    
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.
@end
