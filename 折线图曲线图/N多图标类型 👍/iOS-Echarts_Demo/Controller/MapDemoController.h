//
//  MapDemoController.h
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/12/27.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYEchartsView.h"

/**
 *  地图的Demo集合，主要用来封装官网中的Demo
 *  用来解释在iOS代码中如何展示该如何使用
 */
@interface MapDemoController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet PYEchartsView *yEchartView;
@property (strong, nonatomic) IBOutlet UITableView *yDemoMenusTb;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com