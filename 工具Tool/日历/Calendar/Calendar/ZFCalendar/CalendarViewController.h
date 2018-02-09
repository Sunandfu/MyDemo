//
//  CalendarViewController.h
//  Calendar
//
//  Created by 张凡 on 14-8-21.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarLogic.h"

//回掉代码块
typedef void (^CalendarBlock)(CalendarDayModel *model);

@interface CalendarViewController : UIViewController

@property(nonatomic ,strong) UICollectionView* collectionView;//网格视图

@property(nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组

@property(nonatomic ,strong) CalendarLogic *Logic;

@property (nonatomic, copy) CalendarBlock calendarblock;//回调


@property(nonatomic,strong) NSMutableArray * selectArray;


//计数，当数组中超过2个值时，就不让在添加 ，各人需要
@property(nonatomic,assign) NSInteger flag;

@end
