/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import <UIKit/UIKit.h>

@interface TRSDialScrollView : UIView <UIAppearance>

/**
 * The current value in the scroll view
 */
@property (assign, nonatomic) NSInteger currentValue;

/**
 * The UIScrollViewDelegate for this class
 */
@property (weak, nonatomic) id<UIScrollViewDelegate> delegate;


#pragma mark - Generic Properties

/**
 * The number of minor ticks per major tick
 */
@property (assign, nonatomic) NSInteger minorTicksPerMajorTick UI_APPEARANCE_SELECTOR;

/**
 * The number of pixels/points between minor ticks
 */
@property (assign, nonatomic) NSInteger minorTickDistance UI_APPEARANCE_SELECTOR;

/**
 * The image to use as the background image
 */
@property (strong, nonatomic) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/**
 * The image to overlay on top of the scroll dial
 */
@property (strong, nonatomic) UIColor *overlayColor UI_APPEARANCE_SELECTOR;


#pragma mark - Tick Label Properties

/**
 * The tick label stroke color
 */
@property (strong, nonatomic) UIColor *labelStrokeColor UI_APPEARANCE_SELECTOR;

/**
 * The width of the stroke line used to trace the Label text
 */
@property (assign, nonatomic) CGFloat labelStrokeWidth UI_APPEARANCE_SELECTOR;

/**
 * The tick label fill color
 */
@property (strong, nonatomic) UIColor *labelFillColor UI_APPEARANCE_SELECTOR;

/**
 * The tick label font
 */
@property (strong, nonatomic) UIFont *labelFont UI_APPEARANCE_SELECTOR;

#pragma mark - Minor Tick Properties

/**
 * The minor tick color
 */
@property (strong, nonatomic) UIColor *minorTickColor UI_APPEARANCE_SELECTOR;

/**
 * The length of the minor ticks
 */
@property (assign, nonatomic) CGFloat minorTickLength UI_APPEARANCE_SELECTOR;

/**
 * The length of the Major Tick
 */
@property (assign, nonatomic) CGFloat minorTickWidth UI_APPEARANCE_SELECTOR;

#pragma mark - Major Tick Properties
/**
 * The color of the Major Tick
 */
@property (strong, nonatomic) UIColor *secondTickColor;

/**
 * The color of the Major Tick
 */
@property (strong, nonatomic) UIColor *majorTickColor UI_APPEARANCE_SELECTOR;

/**
 * The length of the Major Tick
 */
@property (assign, nonatomic) CGFloat majorTickLength UI_APPEARANCE_SELECTOR;

/**
 * The width of the Major Tick
 */
@property (assign, nonatomic) CGFloat majorTickWidth UI_APPEARANCE_SELECTOR;

#pragma mark - Shadow Properties

/**
 * The shadow color
 */
@property (strong, nonatomic) UIColor *shadowColor UI_APPEARANCE_SELECTOR;

/**
 * The shadow offset
 */
@property (assign, nonatomic) CGSize shadowOffset UI_APPEARANCE_SELECTOR;

/**
 * The shadow blur radius
 */
@property (assign, nonatomic) CGFloat shadowBlur UI_APPEARANCE_SELECTOR;

#pragma mark - Methods

/**
 * Method to set the range of values to display
 */
- (void)setDialRangeFrom:(NSInteger)from to:(NSInteger)to;
/* 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:10];//尺寸间隔数
 [[TRSDialScrollView appearance] setMinorTickDistance:16];//尺寸宽度
 
 [[TRSDialScrollView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialBackground"]]];
 [[TRSDialScrollView appearance] setOverlayColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialShadding"]]];
 
 [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
 [[TRSDialScrollView appearance] setLabelStrokeWidth:0.1f];
 [[TRSDialScrollView appearance] setLabelFillColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
 
 [[TRSDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:20]];
 
 [[TRSDialScrollView appearance] setMinorTickColor:[UIColor colorWithRed:0.800 green:0.553 blue:0.318 alpha:1.000]];
 [[TRSDialScrollView appearance] setMinorTickLength:15.0];
 [[TRSDialScrollView appearance] setMinorTickWidth:1.0];
 
 [[TRSDialScrollView appearance] setSecondTickColor:[UIColor redColor]];
 
 [[TRSDialScrollView appearance] setMajorTickColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
 [[TRSDialScrollView appearance] setMajorTickLength:33.0];
 [[TRSDialScrollView appearance] setMajorTickWidth:2.0];
 
 [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
 [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(0, 1)];
 [[TRSDialScrollView appearance] setShadowBlur:0.9f];
 
 [_dialView setDialRangeFrom:0 to:250];
 
 _dialView.currentValue = 10;
 
 _dialView.delegate = self;
 _dialView.transform = CGAffineTransformMakeRotation(M_PI_2);
 
 
	// Do any additional setup after loading the view, typically from a nib.
 }
 #pragma mark - UIScrollViewDelegate
 
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
 {
 NSLog(@"scrollViewDidEndDecelerating:");
 NSLog(@"Current Value = %li", (long)_dialView.currentValue);
 }
 
 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
 {
 NSLog(@"scrollViewWillBeginDragging:");
 } 
 */
@end
