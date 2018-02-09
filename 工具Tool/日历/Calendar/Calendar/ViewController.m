//
//  ViewController.m
//  Calendar
//
//  Created by 李世飞 on 15/12/28.
//  Copyright © 2015年 李世飞. All rights reserved.
//

#import "ViewController.h"

#import "CalendarHomeViewController.h"

@interface ViewController ()
{
    
    CalendarHomeViewController *chvc;
    
    
    
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"入住/离店日期";
    
    

    
    dataArray=[[NSMutableArray alloc] init];
    
    chvc = [[CalendarHomeViewController alloc]init];
    chvc.view.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:chvc.view];
    
    
//    [chvc setAirPlaneToDay:1095 ToDateforString:nil];//飞机初始化方法
    [chvc setHotelToDay:1095 ToDateforString:nil];
    
    [self mainViewClass:0];
    
    chvc.calendarblock = ^(CalendarDayModel *model){
        
        
        NSLog(@"%@",[model toString]);
        
        if(model.style==CellDayTypeClick)
        {
            [dataArray addObject:model.toString];
            
            NSSet *set = [NSSet setWithArray:dataArray];
            dataArray=[[set allObjects] mutableCopy];
            
            [dataArray sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
                return [obj1 compare:obj2];
            }];
            
        }
        else
        {
            [dataArray removeObject:model.toString];
            
        }
       
        [self mainViewClass:dataArray.count];
        
    };

}
-(void)mainViewClass:(NSInteger)num
{
    
    [mainView removeFromSuperview];
    
    mainView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50,self.view.frame.size.width,50)];
    mainView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:mainView];
    
    
    UILabel * lable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    lable.font=[UIFont systemFontOfSize:14.0f];
    lable.textColor=[UIColor whiteColor];
    lable.textAlignment=NSTextAlignmentCenter;
    [mainView addSubview:lable];
    
    
    
    if(num==0)
    {
        lable.text=@"请选择入住时间";
    }
    if(num==1)
    {
        lable.text=@"请选择离店时间";
        
    }
    if(num==2)
    {
     
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate* date1 = [formatter dateFromString:[dataArray objectAtIndex:0]];
        NSDate* date2 = [formatter dateFromString:[dataArray objectAtIndex:1]];
        
        
        NSLog(@"%@",date1);
        NSLog(@"%@",date2);

        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitDay fromDate:date1 toDate:date2  options:0];
        
        int days = (int)[comps day];
        
        
        lable.text=[NSString stringWithFormat:@"%@入住---%@离店 共%d晚",[dataArray objectAtIndex:0],[dataArray objectAtIndex:1],days];

    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
