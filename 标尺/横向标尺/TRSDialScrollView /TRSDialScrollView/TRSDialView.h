/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import <UIKit/UIKit.h>

@interface TRSDialView : UIView <UIAppearance>

#pragma mark - Methods

/**
 * 设置值得显示范围
 */
- (void)setDialRangeFrom:(NSInteger)from to:(NSInteger)to;

#pragma mark - Dial Properties

@property (assign, readonly, nonatomic) NSInteger leading;

/**
 * The maximum value to display in the dial
 */
@property (assign, readonly, nonatomic) NSInteger minimum;

/**
 * The minimum value to display in the dial
 */
@property (assign, readonly, nonatomic) NSInteger maximum;


#pragma mark - Minor Tick Properties

/**
 * 小蜱的颜色
 */
@property (strong, nonatomic) UIColor *minorTickColor;

/**
 * The length of the minor ticks
 */
@property (assign, nonatomic) CGFloat minorTickLength;

/**
 * The length of the Major Tick
 */
@property (assign, nonatomic) CGFloat minorTickWidth;

#pragma mark - Major Tick Properties

/**
 * 大蜱的颜色
 */
@property (strong, nonatomic) UIColor *majorTickColor;
/**
 * 中蜱的颜色
 */
@property (strong, nonatomic) UIColor *secondTickColor;

/**
 * The length of the Major Tick
 */
@property (assign, nonatomic) CGFloat majorTickLength;

/**
 * 大蜱的宽度
 */
@property (assign, nonatomic) CGFloat majorTickWidth;
/**
 * 小蜱的数量
 */
@property (assign, nonatomic) NSInteger minorTicksPerMajorTick;

/**
 * 小蜱的像素点/分
 */
@property (assign, nonatomic) NSInteger minorTickDistance;

/**
 * The image to use as the background image
 */
@property (strong, nonatomic) UIColor *backgroundColor;

#pragma mark - Tick Label Properties

/**
 * 所写文字的颜色
 */
@property (strong, nonatomic) UIColor *labelStrokeColor;

/**
 * 所写文字的宽度
 */
@property (assign, nonatomic) CGFloat labelStrokeWidth;

/**
 * 填充颜色
 */
@property (strong, nonatomic) UIColor *labelFillColor;

/**
 * 文字大小
 */
@property (strong, nonatomic) UIFont *labelFont;

#pragma mark - Shadow Properties

/**
 * 阴影颜色
 */
@property (strong, nonatomic) UIColor *shadowColor;

/**
 * 阴影 offset
 */
@property (assign, nonatomic) CGSize shadowOffset;

/**
 * 阴影模糊半径
 */
@property (assign, nonatomic) CGFloat shadowBlur;

@end
