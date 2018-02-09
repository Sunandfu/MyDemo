//
//  ViewController.m
//  DrawLineChart
//
//  Created by yuyu on 16/4/20.
//  Copyright © 2016年 yuyu. All rights reserved.
//

#import "ViewController.h"
#import "LineChartView.h"
#import "PointModel.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;
@property (weak, nonatomic) IBOutlet UITextField *textfield1;
@property (weak, nonatomic) IBOutlet UITextField *textfield2;
@property (weak, nonatomic) IBOutlet UITextField *textfield3;

@end

@implementation ViewController{
    LineChartView *view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /**
     *  定义点数组. 注:这里不能使用oc数组(nsarray),只能使用c的结构体数组
     *  这里的坐标采用表格里的自定义坐标系
     *  X坐标, 为整数1,2,3,4,5 分别代表2月 ~ 6月
     *  Y坐标, 范围:0~25
     *  @param pointDiameter  点的直径
     *  建议两条线的点数相等
     *  建议每条线的点数与纵向虚线条数相等
     */
    
    CGPoint greenPoint[] =
    {
        CGPointMake(0, 3),
        CGPointMake(1, 10),
        CGPointMake(2, 8),
        CGPointMake(3, 7),
        CGPointMake(4, 13),
        CGPointMake(5, 8),
        CGPointMake(6, 7),
        CGPointMake(7, 13),
    };
    
    CGPoint redPoint[] =
    {
        CGPointMake(0, 23),
        CGPointMake(1, 16),
        CGPointMake(2, 30),
        CGPointMake(3, 12),
        CGPointMake(4, 16),
        CGPointMake(5, 16),
        CGPointMake(6, 9),
        CGPointMake(7, 16),
    };
    
    //构建oc点数组
    NSInteger greenCount = sizeof(greenPoint)/sizeof(greenPoint[0]);
    NSArray *greenPoints = [self transformPointArray:greenPoint count:greenCount];
    NSInteger redCount = sizeof(redPoint)/sizeof(redPoint[0]);
    NSArray *redPoints = [self transformPointArray:redPoint count:redCount];
    
    view = [[LineChartView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.greenPoints = greenPoints;
    view.redPoints = redPoints;
    //纵向坐标系一小格的高度(与自定义的点的y坐标无关)
    view.verticalH = 20.0;
    //自定义坐标系每小格的高度(与定义的点有关)
    view.coordinateH = 5.0;
    //横向虚线条数
    view.horizontalDashLineCount = 7;
    //单元格横向宽度(像素单位)(与定义的点无关,默认两条垂直虚线之间的距离为1)
    view.horizonW = 40;
    //垂直虚线条数(默认两条垂直虚线之间的距离为1)
    view.verticalDashLineCount = 8;
    //左边标题
    view.leftTitle = @"简单折线";
    //红色标题
    view.redTitle = @"我是红线";
    //绿色标题
    view.greenTitle = @"我是绿线";
    [self.view insertSubview:view atIndex:0];
    [view setNeedsDisplay];
}

-(NSArray *)transformPointArray:(CGPoint *)points count:(NSInteger)count{
    
    NSMutableArray *pointArray = [NSMutableArray array];
    for (NSInteger i = 0; i<count; i++) {
        PointModel *pointmodel = [[PointModel alloc] init];
        pointmodel.x = points[i].x;
        pointmodel.y = points[i].y;
        [pointArray addObject:pointmodel];
    }
    return pointArray;
}

- (IBAction)sliderValueChange:(id)sender {
    float f = _slider1.value;
    view.verticalH = f;
    [view setNeedsDisplay];
}

- (IBAction)horizonWChange:(id)sender {
    float f = _slider2.value;
    view.horizonW = f;
    [view setNeedsDisplay];
}

- (IBAction)lineCount1:(id)sender {
    NSInteger count = _textfield1.text.integerValue;
    view.horizontalDashLineCount = count;
    [view setNeedsDisplay];
    
    [_textfield1 resignFirstResponder];
    [_textfield2 resignFirstResponder];
    [_textfield3 resignFirstResponder];
}
- (IBAction)linecount2:(id)sender {
    NSInteger count = _textfield2.text.integerValue;
    view.verticalDashLineCount = count;
    [view setNeedsDisplay];
    [_textfield1 resignFirstResponder];
    [_textfield2 resignFirstResponder];
    [_textfield3 resignFirstResponder];
}
- (IBAction)coordinateH:(id)sender {
    NSInteger count = _textfield3.text.integerValue;
    view.coordinateH = count;
    [view setNeedsDisplay];
    [_textfield1 resignFirstResponder];
    [_textfield2 resignFirstResponder];
    [_textfield3 resignFirstResponder];
}
-(void)createRandomPoints{
    NSMutableArray *redpointsArray = [NSMutableArray array];
    NSMutableArray *greenPointArray = [NSMutableArray array];
    for (int i = 0; i<view.verticalDashLineCount; i++) {
        PointModel *redmodel = [[PointModel alloc] init];
        PointModel *greenModel = [[PointModel alloc] init];
        redmodel.x = i;
        greenModel.x = i;
        redmodel.y = [self getRandomNumber:view.horizontalDashLineCount*view.coordinateH/3 to:view.horizontalDashLineCount*view.coordinateH];
        greenModel.y = [self getRandomNumber:0 to:view.horizontalDashLineCount*view.coordinateH*2/3];
        [redpointsArray addObject:redmodel];
        [greenPointArray addObject:greenModel];
    }
    view.redPoints = nil;
    view.redPoints = redpointsArray;
    view.greenPoints = nil;
    view.greenPoints = greenPointArray;
    [view setNeedsDisplay];
}

- (IBAction)createRandomLines:(id)sender {
    [self createRandomPoints];
}
                 
-(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to-from + 1)));
}

@end
