
//  Created by 小富 on 16/4/1.
//  Copyright © 2016年 yunxiang. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SFDialView : UIView <UIAppearance>

#pragma mark - Methods

/**
 * Method to set the range of values to display
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

/**
 * The number of minor ticks per major tick
 */
@property (assign, nonatomic) NSInteger minorTicksPerMajorTick;

/**
 * The number of pixels/points between minor ticks
 */
@property (assign, nonatomic) NSInteger minorTickDistance;

/**
 * The image to use as the background image
 */
@property (strong, nonatomic) UIColor *backgroundColor;

#pragma mark - Tick Label Properties

/**
 * The tick label stroke color
 */
@property (strong, nonatomic) UIColor *labelStrokeColor;

/**
 * The width of the stroke line used to trace the Label text
 */
@property (assign, nonatomic) CGFloat labelStrokeWidth;

/**
 * The tick label fill color
 */
@property (strong, nonatomic) UIColor *labelFillColor;

/**
 * The tick label font
 */
@property (strong, nonatomic) UIFont *labelFont;

#pragma mark - Minor Tick Properties

/**
 * The minor tick color
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

/**
 * The color of the Middle Tick
 */
@property (strong, nonatomic) UIColor *middleTickColor;

#pragma mark - Major Tick Properties

/**
 * The color of the Major Tick
 */
@property (strong, nonatomic) UIColor *majorTickColor;

/**
 * The length of the Major Tick
 */
@property (assign, nonatomic) CGFloat majorTickLength;

/**
 * The width of the Major Tick
 */
@property (assign, nonatomic) CGFloat majorTickWidth;

#pragma mark - Shadow Properties

/**
 * The shadow color
 */
@property (strong, nonatomic) UIColor *shadowColor;

/**
 * The shadow offset
 */
@property (assign, nonatomic) CGSize shadowOffset;

/**
 * The shadow blur radius
 */
@property (assign, nonatomic) CGFloat shadowBlur;

@end
