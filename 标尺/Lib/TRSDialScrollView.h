/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 * 
 *
 #import "TRSDialScrollView.h"
  代理<GetCurrentDelegate>
 
 @property (nonatomic, strong) TRSDialScrollView *heightDialView;
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 self.heightDialView = [[TRSDialScrollView alloc]initWithFrame:CGRectMake(10,100, 350, 150) WithTypeOfNumber:0 isHorizontal:YES];
 [self.view addSubview:self.heightDialView];
 self.heightDialView.currentDelegate = self;
 self.heightDialView.minorTickWidth =1.0;
 self.heightDialView.minorTickLength = 25.0;
 self.heightDialView.minorTickColor = [UIColor lightGrayColor];
 self.heightDialView.majorTickWidth =1.0;
 self.heightDialView.majorTickLength = 40.0;
 self.heightDialView.majorTickColor = [UIColor lightGrayColor];
 [self.heightDialView setDialRangeFrom:50 to:250];
 self.heightDialView.currentValue =170;
 self.heightDialView.labelStrokeWidth = 0.05;
 }
 -(void)getCurrentValue{
 NSLog(@"%@",[NSString stringWithFormat:@"%ldcm",self.heightDialView.currentValue]);
 }
 *
 ***************************************************/

#import <UIKit/UIKit.h>
@protocol GetCurrentDelegate <NSObject>
-(void)getCurrentValue;
@end
@interface TRSDialScrollView : UIView <UIAppearance>

//获取当前的值
@property (assign)id <GetCurrentDelegate>currentDelegate;

/**
 * 是否是横向的标尺（横向为YES    纵向为NO）
 */
@property (nonatomic, assign)BOOL horizontal;

/**
 * The current value in the scroll view
 */
@property (assign, nonatomic) NSInteger currentValue;

@property (nonatomic,copy)NSString *currentValueString;

/**
 * The UIScrollViewDelegate for this class
 */
@property (weak, nonatomic) id<UIScrollViewDelegate> delegate;

@property (assign,nonatomic)NSInteger typeOfNumber;
/**
 *  初始化TRSDialScrollView对象
 *
 *  @param frame  对象的frame
 *  @param type   刻度数字的类型  整形  0    浮点型  1
 *  @param hvType 是否是横向刻度尺   横向: YES    竖向: NO
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame WithTypeOfNumber:(NSInteger)type isHorizontal:(BOOL)hvType;//尺子 尺码 0为整数  1为浮点数

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

@end
