//
//  PasswordAlertView.m
//  MobileClient
//
//  Created by Luoxusheng-imac on 16/6/22.
//  Copyright © 2016年 pro. All rights reserved.
//

#import "PasswordAlertView.h"
#import "Masonry.h"


#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define BtnColor [UIColor colorWithRed:0.01f green:0.45f blue:0.88f alpha:1.00f]     //按钮的颜色  蓝色


@interface PasswordAlertView ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel     *lineLabel1;
@property (nonatomic,strong) UIButton    *cancelBtn;//取消
@property (nonatomic,strong) UILabel     *titlaLabel;//标题
@property (nonatomic,strong) UILabel     *lineLabel2;
@property (nonatomic,strong) UIView      *inputBgView;//背景框
@property (nonatomic,strong) UIView      *verticalLine1;//竖线
@property (nonatomic,strong) UIView      *verticalLine2;
@property (nonatomic,strong) UIView      *verticalLine3;
@property (nonatomic,strong) UIView      *verticalLine4;
@property (nonatomic,strong) UIView      *verticalLine5;
@property (nonatomic,strong) UIImageView *circleView1;//圆点背景图
@property (nonatomic,strong) UIImageView *circleView2;
@property (nonatomic,strong) UIImageView *circleView3;
@property (nonatomic,strong) UIImageView *circleView4;
@property (nonatomic,strong) UIImageView *circleView5;
@property (nonatomic,strong) UIImageView *circleView6;
@property (nonatomic,strong) UILabel     *alertLabel;//提示语
@property (nonatomic,strong) UIView      *bgView;//背景框
@property (nonatomic,strong) UIView      *sigleBgView;//单选背景框
@property (nonatomic,strong) UIButton    *confitmBtn;//确定
@property (nonatomic,strong) UIImageView *circleSmallView1;//小圆点
@property (nonatomic,strong) UIImageView *circleSmallView2;//小圆点
@property (nonatomic,strong) UIImageView *circleSmallView3;//小圆点
@property (nonatomic,strong) UIImageView *circleSmallView4;//小圆点
@property (nonatomic,strong) UIImageView *circleSmallView5;//小圆点
@property (nonatomic,strong) UIImageView *circleSmallView6;//小圆点
@end

@implementation PasswordAlertView


-(instancetype)initPasswordView{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 00, ScreenWidth,ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [self addDetailViews];
        
    }
    
    return self;
    
}

-(instancetype)initSingleBtnView{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 00, ScreenWidth,ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [self addDetailViews1];
        
    }
    
    return self;
    
    
    
}

-(void)addDetailViews1{
    
    self.bgView.frame = CGRectMake(ScreenWidth, self.center.y-150, ScreenWidth-40, 200);
    self.bgView.layer.cornerRadius = 15;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    
    self.titlaLabel.text = @"请输入取款密码";
    self.titlaLabel.textColor = [UIColor lightGrayColor];
    self.lineLabel1.backgroundColor = [UIColor clearColor];
    
    [self.bgView addSubview:self.lineLabel1];
    [self.bgView addSubview:self.lineLabel2];
    [self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.confitmBtn];
    [self.bgView addSubview:self.titlaLabel];
    [self.bgView addSubview:self.inputBgView];
    [self.inputBgView addSubview:self.verticalLine1];
    [self.inputBgView addSubview:self.verticalLine2];
    [self.inputBgView addSubview:self.verticalLine3];
    [self.inputBgView addSubview:self.verticalLine4];
    [self.inputBgView addSubview:self.verticalLine5];
    [self.inputBgView addSubview:self.circleView1];
    [self.inputBgView addSubview:self.circleView2];
    [self.inputBgView addSubview:self.circleView3];
    [self.inputBgView addSubview:self.circleView4];
    [self.inputBgView addSubview:self.circleView5];
    [self.inputBgView addSubview:self.circleView6];
    [self.bgView addSubview:self.alertLabel];
    [self.bgView addSubview:self.inputTextField];
    
    [self.circleView1 addSubview:self.circleSmallView1];
    [self.circleView2 addSubview:self.circleSmallView2];
    [self.circleView3 addSubview:self.circleSmallView3];
    [self.circleView4 addSubview:self.circleSmallView4];
    [self.circleView5 addSubview:self.circleSmallView5];
    [self.circleView6 addSubview:self.circleSmallView6];
    
    [self initDetailViews1];

    
}

-(void)show{
    [self.inputTextField becomeFirstResponder];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.bgView.frame = CGRectMake(20, self.center.y-150, ScreenWidth-40, 200);

        
    }];
    
    
}


-(void)passwordShow{
    
    [self.inputTextField becomeFirstResponder];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.bgView.frame = CGRectMake(0,  ScreenHeight/2-100, ScreenWidth, ScreenHeight/2);
        
    }];

    
}
//确认按钮
-(void)clickCofirmBtn{
    
    if (self.passWordTextConfirm) {
        self.passWordTextConfirm(self.inputTextField.text);
    }
    
    [self removeFromSuperview];
    
}

//取消按钮
-(void)cancelBtnClicked{
    [self.inputTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-320);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
    
}

//密码文字改变
-(void)inputTextChanged:(UITextField *)textField{
    
    //密码文字回调
    if (self.passWordText) {
        self.passWordText(textField.text);
    }
    
    if (textField.text.length == 1) {
        self.circleSmallView1.hidden = NO;self.circleSmallView2.hidden = YES;
        self.circleSmallView3.hidden = YES;self.circleSmallView4.hidden = YES;
        self.circleSmallView5.hidden = YES;self.circleSmallView6.hidden = YES;
    }else if (textField.text.length == 2){
        self.circleSmallView1.hidden = NO;self.circleSmallView2.hidden = NO;
        self.circleSmallView3.hidden = YES;self.circleSmallView4.hidden = YES;
        self.circleSmallView5.hidden = YES;self.circleSmallView6.hidden = YES;
        
    }else if (textField.text.length == 3){
        self.circleSmallView1.hidden = NO;self.circleSmallView2.hidden = NO;
        self.circleSmallView3.hidden = NO;self.circleSmallView4.hidden = YES;
        self.circleSmallView5.hidden = YES;self.circleSmallView6.hidden = YES;
        
    }else if (textField.text.length == 4){
        self.circleSmallView1.hidden = NO;self.circleSmallView2.hidden = NO;
        self.circleSmallView3.hidden = NO;self.circleSmallView4.hidden = NO;
        self.circleSmallView5.hidden = YES;self.circleSmallView6.hidden = YES;
    }else if (textField.text.length == 5){
        self.circleSmallView1.hidden = NO;self.circleSmallView2.hidden = NO;
        self.circleSmallView3.hidden = NO;self.circleSmallView4.hidden = NO;
        self.circleSmallView5.hidden = NO;self.circleSmallView6.hidden = YES;
    }else if (textField.text.length == 6){
        self.circleSmallView1.hidden = NO;self.circleSmallView2.hidden = NO;
        self.circleSmallView3.hidden = NO;self.circleSmallView4.hidden = NO;
        self.circleSmallView5.hidden = NO;self.circleSmallView6.hidden = NO;
    }else if (textField.text.length == 0){
        self.circleSmallView1.hidden = YES;self.circleSmallView2.hidden = YES;
        self.circleSmallView3.hidden = YES;self.circleSmallView4.hidden = YES;
        self.circleSmallView5.hidden = YES;self.circleSmallView6.hidden = YES;
        
    }
    
    if (textField.text.length == 6) {
        self.confitmBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
        self.confitmBtn.userInteractionEnabled = YES;
    }else{
        self.confitmBtn.backgroundColor = [UIColor grayColor];
        self.confitmBtn.userInteractionEnabled = NO;
        
    }
    
    
    
}


#pragma mark -textFieldDelegte
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.inputTextField) {
        
        if (range.location >= 6) {
            return NO;
        }
        
        return YES;
    }
    
    return YES;
    
}

-(void)addDetailViews{
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.lineLabel1];
    [self.bgView addSubview:self.lineLabel2];
    [self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.titlaLabel];
    [self.bgView addSubview:self.inputBgView];
    [self.inputBgView addSubview:self.verticalLine1];
    [self.inputBgView addSubview:self.verticalLine2];
    [self.inputBgView addSubview:self.verticalLine3];
    [self.inputBgView addSubview:self.verticalLine4];
    [self.inputBgView addSubview:self.verticalLine5];
    [self.inputBgView addSubview:self.circleView1];
    [self.inputBgView addSubview:self.circleView2];
    [self.inputBgView addSubview:self.circleView3];
    [self.inputBgView addSubview:self.circleView4];
    [self.inputBgView addSubview:self.circleView5];
    [self.inputBgView addSubview:self.circleView6];
    [self.bgView addSubview:self.alertLabel];
    [self.bgView addSubview:self.inputTextField];
    
    [self.circleView1 addSubview:self.circleSmallView1];
    [self.circleView2 addSubview:self.circleSmallView2];
    [self.circleView3 addSubview:self.circleSmallView3];
    [self.circleView4 addSubview:self.circleSmallView4];
    [self.circleView5 addSubview:self.circleSmallView5];
    [self.circleView6 addSubview:self.circleSmallView6];
    
    [self initDetailViews];
}

-(void)initDetailViews1{
    [self.lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.top.equalTo(self.bgView.mas_top).offset(0);
        make.height.mas_equalTo(3);
        
    }];
    
    [self.titlaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.top.equalTo(self.lineLabel1.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.top.equalTo(self.lineLabel1.mas_bottom).offset(10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.cancelBtn.mas_bottom).offset(20);
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.height.mas_equalTo(1);
        
    }];
    
    [self.inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLabel2.mas_bottom).offset(20);
        make.left.equalTo(self.bgView.mas_left).offset(50);
        make.right.equalTo(self.bgView.mas_right).offset(-30);
        make.height.mas_equalTo(40);
        
    }];
    
    
    [self.circleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.inputBgView.mas_left).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView1.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView2.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    
    [self.circleView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView3.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView4.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView5.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleSmallView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView1.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView1.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView2.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView2.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView3.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView3.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView4.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView4.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView5.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView5.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView6.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView6.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.verticalLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView1.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
        
    }];
    
    [self.verticalLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView2.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.verticalLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView3.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.verticalLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView4.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.verticalLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView5.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
    }];
    
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.verticalLine2.mas_bottom).offset(20);
        make.right.equalTo(self.bgView.mas_left).offset(-30);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(10);
        
    }];

    
    [self.confitmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.bgView.mas_left).offset(30);
        make.right.equalTo(self.bgView.mas_right).offset(-30);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
        make.height.mas_equalTo(40);
        
    }];

    
    
}

-(void)initDetailViews{
    [self.lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.top.equalTo(self.bgView.mas_top).offset(0);
        make.height.mas_equalTo(3);
        
    }];
    
    [self.titlaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.top.equalTo(self.lineLabel1.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.top.equalTo(self.lineLabel1.mas_bottom).offset(10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.cancelBtn.mas_bottom).offset(20);
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.height.mas_equalTo(1);
        
    }];
    
    [self.inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLabel2.mas_bottom).offset(20);
        make.left.equalTo(self.bgView.mas_left).offset(50);
        make.right.equalTo(self.bgView.mas_right).offset(-30);
        make.height.mas_equalTo(40);
        
    }];
    
    
    [self.circleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.inputBgView.mas_left).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView1.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView2.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    
    [self.circleView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView3.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView4.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.circleView5.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.equalTo(self.inputBgView.mas_width).multipliedBy(0.167);
        
        
    }];
    
    [self.circleSmallView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView1.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView1.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView2.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView2.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView3.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView3.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView4.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView4.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView5.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView5.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.circleSmallView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView6.mas_centerX).offset(0);
        make.centerY.equalTo(self.circleView6.mas_centerY).offset(0);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        
    }];
    
    [self.verticalLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView1.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
        
    }];
    
    [self.verticalLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView2.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.verticalLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView3.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.verticalLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView4.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
    }];
    
    [self.verticalLine5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleView5.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_top).offset(0);
        make.bottom.equalTo(self.inputBgView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
    }];
    
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.top.equalTo(self.inputBgView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.verticalLine2.mas_bottom).offset(20);
        make.right.equalTo(self.bgView.mas_left).offset(-30);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(10);
        
    }];
    
}







//*****************懒加载****************//
-(UIButton *)confitmBtn{
    if (!_confitmBtn) {
        _confitmBtn = [[UIButton alloc]init];
        _confitmBtn.userInteractionEnabled = NO;
        _confitmBtn.backgroundColor = [UIColor grayColor];
        _confitmBtn.layer.cornerRadius = 15;
        _confitmBtn.layer.masksToBounds = YES;
        [_confitmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confitmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confitmBtn addTarget:self action:@selector(clickCofirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confitmBtn;
    
}

-(UIImageView *)circleSmallView1{
    
    if (!_circleSmallView1) {
        _circleSmallView1 = [[UIImageView alloc]init];
        _circleSmallView1.image = [UIImage imageNamed:@"NF密码icon"];
        _circleSmallView1.hidden = YES;
    }
    return _circleSmallView1;
    
}

-(UIImageView *)circleSmallView2{
    
    if (!_circleSmallView2) {
        _circleSmallView2 = [[UIImageView alloc]init];
        _circleSmallView2.image = [UIImage imageNamed:@"NF密码icon"];
        _circleSmallView2.hidden = YES;
    }
    return _circleSmallView2;
    
}

-(UIImageView *)circleSmallView3{
    
    if (!_circleSmallView3) {
        _circleSmallView3 = [[UIImageView alloc]init];
        _circleSmallView3.image = [UIImage imageNamed:@"NF密码icon"];
        _circleSmallView3.hidden = YES;
    }
    return _circleSmallView3;
    
}

-(UIImageView *)circleSmallView4{
    
    if (!_circleSmallView4) {
        _circleSmallView4 = [[UIImageView alloc]init];
        _circleSmallView4.image = [UIImage imageNamed:@"NF密码icon"];
        _circleSmallView4.hidden = YES;
    }
    return _circleSmallView4;
    
}

-(UIImageView *)circleSmallView5{
    
    if (!_circleSmallView5) {
        _circleSmallView5 = [[UIImageView alloc]init];
        _circleSmallView5.image = [UIImage imageNamed:@"NF密码icon"];
        _circleSmallView5.hidden = YES;
    }
    return _circleSmallView5;
    
}

-(UIImageView *)circleSmallView6{
    
    if (!_circleSmallView6) {
        _circleSmallView6 = [[UIImageView alloc]init];
        _circleSmallView6.image = [UIImage imageNamed:@"NF密码icon"];
        _circleSmallView6.hidden = YES;
    }
    return _circleSmallView6;
    
}



-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight/2-70, ScreenWidth, ScreenHeight/2)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
-(UILabel *)lineLabel1{
    if (!_lineLabel1) {
        _lineLabel1 = [[UILabel alloc]init];
        _lineLabel1.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineLabel1;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"mobileredpacketdelegate"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
    
    
}

-(UILabel *)titlaLabel{
    if (!_titlaLabel) {
        _titlaLabel = [[UILabel alloc]init];
        _titlaLabel.text = @"请输入密码";
        _titlaLabel.textAlignment = 1;
        _titlaLabel.font = [UIFont systemFontOfSize:18];
        _titlaLabel.textColor = BtnColor;
    }
    
    return _titlaLabel;
    
}

-(UILabel *)lineLabel2{
    
    if (!_lineLabel2) {
        _lineLabel2 = [[UILabel alloc]init];
        _lineLabel2.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineLabel2;
    
}

-(UIView *)inputBgView{
    if (!_inputBgView) {
        _inputBgView = [[UIView alloc]init];
        _inputBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputBgView.layer.borderWidth = 1;
    }
    
    return _inputBgView;
    
}

-(UIView *)verticalLine1{
    if (!_verticalLine1) {
        _verticalLine1 = [[UIView alloc]init];
        _verticalLine1.backgroundColor = [UIColor lightGrayColor];
    }
    return _verticalLine1;
}

-(UIView *)verticalLine2{
    if (!_verticalLine2) {
        _verticalLine2 = [[UIView alloc]init];
        _verticalLine2.backgroundColor = [UIColor lightGrayColor];
    }
    return _verticalLine2;
    
}

-(UIView *)verticalLine3{
    if (!_verticalLine3) {
        _verticalLine3 = [[UIView alloc]init];
        _verticalLine3.backgroundColor = [UIColor lightGrayColor];
    }
    return _verticalLine3;
    
}
-(UIView *)verticalLine4{
    
    if (!_verticalLine4) {
        _verticalLine4 = [[UIView alloc]init];
        _verticalLine4.backgroundColor = [UIColor lightGrayColor];
    }
    return _verticalLine4;
    
}
-(UIView *)verticalLine5{
    
    if (!_verticalLine5) {
        _verticalLine5 = [[UIView alloc]init];
        _verticalLine5.backgroundColor = [UIColor lightGrayColor];
    }
    return _verticalLine5;
}

-(UIImageView *)circleView1{
    
    if (!_circleView1) {
        _circleView1 = [[UIImageView alloc]init];
//        _circleView1.backgroundColor = [UIColor blackColor];
//        _circleView1.layer.cornerRadius = 20;
//        _circleView1.layer.masksToBounds = YES;
    }
    
    return _circleView1;
}

-(UIImageView *)circleView2{
    
    
    if (!_circleView2) {
        _circleView2 = [[UIImageView alloc]init];

    }
    
    return _circleView2;
    
}

-(UIImageView *)circleView3{
    
    if (!_circleView3) {
        _circleView3 = [[UIImageView alloc]init];

    }
    
    return _circleView3;
    
}

-(UIImageView *)circleView4{
    if (!_circleView4) {
        _circleView4 = [[UIImageView alloc]init];
 
    }
    
    return _circleView4;
}

-(UIImageView *)circleView5{
    
    if (!_circleView5) {
        _circleView5 = [[UIImageView alloc]init];

    }
    
    return _circleView5;
}

-(UIImageView *)circleView6{
    
    if (!_circleView6) {
        _circleView6 = [[UIImageView alloc]init];

    }
    
    return _circleView6;
    
}
-(UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]init];
        _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_inputTextField addTarget:self action:@selector(inputTextChanged:) forControlEvents:UIControlEventEditingChanged];
        _inputTextField.delegate = self;
    }
    
    return _inputTextField;
    
}

-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
       // _alertLabel.text = @"密码输入错误,请重新输入!";
        _alertLabel.font = [UIFont systemFontOfSize:15];
        _alertLabel.textColor = [UIColor orangeColor];
        _alertLabel.textAlignment = 1;
    }
    
    return _alertLabel;
}


@end
