//
//  LMSTakePhotoController.m
//  LetMeSpend
//
//  Created by 袁斌 on 16/3/10.
//  Copyright © 2016年 __defaultyuan. All rights reserved.
//

#import "LMSTakePhotoController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+borderLine.h"


#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

@interface LMSTakePhotoController ()<AVCaptureMetadataOutputObjectsDelegate>
{

    //切换前后摄像头
    
    __weak IBOutlet UIButton *_switchBtn;

    //自动
    
    __weak IBOutlet UIButton *_autonBtn;
    

    //拍照
    __weak IBOutlet UIButton *_takePicBtn;
    

    //取消
    __weak IBOutlet UIButton *_cancelBtn;
    
    //重拍
    
    __weak IBOutlet UIButton *restartBtn;
    
    //使用拍照
    
    __weak IBOutlet UIButton *_doneBtn;
    
    __weak IBOutlet UIView *_cameraView;
    
    //预览照片
    __weak IBOutlet UIImageView *_groupImage;
    
}

@property (nonatomic,strong) AVCaptureSession *session;

@property(nonatomic,strong)AVCaptureDeviceInput *videoInput;

@property (nonatomic,strong)AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;


- (IBAction)takePic:(UIButton *)sender;

- (IBAction)cancel:(UIButton *)sender;


- (IBAction)done:(UIButton *)sender;

- (IBAction)autoAction:(UIButton *)sender;

- (IBAction)switchAction:(UIButton *)sender;

- (IBAction)restartAction:(UIButton *)sender;


@end

@implementation LMSTakePhotoController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialSession];
    if (self.session) {
        [self.session startRunning];
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"预览照片";
    self.view.backgroundColor = [UIColor blackColor];

}

#pragma mark session
- (void) initialSession;
{
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    //[self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用前摄像头，所以这么写，具体的实现方法后面会介绍
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];//
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    if (self.session) {
        [self.session startRunning];
    }
    [self setUpCameraLayer];
    [self setDonePicture:NO];
}
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:self.position == TakePhotoPositionBack ? AVCaptureDevicePositionBack :AVCaptureDevicePositionFront];
}

#pragma mark VideoCapture
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void) setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [self.previewLayer setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65)];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_cameraView.layer insertSublayer:self.previewLayer below:[[_cameraView.layer sublayers] objectAtIndex:0]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 切换前后摄像头
- (void)swapFrontAndBackCameras {
    // Assume the session is already running
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (self.session) {
        [self.session stopRunning];
    }
}
-(void)viewDidLayoutSubviews
{
    
    [_takePicBtn cornerRadius:CGRectGetHeight(_takePicBtn.frame)/2.0 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
    [restartBtn cornerRadius:4 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
    [_doneBtn cornerRadius:4 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
    
    [super viewDidLayoutSubviews];
}
#pragma mark 获取照片
- (void)gainPicture
{
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    if (!videoConnection) {
        NSLog(@"获取照片失败!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        _groupImage.image = [UIImage imageWithData: imageData];
        _groupImage.contentMode = UIViewContentModeScaleToFill;
        [self setDonePicture:YES];
        if (self.session) {
            [self.session stopRunning];
        }
    }];

    
}
///拍照之后YES  显示的东西
- (void)setDonePicture:(BOOL)isTake;
{
    self.navigationController.navigationBarHidden = !isTake;
    ///拍照完之后
    self.previewLayer.hidden =  _cancelBtn.hidden = _autonBtn.hidden = _switchBtn.hidden = _takePicBtn.hidden = isTake;
    restartBtn.hidden = _groupImage.hidden = _doneBtn.hidden = !isTake;
    
}

- (IBAction)takePic:(UIButton *)sender {
    [self gainPicture];
}

- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(didFinishPickingImage:)]) {
        [_delegate didFinishPickingImage:_groupImage.image];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (IBAction)autoAction:(UIButton *)sender {
    
}

- (IBAction)switchAction:(UIButton *)sender {
    
    [self swapFrontAndBackCameras];
    sender.selected = !sender.selected;
}

- (IBAction)restartAction:(UIButton *)sender {
    [self setDonePicture:NO];
    if (self.session) {
        [self.session startRunning];
    }
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
