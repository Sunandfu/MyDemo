//
//  PMCalendar.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMCalendarController.h"
#import "PMPeriod.h"
#import "NSDate+Helpers.h"
/**
 * 1. 导入头文件    #import "PMCalendar.h"  遵循代理  <PMCalendarControllerDelegate>
 * 2. 定义成员变量    @property (nonatomic, strong) PMCalendarController *pmCC;
 * 3.- (IBAction)showCalendar:(id)sender
 {
 self.pmCC = [[PMCalendarController alloc] init];
 pmCC.delegate = self;
 pmCC.mondayFirstDayOfWeek = YES;
 
 [pmCC presentCalendarFromView:sender
 permittedArrowDirections:PMCalendarArrowDirectionAny
 animated:YES];

 //[pmCC presentCalendarFromRect:[sender frame] inView:[sender superview] permittedArrowDirections:PMCalendarArrowDirectionAny animated:YES];

[self calendarController:pmCC didChangePeriod:pmCC.period];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
 //显示选中日期的始终日期
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@"
                           , [newPeriod.startDate dateStringWithFormat:@"dd-MM-yyyy"]
                           , [newPeriod.endDate dateStringWithFormat:@"dd-MM-yyyy"]];
}
 */