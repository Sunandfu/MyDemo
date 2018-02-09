//
//  MainController.m
//  AnyScanning
//
//  Created by yuedong on 16/5/9.
//  Copyright © 2016年 e_chenyuqing@126.com. All rights reserved.
//

#import "MainController.h"
#import "ZXingObjC/ZXingObjC.h"
#import "ResultViewController.h"

@interface MainController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)decodeQRClick:(id)sender {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *aLibrary = [UIAlertAction actionWithTitle:@"从相册选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
        imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imageVC.allowsEditing = NO;
        imageVC.delegate = self;
        [self presentViewController:imageVC animated:YES completion:nil];
        
    }];
    [ac addAction:aLibrary];
    UIAlertAction *aCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [ac addAction:aCancel];
    [self presentViewController:ac animated:YES completion:nil];
    
}

//从相册中识别二维码
- (void)decodeQRWithImage:(UIImage *)img{
    CGImageRef imageToDecode = img.CGImage;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
//        ZXBarcodeFormat format = result.barcodeFormat;
        
        if ([contents containsString:@"http://"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contents]];
        }else{
            [self toResultViewControllerWithResultString:contents];
        }
        
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
        NSLog(@"识别失败");
    }
}
/**
 *  去结果显示页面
 *
 *  @param str 扫描结果
 */
- (void)toResultViewControllerWithResultString:(NSString *)str {
    
    ResultViewController *rVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResultViewController"];
    rVC.resultString = str;
    [self.navigationController pushViewController:rVC animated:YES];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (image!=nil) {
        [self decodeQRWithImage:image];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
