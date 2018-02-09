//
//  CWNumberKeyboard.m
//  CWNumberKeyboardDemo
//
//  Created by william on 16/3/19.
//  Copyright © 2016年 陈大威. All rights reserved.
//
#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)                 //屏幕宽度
#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)                //屏幕长度
#define CUSTOM_KEYBOARD_HEIGHT   260           //自定义键盘高度
#define RGBCOLORVA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#import "CWNumberKeyboard.h"

@interface CWNumberKeyboard()
@property (weak, nonatomic) IBOutlet UITextField *mTextNumberFiled;
@property (strong, nonatomic) IBOutlet UIView *mKeyboardView;
@property (weak, nonatomic) IBOutlet UIButton *mDeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *mResignBtn;
@property (nonatomic , copy) numberKeyboardBlock block;
@end

@implementation CWNumberKeyboard
- (id)init
{
    self = [super init];
    
    if(self)
    {
        // 添加keyboardview
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self setBackgroundColor:RGBCOLORVA(0x000000, 0.2)];
        [[NSBundle mainBundle] loadNibNamed:@"CWNumberKeyboard" owner:self options:nil];
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapAction:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
        
        self.mKeyboardView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CUSTOM_KEYBOARD_HEIGHT);
        [self addSubview:self.mKeyboardView];
        _mTextNumberFiled.placeholder = @"0.00";
        //将UITextField键盘设置为空 有光标 但是不弹出键盘 这一步很重要
        _mTextNumberFiled.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 设置图片
        [self.mDeleteBtn setImage:[UIImage imageNamed:@"CWNumberKeyboard.bundle/delete.png"]
                        forState:UIControlStateNormal];
        [self.mResignBtn setImage:[UIImage imageNamed:@"CWNumberKeyboard.bundle/resign.png"]
                        forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)showNumKeyboardViewAnimateWithPrice:(NSString *)priceString andBlock:(numberKeyboardBlock)block{
    _block = block;
    float vaule = self.mTextNumberFiled.text.floatValue;
    [self.mTextNumberFiled setText:(0 == vaule)?@"":priceString];
    [self setBackgroundColor:RGBCOLORVA(0x000000, 0.2)];
    [UIView animateWithDuration:0.2 animations:^{
        self.mKeyboardView.frame = CGRectMake(0, SCREEN_HEIGHT-CUSTOM_KEYBOARD_HEIGHT, SCREEN_WIDTH, CUSTOM_KEYBOARD_HEIGHT);
        
    } completion:^(BOOL finished) {
        [self.mTextNumberFiled becomeFirstResponder];
    }];
}
- (void)hideNumKeyboardViewWithAnimateWithConfirm:(BOOL)isConfirm{
    [UIView animateWithDuration:0.2 animations:^{
        self.mKeyboardView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CUSTOM_KEYBOARD_HEIGHT);
        
    } completion:^(BOOL finished) {
        if (isConfirm) {
            float vaule = self.mTextNumberFiled.text.floatValue;
            _block([NSString stringWithFormat:@"%0.2lf",vaule]);
        }
        [self.mTextNumberFiled resignFirstResponder];
        [self setBackgroundColor:[UIColor clearColor]];
        self.hidden = YES;
    }];
}
-(void)bgViewTapAction:(UITapGestureRecognizer*)recognizer
{
    [self hideNumKeyboardViewWithAnimateWithConfirm:NO];
}

/*
 1000->0
 1001->1
 1002->2
 1003->3
 1004->4
 1005->5
 1006->6
 1007->7
 1008->8
 1009->9
 1010->.
 1011->消失
 1012->删除
 1013->确认
 */
- (IBAction)keyboardViewAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    switch (tag)
    {
        case 1010:
        {
            // 小数点
            if(self.mTextNumberFiled.text.length > 0 && ![self.mTextNumberFiled.text containsString:@"."]){
                [self.mTextNumberFiled insertText:@"."];
            }
            
        }
            break;
        case 1011:
        {
            // 取消
            [self hideNumKeyboardViewWithAnimateWithConfirm:NO];
        }
            break;
        case 1012:
        {
            // 删除
            if(self.mTextNumberFiled.text.length > 0)
                [self.mTextNumberFiled deleteBackward];
        }
            break;
        case 1013:
        {
            //确定 文本框失去焦点 并且下滑消失
            [self hideNumKeyboardViewWithAnimateWithConfirm:YES];
            
        }
            break;
        default:
        {
            // 数字
            // 含有小数点
            if([self.mTextNumberFiled.text containsString:@"."]){
                NSRange ran = [self.mTextNumberFiled.text rangeOfString:@"."];
                if (self.mTextNumberFiled.text.length - ran.location <= 2) {
                    NSString *text = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
                    [self.mTextNumberFiled insertText:text];
                }
            }else{
                NSString *text = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
                [self.mTextNumberFiled insertText:text];
            }
            
            
        }
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
