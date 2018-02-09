//
//  CustomPicker.m
//  MyPickerViewController
//
//  Created by 常新 顾 on 13-4-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomPicker.h"
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation CustomPicker
@synthesize delegate = _delegate;
@synthesize pickerView = _pickerView;
@synthesize textField = _textField;
@synthesize maskView = _maskView;

static CustomPicker *_instance = nil;

+ (CustomPicker *)sharedInstance
{
    @synchronized(self)
    {
        if (!_instance)
        {
            _instance = [[self alloc]init];
        }
        return _instance;
    }
}

+ (id)alloc
{
    @synchronized(self)
    {
        if (!_instance)
        {
            _instance = [super alloc];
        }
        
        return _instance;
    }
}
- (id)init
{
    if (self = [super init])
    {
        _textField = [[UITextField alloc] init];
        _textField.hidden = YES;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
        [window addSubview:_maskView];
        
        [_maskView addSubview:_textField];
        
        //添加点击手势
        UITapGestureRecognizer *maskGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_maskView addGestureRecognizer:maskGesture];
        
        _pickerView = [[UIPickerView alloc] init];
        _textField.inputView = _pickerView; 
        _pickerView.showsSelectionIndicator = YES;
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
        
        UIImageView *toolBarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        toolBarImageView.frame = CGRectMake(0, 0, kMainScreenWidth, 44);
        toolBarImageView.backgroundColor = [UIColor grayColor];
        [toolBar addSubview:toolBarImageView];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame = CGRectMake(kMainScreenWidth*3/4, 7, 60, 30);
        [toolBar addSubview:finishBtn];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        //[finishBtn setBackgroundImage:[UIImage imageNamed:@"share_enter_normal.png"] forState:UIControlStateNormal];
        //[finishBtn setBackgroundImage:[UIImage imageNamed:@"share_enter_selected"] forState:UIControlStateHighlighted];
        [finishBtn addTarget:self action:@selector(finishChoose) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(kMainScreenWidth/16, 7, 60, 30);
        [toolBar addSubview:cancelBtn];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"mine_btn_normal.png"] forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"mine_btn_selected.png"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelOperate) forControlEvents:UIControlEventTouchUpInside];
        
        _textField.inputAccessoryView = toolBar;
    }
    
    return self;
}



- (void)setDelegate:(id)aDelegate
{
    _delegate = aDelegate;
    
    _pickerView.delegate = _delegate;
    _pickerView.dataSource = _delegate;
    [_pickerView reloadAllComponents];
}

- (void)show
{
    _maskView.alpha = 0.5;
    [self.textField becomeFirstResponder];
}

//完成按钮事件
- (void)finishChoose
{
    if ([_delegate respondsToSelector:@selector(finishChoose:)])
    {
        [_delegate finishChoose:self];
    }
}


- (void)dismiss
{
    _maskView.alpha = 0;
    [_textField resignFirstResponder];
}

//取消按钮事件
- (void)cancelOperate
{
    _maskView.alpha = 0;
    [_textField resignFirstResponder];
}
@end
