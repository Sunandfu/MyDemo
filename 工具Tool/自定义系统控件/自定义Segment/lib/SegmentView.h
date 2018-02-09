


#import <UIKit/UIKit.h>

typedef void(^btnClickBlock)(NSInteger index);

@interface SegmentView : UIView
/**
 *  未选中时的文字颜色,默认黑色
 */
@property (nonatomic,strong) UIColor *titleNomalColor;

/**
 *  选中时的文字颜色,默认红色
 */
@property (nonatomic,strong) UIColor *titleSelectColor;

/**
 *  字体大小，默认15
 */
@property (nonatomic,strong) UIFont  *titleFont;

/**
 *  默认选中的index=1，即第一个
 */
@property (nonatomic,assign) NSInteger defaultIndex;

/**
 *  点击后的block
 */
@property (nonatomic,copy)btnClickBlock block;

/**
 *  初始化方法
 *
 *  @param frame      frame
 *  @param titleArray 传入数组
 *  @param block      点击后的回调
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block;

/*
 //iOS7新增属性
 self.automaticallyAdjustsScrollViewInsets=NO;
 SegmentView *view=[[SegmentView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 60) titles:@[@"头条",@"社会",@"热点",@"体育",@"搞笑",@"科技",@"手机",@"娱乐"] clickBlick:^void(NSInteger index) {
 NSLog(@"-----%ld",index);
 }];
 //以下属性可以根据需求修改
 //    view.titleFont=[UIFont systemFontOfSize:30];
 //    view.defaultIndex=2;
 //    view.titleNomalColor=[UIColor blueColor];
 //    view.titleSelectColor=[UIColor orangeColor];
 [self.view addSubview:view];
 */

@end
