//
//  MainViewController.m
//  PPScroll
//  项目地址：https://github.com/Fanish/PPScroll-OC
//  Created by Charlie C on 15/8/29.
//  Copyright (c) 2015年 Charlie C. All rights reserved.
//

#import "MainViewController.h"
#import "PPScroll.h"
#import "Masonry.h"
@interface MainViewController ()<PPScrollDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong,readwrite) IBOutlet PPScroll *ppScroll;
@property (nonatomic,strong,readwrite) UIScrollView *toolBgScroll;
//Label
@property (nonatomic,strong,readwrite) UILabel *lineNumLabel;
@property (nonatomic,strong,readwrite) UILabel *columnNumLabel;
@property (nonatomic,strong,readwrite) UILabel *fontLabel;
//控件
@property (nonatomic,strong,readwrite) UIPickerView *toolTypePicker;
@property (nonatomic,strong,readwrite) UISlider *lineNumValue;
@property (nonatomic,strong,readwrite) UISlider *columnNumValue;
@property (nonatomic,strong,readwrite) UISlider *redValue;
@property (nonatomic,strong,readwrite) UISlider *greenValue;
@property (nonatomic,strong,readwrite) UISlider *blueValue;
@property (nonatomic,strong,readwrite) UISlider *fontSizeValue;

@end


@implementation MainViewController{
    
    NSInteger changedColorPart;
    UIColor *bgColor;
    UIColor *bannerColor;
    UIColor *lineColor;
    UIColor *contentColor;
    UIColor *contentColor_h;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"PPScroll";
    
    [self viewInitWithMasonry];//界面初始化

    bgColor = _ppScroll.bgColor;
    bannerColor = _ppScroll.bannerColor;
    lineColor = _ppScroll.separatorLineColor;
    contentColor = _ppScroll.textColor_n;
    contentColor_h = _ppScroll.textColor_h;
    
    [_redValue setValue:CGColorGetComponents(bgColor.CGColor)[0] animated:YES];
    [_greenValue setValue:CGColorGetComponents(bgColor.CGColor)[1] animated:YES];
    [_blueValue setValue:CGColorGetComponents(bgColor.CGColor)[2] animated:YES];
}

-(void)viewInitWithMasonry{
    
    /**
        PPScroll主体
     */
    _ppScroll = [[PPScroll alloc]init];
    
    _ppScroll.delegate = self;
    
    [self.view addSubview:_ppScroll];
    
    /**
        UIScrollView
     */
    _toolBgScroll = [[UIScrollView alloc]init];
    
    _toolBgScroll.contentSize = CGSizeMake(self.view.frame.size.width,300);
    
    [self.view addSubview:_toolBgScroll];
    
    /**
        静态label：数目
     */
    UILabel *num = [[UILabel alloc]init];
    
    num.text = @"数目:";
    
    num.textColor = [UIColor lightGrayColor];

    num.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    
    [_toolBgScroll addSubview:num];
    
    /**
        静态label：行数
     */
    _lineNumLabel = [[UILabel alloc]init];
    
    _lineNumLabel.text = @"行数 LN:";
    
    _lineNumLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    
    [_toolBgScroll addSubview:_lineNumLabel];
    
    /**
        slide：行数
     */
    _lineNumValue = [[UISlider alloc]init];
    
    _lineNumValue.maximumValue = 10;
    
    _lineNumValue.minimumValue = 1;

    [_lineNumValue addTarget:self action:@selector(lineNumChange:) forControlEvents:UIControlEventValueChanged];
    
    _lineNumValue.value = _ppScroll.lineNum;

    [_toolBgScroll addSubview:_lineNumValue];
    
    /**
        静态label：列数
     */
    _columnNumLabel = [[UILabel alloc]init];
    
    _columnNumLabel.text = @"列数 CN:";
    
    _columnNumLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    
    [_toolBgScroll addSubview:_columnNumLabel];
    
    /**
        slide：列数
     */
    _columnNumValue = [[UISlider alloc]init];
    
    _columnNumValue.maximumValue = 10;
    
    _columnNumValue.minimumValue = 1;
    
    _columnNumValue.value = _ppScroll.columnNum;
    
    [_columnNumValue addTarget:self action:@selector(columnNumChange:) forControlEvents:UIControlEventValueChanged];
    
    [_toolBgScroll addSubview:_columnNumValue];
    
    /**
        静态label：颜色
     */
    UILabel *color = [[UILabel alloc]init];
    
    color.text = @"颜色:";
    
    color.textColor = [UIColor lightGrayColor];
    
    color.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    
    [_toolBgScroll addSubview:color];

    /**
        toolPicker：颜色工具选择器
     */
    _toolTypePicker = [[UIPickerView alloc]init];
    
    _toolTypePicker.delegate = self;
    
    [_toolBgScroll addSubview:_toolTypePicker];
    
    /**
        slide：R
     */
    _redValue = [[UISlider alloc]init];
    
    [_redValue addTarget:self action:@selector(rgb_change:) forControlEvents:UIControlEventValueChanged];
    
    [_toolBgScroll addSubview:_redValue];
    
    /**
        slide：G
     */
    _greenValue = [[UISlider alloc]init];
    
    [_greenValue addTarget:self action:@selector(rgb_change:) forControlEvents:UIControlEventValueChanged];
    
    [_toolBgScroll addSubview:_greenValue];
    
    /**
        slide：B
     */
    _blueValue = [[UISlider alloc]init];
    
    [_blueValue addTarget:self action:@selector(rgb_change:) forControlEvents:UIControlEventValueChanged];
    
    [_toolBgScroll addSubview:_blueValue];
    
    /**
        静态label：字体
     */
    UILabel *font = [[UILabel alloc]init];
    
    font.text = @"字体:";
    
    font.textColor = [UIColor lightGrayColor];
    
    font.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];
    
    [_toolBgScroll addSubview:font];
    
    /**
        静态label：字体大小
     */
    _fontLabel = [[UILabel alloc]init];
    
    _fontLabel.text = @"字体大小:";
    
    _fontLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:11];
    
    [_toolBgScroll addSubview:_fontLabel];
    
    /**
     slide：字体大小
     */
    _fontSizeValue = [[UISlider alloc]init];
    
    _fontSizeValue.maximumValue = 20;
    
    _fontSizeValue.minimumValue = 1;
    
    [_fontSizeValue addTarget:self action:@selector(fontSizeChange:) forControlEvents:UIControlEventValueChanged];
    
    _fontSizeValue.value = _ppScroll.font.pointSize;
    
    [_toolBgScroll addSubview:_fontSizeValue];
    
    /**
     *  约束
     */
    [_ppScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@150);
    }];
    
    [_toolBgScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ppScroll.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_toolBgScroll.mas_top).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    
    [_lineNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(num.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];

    [_lineNumValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineNumLabel.mas_right).offset(10);
        make.bottom.equalTo(_lineNumLabel.mas_bottom);
        make.right.equalTo(self.view.mas_rightMargin);
        make.height.equalTo(_lineNumLabel);
    }];
    
    [_columnNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineNumLabel.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    [_columnNumValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_columnNumLabel.mas_right).offset(10);
        make.bottom.equalTo(_columnNumLabel.mas_bottom);
        make.right.equalTo(self.view.mas_rightMargin);
        make.height.equalTo(_columnNumLabel);
    }];
    
    [color mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_columnNumLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    
    [_toolTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(color.mas_bottom);
        make.left.equalTo(self.view).offset(10);
        make.height.equalTo(@100);
        make.width.equalTo(@60);
    }];
    
    [_redValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lineNumValue);
        make.width.equalTo(_lineNumValue);
        make.top.equalTo(color).offset(15);
    }];
    
    [_greenValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lineNumValue);
        make.width.equalTo(_lineNumValue);
        make.top.equalTo(_redValue).offset(35);
    }];
    
    [_blueValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lineNumValue);
        make.width.equalTo(_lineNumValue);
        make.top.equalTo(_greenValue).offset(35);
    }];
    
    [font mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_blueValue.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view);
        make.height.equalTo(@20);
    }];

    [_fontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(font.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    [_fontSizeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lineNumValue);
        make.centerY.equalTo(_fontLabel);
        make.width.equalTo(_lineNumValue);
    }];
    
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (void)lineNumChange:(UISlider *)sender{
    _ppScroll.lineNum = (int)sender.value;
    _lineNumLabel.text = [NSString stringWithFormat:@"行数 LN:%d",(int)sender.value];
}

- (void)columnNumChange:(UISlider *)sender{
    _ppScroll.columnNum = (int)sender.value;
    _columnNumLabel.text = [NSString stringWithFormat:@"列数 CN:%d",(int)sender.value];
}

-(void)fontSizeChange:(UISlider *)sender{
    _ppScroll.font = [UIFont systemFontOfSize:(int)sender.value];
    _fontLabel.text = [NSString stringWithFormat:@"字体大小:%d",(int)sender.value];
}

- (void)rgb_change:(id)sender {
    switch (changedColorPart) {
        case 0:
            bgColor = [UIColor colorWithRed:_redValue.value green:_greenValue.value blue:_blueValue.value alpha:1.0f];
            _ppScroll.bgColor = bgColor;
            break;
        case 1:
            bannerColor = [UIColor colorWithRed:_redValue.value green:_greenValue.value blue:_blueValue.value alpha:1.0f];
            _ppScroll.bannerColor = bannerColor;
            break;
        case 2:
            lineColor = [UIColor colorWithRed:_redValue.value green:_greenValue.value blue:_blueValue.value alpha:1.0f];
            _ppScroll.separatorLineColor = lineColor;
            break;
        case 3:
            contentColor = [UIColor colorWithRed:_redValue.value green:_greenValue.value blue:_blueValue.value alpha:1.0f];
            _ppScroll.textColor_n = contentColor;
            break;
        case 4:
            contentColor_h = [UIColor colorWithRed:_redValue.value green:_greenValue.value blue:_blueValue.value alpha:1.0f];
            _ppScroll.textColor_h = contentColor_h;
            break;
        default:
            break;
    }
}

#pragma pickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 5;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    switch (row) {
        case 0:
            return @"背景";
            break;
        case 1:
            return @"选择条";
            break;
        case 2:
            return @"分割线";
        case 3:
            return @"内容";
        case 4:
            return @"内容(选中)";
        default:
            break;
    }
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont fontWithName:@"PingFangSC-Thin" size:12]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    changedColorPart = row;
    switch (row) {
        case 0:
            [_redValue setValue:CGColorGetComponents(bgColor.CGColor)[0] animated:YES];
            [_greenValue setValue:CGColorGetComponents(bgColor.CGColor)[1] animated:YES];
            [_blueValue setValue:CGColorGetComponents(bgColor.CGColor)[2] animated:YES];
            break;
        case 1:
            [_redValue setValue:CGColorGetComponents(bannerColor.CGColor)[0] animated:YES];
            [_greenValue setValue:CGColorGetComponents(bannerColor.CGColor)[1] animated:YES];
            [_blueValue setValue:CGColorGetComponents(bannerColor.CGColor)[2] animated:YES];
            break;
        case 2:
            [_redValue setValue:CGColorGetComponents(lineColor.CGColor)[0] animated:YES];
            [_greenValue setValue:CGColorGetComponents(lineColor.CGColor)[1] animated:YES];
            [_blueValue setValue:CGColorGetComponents(lineColor.CGColor)[2] animated:YES];
            break;
        case 3:
            [_redValue setValue:CGColorGetComponents(contentColor.CGColor)[0] animated:YES];
            [_greenValue setValue:CGColorGetComponents(contentColor.CGColor)[1] animated:YES];
            [_blueValue setValue:CGColorGetComponents(contentColor.CGColor)[2] animated:YES];
            break;
        case 4:
            [_redValue setValue:CGColorGetComponents(contentColor_h.CGColor)[0] animated:YES];
            [_greenValue setValue:CGColorGetComponents(contentColor_h.CGColor)[1] animated:YES];
            [_blueValue setValue:CGColorGetComponents(contentColor_h.CGColor)[2] animated:YES];
            break;
        default:
            break;
    }
    [self rgb_change:nil];
}

#pragma PPScrollDelegate

-(void)scroll:(PPScroll *)scroll selectedIndexDic:(NSMutableDictionary *)selectedIndexDic{
    NSLog(@"%@",selectedIndexDic);
}
-(void)scroll:(PPScroll *)scroll index:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}

@end
