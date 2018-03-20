//
//  CalendarView.m
//  日历
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 HEJJY. All rights reserved.
//

#import "CalendarView.h"
#import "PrefixHeader.h"

#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface CalendarView()

@property (nonatomic, weak) UIButton *preBtn;
@property (nonatomic, weak) UIButton *nextBtn;
@property (nonatomic, weak) UIButton *goToday;

@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIView *dateView;

@property (nonatomic, weak) UIView *selectedView;
@property (nonatomic, weak) UILabel *selectedLabel;

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) NSInteger firstDays;

@property (nonatomic, strong) NSDate *currentDate;


@end

@implementation CalendarView

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        
        _dateArray = [NSMutableArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日", nil];
    }
    return _dateArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _currentDate = [NSDate date];

        UIButton *preBtn = [[UIButton alloc] init];
        [preBtn setTitle:@"<" forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [preBtn addTarget:self action:@selector(preBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:preBtn];
        self.preBtn = preBtn;
        
        UIButton *nextBtn = [[UIButton alloc] init];
        [nextBtn setTitle:@">" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextBtn];
        self.nextBtn = nextBtn;
        
        UIButton *goToday = [[UIButton alloc] init];
        goToday.backgroundColor = Color(248, 248, 249);
        [goToday setTitle:@"回到今天" forState:UIControlStateNormal];
        goToday.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        [goToday setTitleColor:Color(34, 34, 44) forState:UIControlStateNormal];
        [goToday addTarget:self action:@selector(goTodayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        goToday.layer.masksToBounds = YES;
        [self addSubview:goToday];
        self.goToday = goToday;
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.text = @"2010-10月";
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.textColor = Color(64, 67, 79);
        [self addSubview:titleLable];
        self.titleLable = titleLable;
        
        
//        UIView *titleView = [[UIView alloc] init];
//        titleView.backgroundColor = [UIColor clearColor];
//        [self addSubview:titleView];
//        self.titleView = titleView;
        
//        for (int i = 0; i < self.dateArray.count; i++) {
//
//            UILabel *label = [[UILabel alloc] init];
//            label.text = self.dateArray[i];
//            label.textColor = Color(0, 176, 160);
//            label.textAlignment = NSTextAlignmentCenter;
//            [self.titleView addSubview:label];
//            [self.labelArray addObject:label];
//        }
        
        UIView *dateView = [[UIView alloc] init];
        dateView.backgroundColor = [UIColor clearColor];
        [self addSubview:dateView];
        self.dateView = dateView;
        
        [self loadWithDate:_currentDate];
    
    }
    return self;
}

- (void)loadWithDate:(NSDate *)date {
    
    // 移除所有
    if (self.buttonArray) {
        [self.buttonArray removeAllObjects];
    }
    
    if (self.dateView.subviews.count > 0) {
          [self.dateView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    // 获取当月有多少天
    _days = [self getTotalDaysInMonth:date];
    self.firstDays = [self getFirstDayOfMonth:date];
    
    self.titleLable.text = [NSString stringWithFormat:@"%zd-%zd月",[self getCurrentYear:date],[self getCurrentMonth:date]];
    
    
    _currentDate = date;
    for (int i = 1; i <= _days; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        [button setTitle:[NSString stringWithFormat:@"%zd",i] forState:UIControlStateNormal];
        [button setTitleColor:Color(34, 34, 44) forState:UIControlStateNormal];
        if ([self getCurrentMonth:date] == [self getCurrentMonth:[NSDate date]]) {
            if (i == [self getCurrentDay:[NSDate date]]) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
                view.layer.masksToBounds = YES;
                view.layer.cornerRadius = 14;
                view.center = button.center;
                [button addSubview:view];
                view.backgroundColor = Color(249, 93, 62);
                [button sendSubviewToBack:view];
                self.selectedView = view;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, 18)];
                label.text = @"今天";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = Color(249, 93, 62);
                label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
                [button addSubview:label];
                self.selectedLabel = label;
            }
        }
        [self.dateView addSubview:button];
        [self.buttonArray addObject:button];
    }
}

- (void)preBtnClick {
    NSDate *preDate = [self lastMonth:_currentDate];
    [self loadWithDate:preDate];
    [self setNeedsLayout];
    _currentDate = preDate;
}

- (void)nextBtnClick {
    
    NSDate *nextDate = [self nextMonth:_currentDate];
    [self loadWithDate:nextDate];
    [self setNeedsLayout];
    _currentDate = nextDate;
}

- (void)goTodayBtnClick{
    [self loadWithDate:[NSDate date]];
    [self setNeedsLayout];
    _currentDate = [NSDate date];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLable.size = CGSizeMake(100, 40);
    self.titleLable.x = self.width/2.0-self.titleLable.width/2.0;
    self.titleLable.y = 0;
    
    self.preBtn.size = CGSizeMake(40, 40);
    self.preBtn.x = self.titleLable.x-self.preBtn.width;
    self.preBtn.y = 0;
    
    self.nextBtn.size = CGSizeMake(40, 40);
    self.nextBtn.y = 0;
    self.nextBtn.x = self.titleLable.x+self.titleLable.width;
    
    self.dateView.frame = CGRectMake(0, self.titleLable.bottom, self.width,  self.height - self.titleLable.bottom-40);
    
    // 计算有多少行
    NSInteger row = (self.firstDays % 7 + _days + 6) / 7;
    
    NSInteger colum = 7;
    CGFloat buttonH = self.dateView.height / row;
    CGFloat buttonW = self.dateView.width / 7;
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *button = self.buttonArray[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = (self.firstDays % 7 + i) % colum * buttonW;
        button.y = (self.firstDays % 7 + i) / colum * buttonH;
        if ([self getCurrentMonth:_currentDate] == [self getCurrentMonth:[NSDate date]]) {
            if (i+1 == [self getCurrentDay:[NSDate date]]) {
                self.selectedView.center = CGPointMake(button.width/2.0, button.height/2.0);
                self.selectedLabel.center = CGPointMake(self.selectedView.center.x, self.selectedView.bottom+9);
            }
        }
    }
    
    
    self.goToday.size = CGSizeMake(72, 30);
    self.goToday.y = self.dateView.bottom;
    self.goToday.x = self.width - self.goToday.width-18;
    self.goToday.layer.cornerRadius = self.goToday.height/2.0;
//    self.titleView.frame = CGRectMake(0, self.dateView.bottom, self.width, 40);
//    for (int i = 0; i < self.labelArray.count; i++) {
//        UILabel *label = self.labelArray[i];
//        label.width = self.width / 7;
//        label.height = self.titleView.height;
//        label.y = 0;
//        label.x = i * label.width;
//
//    }
    
}
#pragma mark - dateFunction

// 获取日
- (NSInteger)getCurrentDay:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger day = [components day];
    return day;
}

// 获取月
- (NSInteger)getCurrentMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger month = [components month];
    return month;
}

// 获取年
- (NSInteger)getCurrentYear:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger year = [components year];
    return year;
}

// 一个月有多少天
- (NSInteger)getTotalDaysInMonth:(NSDate *)date {
    
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

// 每月第一天
- (NSInteger)getFirstDayOfMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}
// 每周第一天
+(NSDate *)getFirstAndLastDayOfThisWeek:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger weekday = [dateComponents weekday];   //第几天(从sunday开始)
    NSInteger firstDiff,lastDiff;
    if (weekday == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else {
        firstDiff =  - weekday + 2;
        lastDiff = 8 - weekday;
    }
    NSInteger day = [dateComponents day];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    [firstComponents setDay:day+firstDiff];
    NSDate *firstDay = [calendar dateFromComponents:firstComponents];
    
//    NSDateComponents *lastComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
//    [lastComponents setDay:day+lastDiff];
//    NSDate *lastDay = [calendar dateFromComponents:lastComponents];
//    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
    return firstDay;
}

// 上个月
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

// 下个月
- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)right
{
    return self.frame.size.width + self.x;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.y;
}

@end
