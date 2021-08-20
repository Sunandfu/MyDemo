//
//  ZMEditPersonView.m
//  ZMAddressBook
//
//  Created by ZengZhiming on 2017/4/11.
//  Copyright © 2017年 菜鸟基地. All rights reserved.
//

#import "ZMEditPersonView.h"

@interface ZMEditPersonView ()

@property (nonatomic, strong) UIButton *boxButton;          //!< 弹框ButtonView.

@property (nonatomic, strong) UILabel *firstNameLabel;      //!< FirstName标签.
@property (nonatomic, strong) UILabel *lastNameLabel;       //!< LastName标签.
@property (nonatomic, strong) UILabel *phoneLabel;          //!< Phone标签.

@property (nonatomic, strong) UITextField *firstNameField;  //!< FisrtName输入框.
@property (nonatomic, strong) UITextField *lastNameField;   //!< LastName输入框.
@property (nonatomic, strong) UITextField *phoneField;      //!< Phone输入框.

@property (nonatomic, strong) UIButton *submitButton;       //!< 提交按钮.

@property (nonatomic, strong) ZMPersonModel *personModel;   //!< Person数据.

@property (nonatomic, copy) void(^submitBlock)(int code, ZMPersonModel *personModel); //!< 提交回调.

@end

@implementation ZMEditPersonView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化Subview
        [self initSubview];
    }
    return self;
}


- (instancetype)init
{
    self = [super initWithFrame:MAIN_SCREEN_FRAME];
    if (self) {
        // 初始化Subview
        [self initSubview];
    }
    return self;
}


/**
 显示修改View

 @param personModel 修改前数据
 @param submitBlock 修改后回调
 */
- (void)showView:(ZMPersonModel *)personModel submitBlock:(void (^)(int code, ZMPersonModel *personModel))submitBlock
{
    _personModel = personModel;
    _firstNameField.text = personModel.firstName;
    _lastNameField.text = personModel.lastName;
    _phoneField.text = [personModel.phones firstObject].content;
    _submitBlock = submitBlock;
    
    // 将DialogView显示到Window上
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    [window addSubview:self];
}


/** 移除View */
- (void)dismissView
{
    _personModel = nil;
    _firstNameField.text = nil;
    _lastNameField.text = nil;
    _phoneField.text = nil;
    _submitBlock = nil;
    [self removeFromSuperview];
}


/** 初始化Subview */
- (void)initSubview
{
    // 设置背景
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    // 设置boxButton
    _boxButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _boxButton.backgroundColor = [UIColor whiteColor];
    _boxButton.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.4);
    _boxButton.layer.cornerRadius = 5.0;
    [self addSubview:_boxButton];
    
    // 基数Y
    int baseY = 40;
    
    // 设置firstNameLabel
    _firstNameLabel = [self creatLabel];
    _firstNameLabel.center = CGPointMake(50, baseY*1);
    _firstNameLabel.text = @"FirstName:";
    [_boxButton addSubview:_firstNameLabel];
    
    // 设置lastNameLabel
    _lastNameLabel = [self creatLabel];
    _lastNameLabel.center = CGPointMake(50, baseY*2);
    _lastNameLabel.text = @"LastName:";
    [_boxButton addSubview:_lastNameLabel];
    
    // 设置phoneLabel
    _phoneLabel = [self creatLabel];
    _phoneLabel.center = CGPointMake(50, baseY*3);
    _phoneLabel.text = @"Phone:";
    [_boxButton addSubview:_phoneLabel];
    
    // 设置firstNameField
    _firstNameField = [self creatTextField];
    _firstNameField.center = CGPointMake(200, baseY*1);
    [_boxButton addSubview:_firstNameField];
    
    // 设置lastNameField
    _lastNameField = [self creatTextField];
    _lastNameField.center = CGPointMake(200, baseY*2);
    [_boxButton addSubview:_lastNameField];
    
    // 设置phoneField
    _phoneField = [self creatTextField];
    _phoneField.center = CGPointMake(200, baseY*3);
    [_boxButton addSubview:_phoneField];
    
    // 设置submitButton
    _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(onSubmitButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [_submitButton sizeToFit];
    _submitButton.center = CGPointMake(150, baseY*4+10);
    [_boxButton addSubview:_submitButton];
}


// 创建Label
- (UILabel *)creatLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentRight;
    label.frame = CGRectMake(0, 0, 100, 30);
    return label;
}


// 创建TextField
- (UITextField *)creatTextField
{
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.frame = CGRectMake(0, 0, 180, 30);
    return textField;
}


// 提交按钮点击响应
- (void)onSubmitButtonAction:(UIButton *)action
{
    // 空值判断
    if (_phoneField.text == nil || _phoneField.text.length == 0) {
        return;
    }
    
    // 创建ZMPersonModel
    if (_personModel == nil) {
        _personModel = [[ZMPersonModel alloc] init];
    }
    
    // 构建电话数组
    NSMutableArray<ZMLabelStringModel *> *phones = [NSMutableArray arrayWithArray:_personModel.phones];
    ZMLabelStringModel *phoneModel = [phones firstObject];
    if (phoneModel) {
        phoneModel.content = _phoneField.text;
    } else {
        phoneModel = [[ZMLabelStringModel alloc] init];
        phoneModel.label = (__bridge NSString *)(kABPersonPhoneMobileLabel);
        phoneModel.content = _phoneField.text;
        [phones addObject:phoneModel];
    }
    
    // 更新数据
    _personModel.phones = phones;
    _personModel.firstName = _firstNameField.text;
    _personModel.lastName = _lastNameField.text;
    
    // 回调数据
    if (_submitBlock) _submitBlock(1, _personModel);
    
    [self dismissView];
}


/** 重新TouchesBegan, 监听取消事件*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // 移除View
    [self dismissView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
