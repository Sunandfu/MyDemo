//
//  ViewController.m
//  TWQRPhoto
//
//  Created by 纪栋凯 on 15/11/19.
//  Copyright © 2015年 threeWater. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) CIDetector *detector;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 进入相册
- (IBAction)photoLibraryButton:(UIBarButtonItem *)sender {
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 选择二维码照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
    float i = 0;
    while (i <= 4) {
        //修改照片对比度参数 0---4
        [lighten setValue:@(i) forKey:@"inputContrast"];
        CIImage *result = [lighten valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
        //修改后的照片
//        image = [UIImage imageWithCGImage:cgImage];
        NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
        if (features.count >= 1) {
            CIQRCodeFeature *feature = [features firstObject];
            NSString *scannedResult = feature.messageString;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:scannedResult delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        //变化区间可以自行设置
        i = i+0.5;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
