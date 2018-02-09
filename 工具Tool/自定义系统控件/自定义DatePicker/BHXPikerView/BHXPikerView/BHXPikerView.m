//
//  TXTimeChoose.m
//  TYSubwaySystem
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 TXZhongJiaowang. All rights reserved.
//

#import "BHXPikerView.h"

#define kZero 0
#define kFullWidth [UIScreen mainScreen].bounds.size.width
#define kFullHeight [UIScreen mainScreen].bounds.size.height

#define kDatePicY kFullHeight/3*2
#define kDatePicHeight kFullHeight/3

#define kDateTopBtnY kDatePicY - 30
#define kDateTopBtnHeight 30

#define kDateTopRightBtnWidth kDateTopLeftBtnWidth
#define kDateTopRightBtnX kFullWidth - 30 - kDateTopRightBtnWidth

#define kDateTopLeftbtnX 30
#define kDateTopLeftBtnWidth kFullWidth/6


@interface BHXPikerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *contentString;
    NSInteger commentRow;
}
@property (nonatomic,strong)UIDatePicker *dateP;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *groundV;

@property (nonatomic,assign)UIDatePickerMode type;

@property (strong, nonatomic) NSArray *array;
@end

@implementation BHXPikerView
- (instancetype)initWithFrame:(CGRect)frame type:(UIDatePickerMode)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self addSubview:self.groundV];
        [self addSubview:self.dateP];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.array = array;
        [self addSubview:self.pickerView];
        [self addSubview:self.topView];
    }
    return self;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        UIPickerView *pickView=[[UIPickerView alloc] init];
        pickView.backgroundColor=[UIColor whiteColor];
        _pickerView=pickView;
        pickView.delegate=self;
        pickView.dataSource=self;
        pickView.frame=CGRectMake(0, kDatePicY, kFullWidth, kDatePicHeight);
        [self addSubview:pickView];
    }
    return _pickerView;
}

- (UIDatePicker *)dateP{
    if (!_dateP) {
        self.dateP = [[UIDatePicker alloc]init];
        self.dateP.backgroundColor = [UIColor whiteColor];
     
        self.dateP.datePickerMode = self.type;
        self.dateP.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
        //        NSDate *maxDate = [NSDate date];
        //        self.dateP.maximumDate = maxDate;
        self.dateP.frame = CGRectMake(kZero, kDatePicY+kDatePicHeight, kFullWidth, kDatePicHeight);
        self.topView.frame = CGRectMake(kZero, kDateTopBtnY+kDatePicHeight, kFullWidth, kDateTopBtnHeight);
        [UIView animateWithDuration:0.5 animations:^{
            self.dateP.frame = CGRectMake(kZero, kDatePicY, kFullWidth, kDatePicHeight);
            self.topView.frame = CGRectMake(kZero, kDateTopBtnY, kFullWidth, kDateTopBtnHeight);
        }];
        [self.dateP addTarget:self action:@selector(handleDateP:) forControlEvents:UIControlEventValueChanged];

        
        [self addSubview:self.topView];
        [self.topView addSubview:self.leftBtn];
        [self.topView addSubview:self.rightBtn];
    }
    return _dateP;
}

- (UIView *)topView {
    if (!_topView) {
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(kZero, kDateTopBtnY, kFullWidth, kDateTopBtnHeight)];
        self.topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(kDateTopLeftbtnX, 0, kDateTopLeftBtnWidth, kDateTopBtnHeight);
        [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(handleDateTopViewLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(kDateTopRightBtnX, 0, kDateTopRightBtnWidth, kDateTopBtnHeight);
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [self.rightBtn addTarget:self action:@selector(handleDateTopViewRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
-(void)handleDateTopViewLeft {
    [self end];
}

- (void)handleDateTopViewRight {
    [self.delegate determine:self.dateP.date];
    [self end];
}

- (UIView *)groundV {
    if (!_groundV) {
        self.groundV = [[UIView alloc]initWithFrame:self.bounds];
        self.groundV.backgroundColor = [UIColor blackColor];
        self.groundV.alpha = 0.4;
    }
    return _groundV;
}


- (void)setNowTime:(NSString *)dateStr{
//    [self.pickerView selectRow:1 inComponent:0 animated:YES];
    [self.dateP setDate:[self dateFromString:dateStr] animated:YES];
}

- (void)end{
    self.dateP.frame = CGRectMake(kZero, kDatePicY, kFullWidth, kDatePicHeight);
    self.topView.frame = CGRectMake(kZero, kDateTopBtnY, kFullWidth, kDateTopBtnHeight);
    [UIView animateWithDuration:0.5 animations:^{
        self.dateP.frame = CGRectMake(kZero, kDatePicY+kDatePicHeight, kFullWidth, kDatePicHeight);
        self.topView.frame = CGRectMake(kZero, kDateTopBtnY+kDatePicHeight, kFullWidth, kDateTopBtnHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)handleDateP :(NSDate *)date {
    
    [self.delegate changeTime:self.dateP.date];
}

- (void)handleDateTopViewCancel {
    [self end];
}
#pragma mark - 时间控件datePicker的数据传递
- (void)handleDateTopViewCertain {
    [self.delegate determine:self.dateP.date];
    [self end];
}
#pragma mark - 自定义数据传递
- (void)handleDateTopViewCertain1 {
    
    [self.pickerdelegate deterDate:contentString andComponent:commentRow];
    contentString = nil;
    [self end];
}



// NSDate --> NSString
- (NSString*)stringFromDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (self.type) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
         case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd:EEEE HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

//NSDate <-- NSString
- (NSDate*)dateFromString:(NSString*)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (self.type) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd:EEEE HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}


#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.array.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    contentString = self.array[row];
    commentRow = row;
    return self.array[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    contentString = self.array[row];
    commentRow = row;

    [self.pickerdelegate changeDate:self.array[row] andComponent:row];
}

@end
