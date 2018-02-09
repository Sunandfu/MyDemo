//
//  ViewController.m
//  AnyScanning
//
//  Created by rs on 15/10/17.
//  Copyright © 2015年 e_chenyuqing@126.com. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ResultViewController.h"

#define MAINWIDTH [[UIScreen mainScreen] bounds].size.width
#define MAINHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    AVCaptureDevice * device;//获取摄像设备
    AVCaptureDeviceInput * input;//创建输入流
    AVCaptureMetadataOutput * output;//创建输出流
    AVCaptureVideoPreviewLayer * layer;//扫描窗口
}

@property (strong, nonatomic) IBOutlet UIImageView *imageFrame;
@property (strong, nonatomic) IBOutlet UIImageView *imageLine;
@property (strong, nonatomic) NSString *urlResult;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (session!=nil) {
        [session startRunning];
        
        //开始动画
        [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScanningContent];
    //开始动画
    [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    //添加监听->APP从后台返回前台，重新扫描
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStartRunning) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)sessionStartRunning{
    if (session!=nil) {
        [session startRunning];
        
        //开始动画
        [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    }
}

/**
 *  添加扫描控件
 */
- (void)initScanningContent{

    //获取摄像设备
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //创建输出流
    output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    //设置相机可视范围--全屏
    layer.frame = self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];

    //设置扫描作用域范围(中间透明的扫描框)
    CGRect intertRect = [layer metadataOutputRectOfInterestForRect:CGRectMake(MAINWIDTH/7, 114, MAINWIDTH/7*5, MAINWIDTH/7*5)];
    output.rectOfInterest = intertRect;
    

    //添加全屏的黑色半透明蒙版
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:maskView];

    //从蒙版中扣出扫描框那一块
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(MAINWIDTH/7, 114, MAINWIDTH/7*5, MAINWIDTH/7*5) cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskView.layer.mask = maskLayer; 
}

/**
 *  加载动画
 */
-(void)timerFired {
    
    [self.imageLine.layer addAnimation:[self moveY:3 Y:[NSNumber numberWithFloat:MAINWIDTH/7*5-8]] forKey:nil];
}

/**
 *  扫描线动画
 *
 *  @param time 单次滑动完成时间
 *  @param y    滑动距离
 *
 *  @return 返回动画
 */
-(CABasicAnimation *)moveY:( float )time Y:( NSNumber *)y {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath : @"transform.translation.y" ]; ///.y 的话就向下移动。
    
    animation. toValue = y;
    
    animation. duration = time;
    
    animation. removedOnCompletion = YES ; //yes 的话，又返回原位置了。
    
    animation. repeatCount = MAXFLOAT ;
    
    animation. fillMode = kCAFillModeForwards ;
    
    return animation;
    
}

/**
 *  去扫描结果显示页面
 *
 *  @param str 扫描结果
 */
- (void)toResultViewControllerWithResultString:(NSString *)str {
    
    ResultViewController *rVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResultViewController"];
    rVC.resultString = str;
    [self.navigationController pushViewController:rVC animated:YES];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
/**
 *  获取扫描到的结果
 *
 *  @param captureOutput   输出
 *  @param metadataObjects 结果
 *  @param connection      连接
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
                NSLog(@"stringValue = %@",metadataObject.stringValue);
                    if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
        
                        if ([metadataObject.stringValue containsString:@"http://"]) {
                            self.urlResult = metadataObject.stringValue;
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlResult]];
                        }else{
                            [self toResultViewControllerWithResultString:metadataObject.stringValue];
                        }
                    }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
