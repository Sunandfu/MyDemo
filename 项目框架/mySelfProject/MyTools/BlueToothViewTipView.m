//
//  BlueToothViewTipView.m
//  HBGuard
//
//  Created by 李帅 on 16/1/21.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import "BlueToothViewTipView.h"
#import "AppDelegate.h"
#define APPDELEGATE1     ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@implementation BlueToothViewTipView
+ (BlueToothViewTipView *)sharedManager {
    static BlueToothViewTipView *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        
    });
    return sharedManager;
}
- (instancetype)init
{
    if ((self = [super initWithFrame:CGRectMake(0, 64, kScreenWidth, 44)])) {
        [self customInit];
    }
    return self;
}
- (void)customInit
{
    self.backgroundColor = [UIColor colorWithRed:0.87 green:0.86 blue:0.82 alpha:1.0f];
    self.tipLabel = [Factory createLabelWithTitle:@"连接已断开，请重新连接" frame:CGRectMake(0, 0, self.width, 44) textColor:[UIColor blackColor] fontSize:13.f];
    self.tipLabel.backgroundColor = [UIColor colorWithRed:0.90 green:0.89 blue:0.86 alpha:1.0f];
    [self addSubview:self.tipLabel];
    [self setAlpha:0];
//    [self setClipsToBounds:NO];
//    [self.layer setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0] CGColor]];
//    [self.layer setCornerRadius:10];
//    [self.layer setMasksToBounds:YES];
    
    [APPDELEGATE1.window addSubview:self];
}

+ (void)showWithTitle:(NSString*)title{
    [[self sharedManager] setAlpha:1];
    [[self sharedManager].tipLabel setText:title];
    [APPDELEGATE1.window bringSubviewToFront:[self sharedManager]];
    
    [UIView animateWithDuration:3 animations:^{
//        CGRect frame ;
//            frame.origin.x = 0;
//            frame.origin.y = 0;
//            frame.size.width = ScreenWidth;
//            frame.size.height = 44;
//            [self sharedManager].frame = frame;
        [[self sharedManager] setAlpha:0];
    }completion:^(BOOL finished) {
       
    }];
}

+ (void)showAlertWithStr:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
-(void)showAlert:(NSString *)string{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    //iOS9.0之后新增功能
    [alertVC addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
//    [APPDELEGATE1.window presentViewController:alertVC animated:YES completion:^{
//    }];
}
+ (void)dismiss
{
   [[self sharedManager] setAlpha:0];
}


@end
