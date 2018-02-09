//
//  LineChartView.h
//  DrawLineChart
//
//  Created by yuyu on 16/4/20.
//  Copyright © 2016年 yuyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineChartView : UIView

@property(nonatomic,strong)NSArray *greenPoints; //绿点坐标数组

@property(nonatomic,strong)NSArray *redPoints; //绿色点数组

@property(nonatomic,assign)CGFloat verticalH; //单元格纵向高度(像素单位,与定义的点无关)

@property(nonatomic,assign)CGFloat coordinateH; //自定义坐标系每小格的高度(与定义的点有关)

@property(nonatomic,assign)NSInteger horizontalDashLineCount; //横向虚线条数

@property(nonatomic,assign)CGFloat horizonW;//单元格横向宽度(像素单位)

@property(nonatomic,assign)NSInteger verticalDashLineCount; //垂直虚线条数(默认两条垂直虚线之间的距离为1)

@property(nonatomic,copy)NSString *leftTitle; //左边标题

@property(nonatomic,copy)NSString *redTitle; //红线标题

@property(nonatomic,copy)NSString *greenTitle; //绿色标题

@end
