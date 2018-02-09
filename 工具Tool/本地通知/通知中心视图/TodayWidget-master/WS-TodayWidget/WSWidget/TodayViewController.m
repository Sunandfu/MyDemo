//
//  TodayViewController.m
//  WSWidget
//
//  Created by iMac on 16/10/14.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#include <objc/runtime.h>


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UILabel *label;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDate *date = [NSDate date];
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString* s1 = [df stringFromDate:date];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 20)];
    _label.text = s1;
    _label.font = [UIFont systemFontOfSize:16];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshV) userInfo:nil repeats:YES];
    self.timer = timer;
    
    CGFloat width = self.view.bounds.size.width - 70-16;
    NSArray *titleArr = @[@"定位", @"WiFi",  @"蜂窝", @"通知", @"声音", @"墙纸"];
    for (int i=0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (width/6+10)*i, 30, width/6, width/6)];
        [btn.titleLabel setContentMode:UIViewContentModeScaleToFill];

        btn.backgroundColor = [UIColor clearColor];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.frame.size.height+20, 0, 0, 0)];
        

        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

    
    self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 30+width/6+20+5);//显示大小

    
}

- (void)refreshV {
    
    NSDate *date = [NSDate date];
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString* s1 = [df stringFromDate:date];
    _label.text = s1;
    
}

- (void)btnAction:(UIButton *)btn {
    switch (btn.tag) {
        case 0: {
            // 定位
            NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
            [self.extensionContext openURL:url completionHandler:nil];
            break;
        }
        case 1: {
            // WiFi
            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
            [self.extensionContext openURL:url completionHandler:nil];
            break;
        }
        case 2: {
            // Network
            NSURL *url = [NSURL URLWithString:@"prefs:root=MOBILE_DATA_SETTINGS_ID"];
            [self.extensionContext openURL:url completionHandler:nil];
            break;
        }
        case 3: {
            // Notification
            NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
            [self.extensionContext openURL:url completionHandler:nil];
            break;
        }
        case 4: {
            // Sounds
            NSURL *url = [NSURL URLWithString:@"prefs:root=Sounds"];
            [self.extensionContext openURL:url completionHandler:nil];
            break;
        }
        case 5: {
            //墙纸
            NSURL *url = [NSURL URLWithString:@"prefs:root=Wallpaper"];
            [self.extensionContext openURL:url completionHandler:nil];
            break;
        }
        default:
            break;
    }
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    completionHandler(NCUpdateResultNewData);
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

@end
