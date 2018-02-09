//
//  ViewController.m
//  仿qq微信选取照片
//
//  Created by 薛泽军 on 15/12/21.
//  Copyright © 2015年 薛泽军. All rights reserved.
//

#import "ViewController.h"
#import "CocoaPickerViewController.h"
@interface ViewController ()<CocoaPickerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnClick:(UIButton *)sender {
    [self composePicAdd];
}
- (void)composePicAdd
{
    self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明
    CocoaPickerViewController *transparentView = [[CocoaPickerViewController alloc] init];
    transparentView.delegate = self;
    transparentView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    transparentView.view.frame=self.view.frame;
    //        transparentView.view.superview.backgroundColor = [UIColor clearColor];
    [self presentViewController:transparentView animated:YES completion:nil];
}
- (void)CocoaPickerViewSendBackWithImage:(NSArray *)imageArray andString:(NSString *)str{
    NSLog(@"%@===%@",imageArray,str);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
