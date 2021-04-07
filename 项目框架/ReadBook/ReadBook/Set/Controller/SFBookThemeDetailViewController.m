//
//  SFBookThemeDetailViewController.m
//  ReadBook
//
//  Created by lurich on 2020/12/21.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBookThemeDetailViewController.h"
#import "WSColorImageView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface SFBookThemeDetailViewController ()

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet WSColorImageView *colorImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bjsTextField;
@property (weak, nonatomic) IBOutlet UITextField *wzysTextField;
@property (weak, nonatomic) IBOutlet UIButton *savebtn;

@end

@implementation SFBookThemeDetailViewController

- (void)viewDidLoad {
    self.title = @"取色板";
    [super viewDidLoad];
    if (self.dict) {
        self.nameTextField.text = self.dict[@"name"];
        self.bjsTextField.text = self.dict[@"color"];
        self.wzysTextField.text = self.dict[@"textColor"];
    }
    // Do any additional setup after loading the view from its nib.
    MJWeakSelf;
    self.colorImageView.currentColorBlock = ^(UIColor *color){
        UIView *firstResponder = [weakSelf KeyboardAvoiding_findFirstResponderBeneathView:weakSelf.view];
        if (firstResponder) {
            UITextField *textField = (UITextField *)firstResponder;
            textField.text = [SFTool hexadecimalFromUIColor:color];
            UILabel *label = [weakSelf.view viewWithTag:textField.tag+10];
            label.textColor = color;
        }
    };
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.savebtn.layer.cornerRadius = self.savebtn.bounds.size.height/2;
    self.savebtn.layer.masksToBounds = YES;
    self.colorImageView.layer.cornerRadius = self.colorImageView.bounds.size.height/2.0;
    self.colorImageView.layer.masksToBounds = YES;
}
//邮箱
- (BOOL)validateHexColor:(NSString *)email
{
    NSString *emailRegex = @"[#]{0,1}[0-9A-Fa-f]{6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (IBAction)saveBtnClick:(UIButton *)sender {
    if (self.nameTextField.text>0 && self.bjsTextField.text>0 && self.wzysTextField.text>0) {
        if ([self validateHexColor:self.bjsTextField.text] && [self validateHexColor:self.wzysTextField.text]) {
            if (self.dict) {
                NSMutableDictionary *mudict = [NSMutableDictionary dictionaryWithDictionary:self.dict];
                mudict[@"name"] = self.nameTextField.text;
                mudict[@"color"] = self.bjsTextField.text;
                mudict[@"textColor"] = self.wzysTextField.text;
                NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:DCBookThemePath];
                NSArray *tmpList = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:nil];
                NSMutableArray *mutArr = [NSMutableArray arrayWithArray:tmpList];
                for (int i=0; i<tmpList.count; i++) {
                    NSDictionary *tmpDict = tmpList[i];
                    if ([tmpDict[@"themeId"] isEqualToString:self.dict[@"themeId"]]) {
                        [mutArr replaceObjectAtIndex:i withObject:mudict];
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutArr options:1 error:nil];
                        [jsonData writeToFile:DCBookThemePath atomically:YES];
                        NSLog(@"主题存储成功：%@",DCBookThemePath);
                        [SVProgressHUD showSuccessWithStatus:@"主题修改成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        return;
                    }
                }
            } else {
                NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:DCBookThemePath];
                NSArray *tmpList = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:nil];
                NSMutableArray *mutArr = [NSMutableArray arrayWithArray:tmpList];
                NSMutableDictionary *themeDict = [NSMutableDictionary dictionary];
                [themeDict setValue:self.nameTextField.text forKey:@"name"];
                [themeDict setValue:[SFTool getTimeLocal] forKey:@"themeId"];
                [themeDict setValue:@"1" forKey:@"isCustom"];
                [themeDict setValue:@"icon_theme_custom_28x28_" forKey:@"normalIcon"];
                [themeDict setValue:@"icon_theme_custom_sel_28x28_" forKey:@"selectIcon"];
                [themeDict setValue:self.bjsTextField.text forKey:@"color"];
                [themeDict setValue:@"F7F7F7" forKey:@"controlViewBgColor"];
                [themeDict setValue:self.wzysTextField.text forKey:@"textColor"];
                [themeDict setValue:@"666666" forKey:@"settingTextColor"];
                [themeDict setValue:@"icon_adjust_button_30x30_" forKey:@"sliderThumb"];
                [themeDict setValue:@"DAD9DF" forKey:@"settingBtnColor"];
                [themeDict setValue:@"999999" forKey:@"chapterColor"];
                [themeDict setValue:@"333333" forKey:@"sourceColor"];
                [themeDict setValue:@"" forKey:@"bgImage"];
                [mutArr addObject:themeDict];
                //首先判断能否转化为一个json数据，如果能，接下来先把foundation对象转化为NSData类型，然后写入文件
                if ([NSJSONSerialization isValidJSONObject:mutArr]) {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutArr options:1 error:nil];
                    [jsonData writeToFile:DCBookThemePath atomically:YES];
                    NSLog(@"主题存储成功：%@",DCBookThemePath);
                    [SVProgressHUD showSuccessWithStatus:@"主题保存成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"请正确填写颜色值"];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"请全部填写"];
    }
}

- (UIView*)KeyboardAvoiding_findFirstResponderBeneathView:(UIView *)view {
    // Search recursively for first responder
    for (UIView *childView in view.subviews ) {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder]) return childView;
        UIView *result = [self KeyboardAvoiding_findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
