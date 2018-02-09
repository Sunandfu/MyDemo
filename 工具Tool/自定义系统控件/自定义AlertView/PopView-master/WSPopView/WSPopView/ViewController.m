//
//  ViewController.h
//  WSPopView
//
//  Created by iMac on 17/3/2.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "ViewController.h"
#import "FFToast.h"
#import "NSString+FFToast.h"
#import "UIImage+FFToast.h"


@interface ViewController ()

@property(nonatomic,strong)FFToast *popView;

@property(nonatomic,strong)FFToast *customPopView;

@end

@implementation ViewController


-(FFToast *)popView {
    if (!_popView) {
        _popView = [[FFToast alloc]initToastWithTitle:@"这里显示您要弹出的标题名称" message:@"这里显示您要弹出的详细内容。O(∩_∩)O" iconImage:nil];
        _popView.duration = 2.0f;
        _popView.toastType = FFToastTypeDefault;//显示类型
        _popView.toastPosition = FFToastPositionDefault;//显示的位置
    }
    return _popView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:110/255.0 green:206/255.0 blue:249/255.0 alpha:1];
    
    
    
    //滑块的值
    UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, 20)];
    valueLabel.text = @"弹窗停留时间：2.0s";
    valueLabel.textColor = [UIColor lightGrayColor];
    valueLabel.tag = 10;
    [self.view addSubview:valueLabel];
    
    //滑块
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(valueLabel.frame)+5, self.view.frame.size.width-40, 40)];
    slider.minimumValue = 0;
    slider.maximumValue = 10;
    [slider setValue:2 animated:YES];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    
    //弹窗位置
    UISegmentedControl *positionSegmentctrl = [[UISegmentedControl alloc]initWithItems:@[@"最顶部",@"状态栏下面",@"底部",@"中间"]];
    positionSegmentctrl.frame = CGRectMake(20, CGRectGetMaxY(slider.frame)+30, self.view.frame.size.width-40, 40);
    positionSegmentctrl.selectedSegmentIndex = 0;
    [self.view addSubview:positionSegmentctrl];
    positionSegmentctrl.tag = 110;
    [positionSegmentctrl addTarget:self action:@selector(positionAndCornerSegAction) forControlEvents:UIControlEventValueChanged];
    
    //弹窗类型
    UISegmentedControl *styleSegmentctrl = [[UISegmentedControl alloc]initWithItems:@[@"默认",@"成功",@"失败",@"警告",@"提示"]];
    styleSegmentctrl.frame = CGRectMake(20, CGRectGetMaxY(positionSegmentctrl.frame)+30, self.view.frame.size.width-40, 40);
    styleSegmentctrl.selectedSegmentIndex = 0;
    [self.view addSubview:styleSegmentctrl];
    [styleSegmentctrl addTarget:self action:@selector(styleSegAction:) forControlEvents:UIControlEventValueChanged];

    
    
    //是否圆角 (只对状态栏下面、底部、中间 有效)
    UISegmentedControl *cornerSegmentctrl = [[UISegmentedControl alloc]initWithItems:@[@"非圆角",@"圆角"]];
    cornerSegmentctrl.frame = CGRectMake(20, CGRectGetMaxY(styleSegmentctrl.frame)+30, self.view.frame.size.width-40, 40);
    cornerSegmentctrl.selectedSegmentIndex = 0;
    [self.view addSubview:cornerSegmentctrl];
    cornerSegmentctrl.tag = 111;
    [self.view addSubview:cornerSegmentctrl];
    [cornerSegmentctrl addTarget:self action:@selector(positionAndCornerSegAction) forControlEvents:UIControlEventValueChanged];
    //滑块的值
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMinY(cornerSegmentctrl.frame)-20, self.view.frame.size.width-40, 20)];
    infoLabel.text = @"是否圆角 (只对状态栏下面、底部、中间 有效)";
    infoLabel.font = [UIFont systemFontOfSize:13];
    infoLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:infoLabel];
    
    
    
    //按钮
    NSArray *titleArray = @[@"显示",@"自定义的弹窗",@"可点击的弹窗",@"简单弹窗"];
    for (NSInteger i = 0; i < 4; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, CGRectGetMaxY(cornerSegmentctrl.frame)+30+50*i, self.view.frame.size.width-40, 40);
        button.layer.cornerRadius = 5;
        button.tag = i;
        if (i == 0) {
            button.backgroundColor = styleSegmentctrl.tintColor;;
        }
        else {
            button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        }
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    
    
}

- (void)sliderValueChanged:(UISlider *)slider {
    NSLog(@"%f",slider.value);
    
    
    UILabel *valueLabel = (UILabel *)[self.view viewWithTag:10];
    valueLabel.text = [NSString stringWithFormat:@"弹窗停留时间：%.1fs",slider.value];
    self.popView.duration = slider.value;
}

- (void)positionAndCornerSegAction {    //位置和圆角
    UISegmentedControl *positionSegmentctrl = (UISegmentedControl *)[self.view viewWithTag:110];//弹窗位置
    UISegmentedControl *cornerSegmentctrl = (UISegmentedControl *)[self.view viewWithTag:111];//是否圆角
    NSLog(@"%ld",cornerSegmentctrl.selectedSegmentIndex);
    
    
    /**
     *  下面三句话是为了让中间弹框显示黑色的字，其他的弹框显示白色的字
     */
    self.popView.toastBackgroundColor = nil;
    self.popView.titleTextColor = nil;
    self.popView.messageTextColor = nil;
    
    switch (positionSegmentctrl.selectedSegmentIndex) {
        case 0:
        {
            self.popView.toastPosition = FFToastPositionDefault;//显示的位置
        }
            break;
        case 1:
        {
            self.popView.toastPosition = cornerSegmentctrl.selectedSegmentIndex == 0 ? FFToastPositionBelowStatusBar : FFToastPositionBelowStatusBarWithFillet;//显示的位置
        }
            break;
        case 2:
        {
            self.popView.toastPosition = cornerSegmentctrl.selectedSegmentIndex == 0 ? FFToastPositionBottom : FFToastPositionBottomWithFillet;//显示的位置
        }
            break;
        case 3:
        {
            self.popView.autoDismiss = NO;
            self.popView.toastPosition = cornerSegmentctrl.selectedSegmentIndex == 0 ? FFToastPositionCentre : FFToastPositionCentreWithFillet;//显示的位置
        }
            break;
            
        default:
            break;
    }
    
}

- (void)styleSegAction:(UISegmentedControl *)seg { //显示类型
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            self.popView.toastType = FFToastTypeDefault;
            break;
            
        case 1:
            self.popView.toastType = FFToastTypeSuccess;
            break;
            
        case 2:
            self.popView.toastType = FFToastTypeError;
            break;
            
        case 3:
            self.popView.toastType = FFToastTypeWarning;
            break;
            
        case 4:
            self.popView.toastType = FFToastTypeInfo;
            break;
            
        default:
            break;
    }
    
}


- (void)buttonAction:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
        {
            [self.popView show];
        }
            break;
        case 1:
        {
            [self button2Action:btn];
        }
            break;
        case 2:
        {
            [self button3Action:btn];

        }
            break;
        case 3:
        {
            [self button4Action:btn];

        }
            break;
            
        default:
            break;
    }
    
}

- (void)button2Action:(UIButton *)btn {
    CGFloat horizontalSpaceToScreen = 90;
    CGFloat topSpaceViewToView = 20;
    CGFloat horizontalSpaceToContentView = 10;
    CGFloat bottomSpaceToContentView = 10;
    CGSize topImgSize = CGSizeMake(50, 50);
    
    //顶部图片
    CGFloat topImgViewX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen)/2 - topImgSize.width/2;
    CGFloat topImgViewY = 0;
    UIImageView *topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(topImgViewX, topImgViewY, topImgSize.width, topImgSize.height)];
    topImgView.image = [UIImage imageWithName:@"test_ok"];
    
    NSString *title = @"Customized Toast View";
    NSString *message = @"You can customize the View you need, just create it as a parameter to Toast.";
    
    //设置字体
    UIFont *titleFont = [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium];
    UIFont *messageFont = [UIFont systemFontOfSize:15.f];
    
    CGFloat maxTextWidth = SCREEN_WIDTH - 2*(horizontalSpaceToScreen) - 2 * horizontalSpaceToContentView;
    CGSize titleSize = [NSString sizeForString:title font:titleFont maxWidth:maxTextWidth];
    CGSize messageSize = [NSString sizeForString:message font:messageFont maxWidth:maxTextWidth];
    
    //内容和标题
    CGFloat titleLabelX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen - titleSize.width)/2;
    CGFloat titleLabelY = topImgSize.height/2 + topSpaceViewToView;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.font = titleFont;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
    CGFloat messageLabelX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen - messageSize.width)/2;
    CGFloat messageLabelY = titleLabelY + titleSize.height + topSpaceViewToView;
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(messageLabelX, messageLabelY, messageSize.width, messageSize.height)];
    messageLabel.text = message;
    messageLabel.font = messageFont;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    
    //OK按钮
    CGFloat okBtnX = 5;
    CGFloat okBtnY = messageLabelY + messageSize.height + topSpaceViewToView;
    CGFloat okBtnW = SCREEN_WIDTH - 2*horizontalSpaceToScreen - 10;
    CGFloat okBtnH = 35;
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(okBtnX, okBtnY, okBtnW, okBtnH)];
    okBtn.backgroundColor = [UIColor colorWithRed:0.17 green:0.69 blue:0.55 alpha:1.00];
    [okBtn setTitle:@"ok" forState:UIControlStateNormal];
    okBtn.layer.cornerRadius = 2.f;
    okBtn.layer.masksToBounds = YES;
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat customToastViewX = 0;
    CGFloat customToastViewY = topImgSize.height/2;
    CGFloat customToastViewW = SCREEN_WIDTH - 2 * horizontalSpaceToScreen;
    CGFloat customToastViewH = okBtnY + okBtnH + bottomSpaceToContentView;
    UIView *customToastView = [[UIView alloc]initWithFrame:CGRectMake(customToastViewX, customToastViewY, customToastViewW, customToastViewH)];
    customToastView.backgroundColor = [UIColor whiteColor];
    
    
    [customToastView addSubview: titleLabel];
    [customToastView addSubview: messageLabel];
    [customToastView addSubview: okBtn];
    
    
    CGFloat customToastParentViewW = SCREEN_WIDTH - 2*horizontalSpaceToScreen;
    CGFloat customToastParentViewH = topImgSize.height/2 + customToastViewH;
    CGFloat customToastParentViewX = (SCREEN_WIDTH - customToastParentViewW)/2;
    CGFloat customToastParentViewY = (SCREEN_HEIGHT - customToastParentViewH)/2;
    UIView *customToastParentView = [[UIView alloc]initWithFrame:CGRectMake(customToastParentViewX, customToastParentViewY, customToastParentViewW, customToastParentViewH)];
    
    [customToastParentView addSubview:customToastView];
    [customToastParentView addSubview: topImgView];
    customToastView.layer.cornerRadius = 5.f;
    customToastView.layer.masksToBounds = YES;
    
    
    _customPopView = [[FFToast alloc]initCentreToastWithView:customToastParentView autoDismiss:NO duration:0 enableDismissBtn:NO dismissBtnImage:nil];
    
    [_customPopView show];
}
-(void)okBtnClick{
    [_customPopView dismissCentreToast];
}


- (void)button3Action:(UIButton *)btn {
    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"This is a Toast View that can be clicked. You can customize the effect you need as needed." iconImage:[UIImage imageWithName:@"test"]];
    toast.toastType = FFToastTypeSuccess;
    toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
    [toast show:^{
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Hello！"
                                                                                 message:@"Welcome to use FFToast!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
}
- (void)button4Action:(UIButton *)btn {
    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"This is a custom Toast View" iconImage:nil];
    toast.toastType = FFToastTypeDefault;
    toast.toastPosition = FFToastPositionBottomWithFillet;
    [toast show];

}




@end
