//
//  ViewController.m
//  XYTakePhotoController
//
//  Created by 渠晓友 on 2020/3/29.
//  Copyright © 2020 渠晓友. All rights reserved.
//

#import "ViewController.h"
#import "XYTakePhotoController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (IBAction)oneFront:(id)sender {
    [XYTakePhotoController presentFromVC:self mode:XYTakePhotoModeSingleFront resultHandler:^(NSArray<UIImage *> * _Nonnull images, NSString * _Nonnull errorMsg) {
        
        if (errorMsg) {
            // 处理错误信息
            self.statusLabel.text = errorMsg;
            return ;
        }
        
        if (images.count == 1) {
            self.imageView.image = images.firstObject;
        }else
        {
            self.imageView.animationImages = images;
            self.imageView.animationDuration = 2;
            [self.imageView startAnimating];
        }
    }];
}

- (IBAction)oneBack:(id)sender {
    
    [XYTakePhotoController presentFromVC:self mode:XYTakePhotoModeSingleBack resultHandler:^(NSArray<UIImage *> * _Nonnull images, NSString * _Nonnull errorMsg) {
        
        if (errorMsg) {
            // 处理错误信息
            self.statusLabel.text = errorMsg;
            return ;
        }
        
        if (images.count == 1) {
            self.imageView.image = images.firstObject;
        }else
        {
            self.imageView.animationImages = images;
            self.imageView.animationDuration = 2;
            [self.imageView startAnimating];
        }
    }];
}


- (IBAction)idCardFrontRear:(id)sender {
    
    [XYTakePhotoController presentFromVC:self mode:XYTakePhotoModeFrontRear resultHandler:^(NSArray<UIImage *> * _Nonnull images, NSString * _Nonnull errorMsg) {
        
        if (errorMsg) {
            // 处理错误信息
            self.statusLabel.text = errorMsg;
            return ;
        }
        
        if (images.count == 1) {
            self.imageView.image = images.firstObject;
        }else
        {
            self.imageView.animationImages = images;
            self.imageView.animationDuration = 2;
            [self.imageView startAnimating];
        }
    }];
}

- (IBAction)cards:(id)sender {
    [XYTakePhotoController presentFromVC:self mode:XYTakePhotoModeFrontRear resultHandler:^(NSArray<UIImage *> * _Nonnull images, NSString * _Nonnull errorMsg) {

        if (errorMsg) {
            // 处理错误信息
            self.statusLabel.text = errorMsg;
            return ;
        }

        self.imageView.animationImages = images;
        self.imageView.animationDuration = 2;
        [self.imageView startAnimating];
    }];
    
    // 测试导航控制器推出报错
//    XYTakePhotoController *vc = [XYTakePhotoController new];
//    [self.navigationController pushViewController:vc animated:YES];
}





@end
