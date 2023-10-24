//
//  ViewController.m
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#import "ViewController.h"
#import "XDScaningViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的扫描";
    XDScaningViewController *scanningVC = [[XDScaningViewController alloc]init];
    self.imageView.image = [scanningVC generateQRCode:@"威武霸气帅" size:1080];
}

- (IBAction)generativeQRCode:(id)sender {
    XDScaningViewController *scanningVC = [[XDScaningViewController alloc]init];
    self.imageView.image = [scanningVC generateQRCode:self.textField.text size:1080];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanning:(id)sender {
    XDScaningViewController *scanningVC = [[XDScaningViewController alloc]init];
    scanningVC.backValue = ^(NSString *scannedStr){
        self.scaningResultsLabel.text = scannedStr;
    };
    [self.navigationController pushViewController:scanningVC animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
