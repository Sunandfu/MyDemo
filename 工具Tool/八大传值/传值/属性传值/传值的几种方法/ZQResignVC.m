//
//  ZQResignVC.m
//  传值的几种方法
//
//  Created by lin zhi qing on 16/3/28.
//  Copyright © 2016年 linzhiqing. All rights reserved.
//

#import "ZQResignVC.h"
#define SHeight self.view.frame.size.height
#define SWidth self.view.frame.size.width
@interface ZQResignVC ()<UITextFieldDelegate>{
    UITextField *_userNameText;
    UITextField *_passWordText;
    UIButton  *_loginBtn;
    UIButton *_resignBtn;
}

@end

@implementation ZQResignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"注册";
    //账号
    _userNameText=[self getTextField:100 leftViewName:@" 用户名:"];
    //密码
    _passWordText=[self getTextField:CGRectGetMaxY(_userNameText.frame)+20 leftViewName:@" 密码:"];
    //登录按钮
    
    _loginBtn=[self buttonInitWith:CGRectMake((SWidth-100)/2, CGRectGetMaxY(_passWordText.frame)+50, 100, 45) withTitle:@"确定" withBlock:^{
        
    }];
    _loginBtn.backgroundColor=[UIColor purpleColor];
        _resignBtn.backgroundColor=[UIColor redColor];
    // Do any additional setup after loading the view.
}
-(void)buttonClick:(UIButton *)button{
    [self textResignFirstResponder];
       [self.navigationController popToRootViewControllerAnimated: YES];
}
-(UITextField *)getTextField:(CGFloat )y leftViewName:(NSString *)name{
    UITextField *  textField=[[UITextField alloc]initWithFrame:CGRectMake(20, y,SWidth-40, 45)];
    textField.layer.borderWidth=1.0f;
    [self.view addSubview:textField];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    label.text=name;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth=YES;
    textField.leftView=label;
    textField.delegate=self;
    textField.leftViewMode=UITextFieldViewModeAlways;
    return textField;
    
}
-(UIButton *)buttonInitWith:(CGRect)frame withTitle:(NSString *)name withBlock:(void(^)())block{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=frame;
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    block();
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
    
}
-(void)textResignFirstResponder{
    [_userNameText resignFirstResponder];
    [_passWordText resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self textResignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self textResignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
