//
//  CameraViewController.m
//  myCustomCamera
//
//  Created by 小富 on 2016/11/10.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "CameraViewController.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#define bottomHeight 100

@interface CameraViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic)UIButton *PhotoButton;
@property (nonatomic)UIButton *flashButton;
@property (nonatomic)UIImageView *imageView;
@property (nonatomic)UIView *focusView;
@property (nonatomic)BOOL isflashOn;
@property (nonatomic)UIImage *image;

@property (nonatomic)BOOL canCa;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _canCa = [self canUserCamear];
    if (_canCa) {
        [self customCamera];
        [self customUI];
        
    }else{
        return;
    }
}
- (void)customUI{
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 100)];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.tag = 111;
    [self.view addSubview:bottomView];
    
    _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PhotoButton.frame = CGRectMake(kScreenWidth*1/2.0-30, 20, 60, 60);
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_PhotoButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(kScreenWidth*1/4.0-30, 20, 60, 60);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth*3/4.0-60, 20, 60, 60);
    [rightButton setTitle:@"切换" forState:UIControlStateNormal];
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightButton];
    
    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashButton.frame = CGRectMake(kScreenWidth-80, 20, 80, 60);
    [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(FlashOn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_flashButton];
    
    UIView *bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 100)];
    bottomView2.backgroundColor = [UIColor clearColor];
    bottomView2.tag = 222;
    bottomView2.hidden = YES;
    [self.view addSubview:bottomView2];
    
    UIButton *leftButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton2.frame = CGRectMake(30, 20, 100, 60);
    [leftButton2 setTitle:@"重新拍照" forState:UIControlStateNormal];
    leftButton2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton2 addTarget:self action:@selector(chongxin) forControlEvents:UIControlEventTouchUpInside];
    [bottomView2 addSubview:leftButton2];
    
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton2.frame = CGRectMake(kScreenWidth-130, 20, 100, 60);
    [rightButton2 setTitle:@"使用照片" forState:UIControlStateNormal];
    rightButton2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightButton2 addTarget:self action:@selector(shiyong) forControlEvents:UIControlEventTouchUpInside];
    [bottomView2 addSubview:rightButton2];
    
}
- (void)customCamera{
    self.view.backgroundColor = [UIColor blackColor];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    } else {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-bottomHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}
- (void)FlashOn{
    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                [_flashButton setTitle:@"闪光灯开" forState:UIControlStateNormal];
            }
        }
        
        [_device unlockForConfiguration];
    }
}
- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        
        animation.duration = .5f;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        if (point.y<kScreenHeight-bottomHeight) {
            _focusView.center = point;
            _focusView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    _focusView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    _focusView.hidden = YES;
                }];
            }];
        }
    }
    
}
#pragma mark - 截取照片
- (void) shutterCamera
{
    UIView *view1 = [self.view viewWithTag:111];
    view1.hidden = YES;
    UIView *view2 = [self.view viewWithTag:222];
    view2.hidden = NO;
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        [self.session stopRunning];
        [self saveImageToPhotoAlbum:self.image];
        self.imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        [self.view insertSubview:_imageView belowSubview:_PhotoButton];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = _image;
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
        [_PhotoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    }];
}
#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
//    //保存图片到相册
//    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    if (self.imageBlcok) {
        self.imageBlcok(savedImage);
    }
    
}
// 指定回调方法

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)cancle{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}
- (void)getCameraImage:(myImageBlcok)imageBlcok{
    self.imageBlcok = imageBlcok;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)chongxin{
    UIView *view1 = [self.view viewWithTag:111];
    view1.hidden = NO;
    UIView *view2 = [self.view viewWithTag:222];
    view2.hidden = YES;
    
    [self.imageView removeFromSuperview];
    if (self.session) {
        [self.session startRunning];
        [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    }
}
- (void)shiyong{
    if (self.imageBlcok) {
        self.imageBlcok(self.image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

