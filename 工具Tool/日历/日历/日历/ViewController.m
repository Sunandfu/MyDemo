//
//  ViewController.m
//  日历
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 HEJJY. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"
#import "PrefixHeader.h"

@interface ViewController ()

@property (nonatomic, strong) CalendarView *calendar;

@end

@implementation ViewController

- (CalendarView *)calendar {
    if (!_calendar) {
        
        _calendar = [[CalendarView alloc] initWithFrame:CGRectMake(10, 100, ScreenWidth - 20, 300)];
    
    }
    return _calendar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor =  Color(244, 244, 244);
    [self.view addSubview:self.calendar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
