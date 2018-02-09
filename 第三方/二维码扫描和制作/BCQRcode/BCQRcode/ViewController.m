//
//  ViewController.m
//  BCQRcode
//
//  Created by Jack on 16/4/19.
//  Copyright © 2016年 毕研超. All rights reserved.
//

// 个人博客地址  ----  http://blog.csdn.net/b1458583930
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码";
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"生成"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(backView)];
    self.navigationItem.leftBarButtonItem = leftBtn;

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"扫描"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(ScanView)];
    self.navigationItem.rightBarButtonItem = rightBtn;


   //长按识别图中的二维码，类似于微信里面的功能,前提是当前页面必须有二维码
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readCode:)];
    [self.view addGestureRecognizer:longPress];
    
  
}

- (void)readCode:(UILongPressGestureRecognizer *)pressSender {

    if (pressSender.state == UIGestureRecognizerStateBegan) {
        
        
        //截图 再读取
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.view.layer renderInContext:context];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
      
        CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
        CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
        
        
        NSArray *features = [detector featuresInImage:ciImage];
        
        
        for (CIQRCodeFeature *feature in features) {
           
            
            NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
            
            //对结果进行处理
            ResultViewController *resultVC = [[ResultViewController alloc] init];
            resultVC.contentString = feature.messageString;
            [self.navigationController pushViewController:resultVC animated:NO];
        }
        

    }



}
- (void)backView {
    
  
    
        
        UIImageView *codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((BCWidth - 200)/2, 100, 200, 200)];
        codeImageView.layer.borderColor = [UIColor orangeColor].CGColor;
        codeImageView.layer.borderWidth = 1;
        [self.view addSubview:codeImageView];

        
       
    //有图片的时候，也可以不设置圆角
    UIImage *image = [UIImage imageNamed:@"sun.jpg"];
    [codeImageView creatCode:@"https://www.baidu.com" Image:image andImageCorner:image.size.width/2];
    
    //没有图片的时候
    //  [codeImageView creatCode:@"这波可以" Image:nil andImageCorner:4];



}


- (void)ScanView {

    
    [self.navigationController pushViewController:[ScanCodeViewController new] animated:YES];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
