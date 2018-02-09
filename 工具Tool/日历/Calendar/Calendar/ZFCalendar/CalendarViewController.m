//
//  CalendarViewController.m
//  Calendar
//
//  Created by 张凡 on 14-8-21.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"


@interface CalendarViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate>
{

     NSTimer* timer;//定时器

}
@end

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.selectArray=[[NSMutableArray alloc] init];
    
    self.flag=0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView{
    
    
    [self setTitle:@"选择日期"];
    
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-50-64) collectionViewLayout:layout]; //初始化网格视图大小
    
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
}



-(void)initData{
    
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    
}



#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    
    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    
    
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];

        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%ld年 %ld月",model.year,model.month];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    
    
  
    
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];

    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeClick) {
       
        if (model.style == CellDayTypeClick) {
            
            model.style = CellDayTypeFutur;
            if (_flag > 2) {
                _flag = 2;
            }
            self.flag--;
        }
        else
        {
         model.style = CellDayTypeClick;
            self.flag++;
            if (_flag > 2) {
                model.style = CellDayTypeFutur;
            }
        }
        
        if (self.calendarblock) {
            
           
          if(self.flag>2)
          {
             
              timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

              return;
              
              
          }
            self.calendarblock(model);//传递数组给上级

        }
        [self.collectionView reloadData];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}




//定时器方法
- (void)onTimer{
    
    [timer invalidate];//定时器无效
    
    timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
