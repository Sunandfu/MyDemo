//
//  CustomPicker.m
//  MyPickerViewController
//
//  Created by 常新 顾 on 13-4-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomPicker.h"
#import "SFConstant.h"

@interface CustomPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,retain) UIView        *toolBar;
@property (nonatomic,retain) UIView        *showView;
@property (nonatomic,retain) UIView        *maskView;
@property (nonatomic,retain) UIWindow      *window;

@end

@implementation CustomPicker

+ (CustomPicker *)sharedInstance{
    static dispatch_once_t onceToken;
    static CustomPicker *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[CustomPicker alloc]init];
        [instance createAllViews];
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
    if (@available(iOS 13.0, *)) {
        showView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            BOOL isFollSys = [[NSUserDefaults standardUserDefaults] boolForKey:KeyNightFollowingSystem];
            if (isFollSys) {
                if (traitCollection.userInterfaceStyle==UIUserInterfaceStyleLight) {
                    return [UIColor whiteColor];
                } else {
                    return [UIColor blackColor];
                }
            } else {
                BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
                if (!isNignt) {
                    return [UIColor whiteColor];
                } else {
                    return [UIColor blackColor];
                }
            }
        }];
    } else {
        // Fallback on earlier versions
        BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
        if (!isNignt) {
            showView.backgroundColor = [UIColor whiteColor];
        } else {
            showView.backgroundColor = [UIColor blackColor];
        }
    };
    
    //添加点击手势
    UITapGestureRecognizer *maskGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.maskView addGestureRecognizer:maskGesture];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, window.bounds.size.width, 260-44)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [showView addSubview:self.pickerView];
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, 44)];
    toolBar.backgroundColor = [UIColor orangeColor];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(window.bounds.size.width-100, 7, 100, 30);
    finishBtn.tag = 1;
    [toolBar addSubview:finishBtn];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    //[finishBtn setBackgroundImage:[UIImage imageNamed:@"share_enter_normal.png"] forState:UIControlStateNormal];
    //[finishBtn setBackgroundImage:[UIImage imageNamed:@"share_enter_selected"] forState:UIControlStateHighlighted];
    [finishBtn addTarget:self action:@selector(finishChoose) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 7, 100, 30);
    cancelBtn.tag = 2;
    [toolBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"mine_btn_normal.png"] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"mine_btn_selected.png"] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelOperate) forControlEvents:UIControlEventTouchUpInside];
    self.toolBar = toolBar;
    [showView addSubview:self.toolBar];
}

- (void)setDelegate:(id)aDelegate
{
    _delegate = aDelegate;
    [self.pickerView reloadAllComponents];
}

#pragma - mark - UIPickViw
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerDataArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dict = self.pickerDataArray[row];
    return dict[@"show"];
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
    if (@available(iOS 13.0, *)) {
        pickerLabel.textColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            BOOL isFollSys = [[NSUserDefaults standardUserDefaults] boolForKey:KeyNightFollowingSystem];
            if (isFollSys) {
                if (traitCollection.userInterfaceStyle==UIUserInterfaceStyleDark) {
                    self.showView.backgroundColor = [UIColor blackColor];
                    return [UIColor whiteColor];
                } else {
                    self.showView.backgroundColor = [UIColor whiteColor];
                    return [UIColor blackColor];
                }
            } else {
                BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
                if (isNignt) {
                    self.showView.backgroundColor = [UIColor blackColor];
                    return [UIColor whiteColor];
                } else {
                    self.showView.backgroundColor = [UIColor whiteColor];
                    return [UIColor blackColor];
                }
            }
        }];
    } else {
        // Fallback on earlier versions
        BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
        if (isNignt) {
            pickerLabel.textColor = [UIColor whiteColor];
        } else {
            pickerLabel.textColor = [UIColor blackColor];
        }
    };
    return pickerLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

- (void)show
{
    BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
    if (!isNignt) {
        self.showView.backgroundColor = [UIColor whiteColor];
    } else {
        self.showView.backgroundColor = [UIColor blackColor];
    }
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
    }];
}

//完成按钮事件
- (void)finishChoose
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(finishChoose:)]) {
        [self.delegate finishChoose:self];
    }
}

//取消按钮事件
- (void)cancelOperate
{
    [self dismiss];
}

- (void)updateFrame:(CGSize)size{
    self.maskView.frame = CGRectMake(0, 0, size.width, size.height);
    self.showView.frame = CGRectMake(0, size.height, size.width, 260);
    self.pickerView.frame = CGRectMake(0, 44, size.width, 260-44);
    self.toolBar.frame = CGRectMake(0, 0, size.width, 44);
    UIButton *button = [self.toolBar viewWithTag:1];
    button.frame = CGRectMake(size.width-100, 7, 100, 30);
    UIButton *button2 = [self.toolBar viewWithTag:2];
    button2.frame = CGRectMake(0, 7, 100, 30);
}

@end
