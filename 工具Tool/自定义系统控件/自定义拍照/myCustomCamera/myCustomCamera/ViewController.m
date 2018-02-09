//
//  ViewController.m
//  myCustomCamera
//
//  Created by 小富 on 2016/11/10.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "CameraViewController.h"
#import "ViewController.h"
#import "LMSTakePhotoController.h"

@interface ViewController ()<LMSTakePhotoControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;//照片

//拍照
- (IBAction)takePicture:(id)sender;


@end

@implementation ViewController

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

- (IBAction)takePicture:(UIButton *)sender {
    
    if (sender.tag == 11) {
        CameraViewController *camera = [[CameraViewController alloc] init];
        [camera getCameraImage:^(UIImage *image) {
            self.photoImgView.image = image;
        }];
        [self presentViewController:camera animated:YES completion:nil];
    } else {
        LMSTakePhotoController *p = [[LMSTakePhotoController alloc] init];
        p.position = TakePhotoPositionFront;
        p.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:p];
        [self presentViewController:nav animated:YES completion:NULL];
    }
}
@end
