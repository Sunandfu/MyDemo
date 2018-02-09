//
//  ResultViewController.m
//  AnyScanning
//
//  Created by rs on 15/10/17.
//  Copyright © 2015年 e_chenyuqing@126.com. All rights reserved.
//

#import "ResultViewController.h"
#import "ZXingObjC/ZXingObjC.h"

@interface ResultViewController ()
@property (strong, nonatomic) IBOutlet UITextView *resultText;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultText.text = self.resultString;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];

}
- (void)hideKeyBoard{
    [self.resultText resignFirstResponder];
}
//生成二维码
- (IBAction)encodeQRClick:(id)sender {
    
    if (_resultText.text.length>0) {
        NSError *error = nil;
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:self.resultText.text
                                      format:kBarcodeFormatQRCode
                                       width:self.imgView.frame.size.width
                                      height:self.imgView.frame.size.width
                                       error:&error];
        if (result) {
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            [self.imgView setImage:[UIImage imageWithCGImage:image]];
            // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
        } else {
//            NSString *errorMessage = [error localizedDescription];
        }
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
