//
//  ZQMainVC.m
//  传值的几种方法
//
//  Created by lin zhi qing on 16/3/28.
//  Copyright © 2016年 linzhiqing. All rights reserved.
//

#import "ZQMainVC.h"
#define SHeight self.view.frame.size.height
#define SWidth self.view.frame.size.width
@interface ZQMainVC (){
    UITextField *_userNameText;
    UITextField *_passWordText;
    
}

@end

@implementation ZQMainVC

-(id)initWithUserName:(NSString *)userName WithPassWord:(NSString *)passWord {
    self = [super init];
        if (self) {
            // Custom initialization
            _passWord=passWord;
            _userName=userName;
        }
        return self;
   
}

- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor whiteColor];
    [super viewDidLoad];
   
    self.title=@"首页";
    //账号
    _userNameText=[self getTextField:100 leftViewName:@" 用户名:"];
    _userNameText.text=_userName;
    //密码
    _passWordText=[self getTextField:CGRectGetMaxY(_userNameText.frame)+20 leftViewName:@" 密码:"];
    _passWordText.text=_passWord;
    
    
    // Do any additional setup after loading the view.
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
    textField.userInteractionEnabled=NO;
    textField.leftViewMode=UITextFieldViewModeAlways;
    return textField;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
