//
//  MainViewController.m
//  DYCustomTakePhtotoDemo
//
//  Created by 袁斌 on 16/4/2.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "MainViewController.h"

#import "LMSTakePhotoController.h"

@interface MainViewController ()<LMSTakePhotoControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;//照片

//拍照
- (IBAction)takePicture:(id)sender;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"自定义拍照";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma LMSTakePhotoControllerDelegate
-(void)didFinishPickingImage:(UIImage *)image
{
    self.photoImgView.image = image;
}

- (IBAction)takePicture:(id)sender {

    LMSTakePhotoController *p = [[LMSTakePhotoController alloc] init];
    p.position = TakePhotoPositionFront;
    p.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:p];
    [self presentViewController:nav animated:YES completion:NULL];

}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com