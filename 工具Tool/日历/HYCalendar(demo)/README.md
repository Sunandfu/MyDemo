HYCalendar
==========

A simple calendar view

```objective-c
MyCalendarItem *calendarView = [[MyCalendarItem alloc] init];
calendarView.frame = CGRectMake(10, 50, 355, 300);
[self.view addSubview:calendarView];

calendarView.date = [NSDate date];
calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){

    NSLog(@"%li-%li-%li", year,month,day);
};
```
