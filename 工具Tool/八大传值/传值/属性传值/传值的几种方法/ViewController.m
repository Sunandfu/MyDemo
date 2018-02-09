//
//  ViewController.m
//  传值的几种方法
//
//  Created by lin zhi qing on 16/3/28.
//  Copyright © 2016年 linzhiqing. All rights reserved.
//

#import "ViewController.h"
#import "ZQResignVC.h"
#import "ZQMainVC.h"
#define SHeight self.view.frame.size.height
#define SWidth self.view.frame.size.width
@interface ViewController ()<UITextFieldDelegate>{
    UITextField *_userNameText;
    UITextField *_passWordText;
    UIButton  *_loginBtn;
    UIButton *_resignBtn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"登录";
   
    //账号
    _userNameText=[self getTextField:100 leftViewName:@" 用户名:"];
    //密码
    _passWordText=[self getTextField:CGRectGetMaxY(_userNameText.frame)+20 leftViewName:@" 密码:"];
    //登录按钮
    
    _loginBtn=[self buttonInitWith:CGRectMake(SWidth-20-100, CGRectGetMaxY(_passWordText.frame)+50, 100, 45) withTitle:@"登录" withBlock:^{
        
    }];
    _loginBtn.backgroundColor=[UIColor purpleColor];
    //注册按钮
    _resignBtn=[self buttonInitWith:CGRectMake(20, CGRectGetMaxY(_passWordText.frame)+50, 100, 45) withTitle:@"注册" withBlock:^{
        
    }];
    _resignBtn.backgroundColor=[UIColor redColor];
    
    //
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)buttonClick:(UIButton *)button{
    [self textResignFirstResponder];
    if ([button.titleLabel.text isEqualToString:@"注册"]) {
        NSLog(@"注册");
        ZQResignVC *resignVC=[[ZQResignVC alloc]init];
        [self.navigationController pushViewController:resignVC animated:YES];
    }
    if ([button.titleLabel.text isEqualToString:@"登录"]) {
        NSLog(@"登录");
    /***********属性传值*******************/
        ZQMainVC *mainVC=[[ZQMainVC alloc]init];
        mainVC.userName=_userNameText.text;
        mainVC.passWord=_passWordText.text;
        [self.navigationController pushViewController:mainVC animated:YES];

        

        
    }
    
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
@end
