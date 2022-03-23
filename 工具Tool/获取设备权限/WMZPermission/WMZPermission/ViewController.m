//
//  ViewController.m
//  WMZPermission
//
//  Created by wmz on 2018/12/10.
//  Copyright © 2018年 wmz. All rights reserved.
//

#import "ViewController.h"
#import "WMZPermission.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    PermissionTypeCamera,           //相机权限
//    PermissionTypeMic,              //麦克风权限
//    PermissionTypePhoto,            //相册权限
//    PermissionTypeLocationWhen,     //获取地理位置When
//    PermissionTypeCalendar,         //日历
//    PermissionTypeContacts,         //联系人
//    PermissionTypeBlue,             //蓝牙
//    PermissionTypeRemaine,          //提醒
//    PermissionTypeHealth,           //健康
//    PermissionTypeMediaLibrary      //多媒体
    NSArray *arr = @[@"相机权限",@"麦克风权限",@"相册权限",@"地理位置权限",@"日历权限",@"联系人权限",@"蓝牙开关",@"提醒权限",@"健康权限",@"多媒体权限"];
    UIScrollView *s = [UIScrollView new];
    s.frame = self.view.bounds;
    s.contentSize = CGSizeMake(self.view.frame.size.width, 80*arr.count);
    [self.view addSubview:s];
    
    UIButton *tempBtn = nil;
    for (int i = 0; i<arr.count; i++) {
        UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn addTarget:self action:@selector(tip:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitle:arr[i] forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        okBtn.backgroundColor = [UIColor whiteColor];
        okBtn.tag = i;
        [s addSubview:okBtn];
        if (!tempBtn) {
            okBtn.frame = CGRectMake(0,[self.navigationController visibleViewController]?64:20,200,40);
        }else{
            okBtn.frame = CGRectMake(0,CGRectGetMaxY(tempBtn.frame)+20,200,40);
        }
        okBtn.center = CGPointMake(self.view.center.x,okBtn.center.y);
        tempBtn = okBtn;
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tip:(UIButton*)sender {
    [[WMZPermission shareInstance] permissonType:sender.tag withHandle:^(BOOL granted, id data) {
        NSLog(@"%d,%@",granted,data);
        if (granted) {
            NSLog(@"有权限");
        }
    }];
}
@end
