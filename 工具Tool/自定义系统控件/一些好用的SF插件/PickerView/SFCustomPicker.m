//
//  SFCustomPicker.m
//  LunchAd
//
//  Created by Lurich on 2018/5/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "SFCustomPicker.h"
#import "SFTool.h"

@interface SFCustomPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView        *toolBar;
@property (nonatomic, strong) UIView        *showView;
@property (nonatomic, strong) UIView        *maskView;
@property (nonatomic, strong) UIWindow      *window;

@property (nonatomic, copy) NSString *selectedStr;

@property (nonatomic, strong) UIPickerView  *pickerView;

@end

@implementation SFCustomPicker

+ (SFCustomPicker *)sharedInstance{
    static dispatch_once_t onceToken;
    static SFCustomPicker *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[SFCustomPicker alloc]init];
    });
    return instance;
}

- (void)createAllViews{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.window = window;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [window addSubview:self.maskView];
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, window.bounds.size.height, window.bounds.size.width, 260)];
    [window addSubview:showView];
    self.showView = showView;
    self.showView.backgroundColor = [UIColor whiteColor];
    
    //添加点击手势
    UITapGestureRecognizer *maskGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.maskView addGestureRecognizer:maskGesture];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, window.bounds.size.width, 260-44)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [showView addSubview:self.pickerView];
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, 44)];
    toolBar.backgroundColor = [UIColor whiteColor];
    self.toolBar = toolBar;
    [showView addSubview:self.toolBar];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(window.bounds.size.width-100-[SFTool getWindowSafeAreaInsets].right, 7, 100, 30);
    finishBtn.tag = 1;
    [toolBar addSubview:finishBtn];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor colorWithRed:34/255.0 green:159/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishChoose) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake([SFTool getWindowSafeAreaInsets].left, 7, 100, 30);
    cancelBtn.tag = 2;
    [toolBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:114/255.0 blue:120/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelOperate) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, window.bounds.size.width - 200, CGRectGetHeight(toolBar.frame))];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    titleLbl.textColor = [UIColor colorWithRed:109/255.0 green:114/255.0 blue:120/255.0 alpha:1.0];
    titleLbl.tag = 3;
    [toolBar addSubview:titleLbl];
}
- (void)setTitleStr:(NSString *)titleStr{
    UILabel *titleLbl = [self.toolBar viewWithTag:3];
    titleLbl.text = titleStr;
}

#pragma - mark - UIPickViw
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerDataArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickerDataArray[row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        }
    }
    
    /*重新定义row 的UILabel*/
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20.0f]];
       // [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textColor = [UIColor blackColor];
    return pickerLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedStr = self.pickerDataArray[row];
}

- (void)show
{
    [self createAllViews];
    self.selectedStr = self.pickerDataArray.firstObject;
    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        self.showView.frame = CGRectMake(0, self.window.bounds.size.height-260, self.window.bounds.size.width, 260);
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, self.window.bounds.size.height, self.window.bounds.size.width, 260);
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.showView removeFromSuperview];
    }];
}

//完成按钮事件
- (void)finishChoose
{
    [self dismiss];
    if (self.clickedOkBtn) {
        self.clickedOkBtn(self.selectedStr?:[self.pickerDataArray firstObject]);
    }
}

//取消按钮事件
- (void)cancelOperate
{
    [self dismiss];
}

@end
