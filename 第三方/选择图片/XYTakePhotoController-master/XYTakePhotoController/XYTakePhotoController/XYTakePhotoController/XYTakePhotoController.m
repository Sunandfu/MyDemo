//
//  XYTakePhotoController.m
//  XYTakePhotoController
//
//  Created by 渠晓友 on 2020/3/29.
//  Copyright © 2020 渠晓友. All rights reserved.
//

#import "XYTakePhotoController.h"
#import <AVFoundation/AVFoundation.h>


static NSString *NoCameraAccessAlertTitle = @"Unable to access the Camera";
static NSString *NoCameraAccessAlertMessage = @"To turn on camera access, choose Settings > Privacy > Camera and turn on Camera access for this app.";
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@interface XYIDCardBackView : UIView
@property (nonatomic, assign) BOOL showGuoHuiImage;
- (void)updateWithBackTitle:(NSString *)title;
@end
// iPhone5/5c/5s/SE 4英寸 屏幕宽高：320*568点 屏幕模式：2x 分辨率：1136*640像素
#define iPhone5or5cor5sorSE ([UIScreen mainScreen].bounds.size.height == 568.0)

// iPhone6/6s/7 4.7英寸 屏幕宽高：375*667点 屏幕模式：2x 分辨率：1334*750像素
#define iPhone6or6sor7 ([UIScreen mainScreen].bounds.size.height == 667.0)

// iPhone6 Plus/6s Plus/7 Plus 5.5英寸 屏幕宽高：414*736点 屏幕模式：3x 分辨率：1920*1080像素
#define iPhone6Plusor6sPlusor7Plus ([UIScreen mainScreen].bounds.size.height == 736.0)

@interface XYIDCardBackView () {
    CAShapeLayer *_IDCardScanningWindowLayer;
    NSTimer *_timer;
    UILabel *_titleLabel;
}

@end

@implementation XYIDCardBackView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 添加扫描窗口
        [self addScaningWindow];
    }
    
    return self;
}

#pragma mark - 添加扫描窗口
-(void)addScaningWindow {
    // 中间包裹线
    _IDCardScanningWindowLayer = [CAShapeLayer layer];
    _IDCardScanningWindowLayer.position = self.layer.position;
    CGFloat width = iPhone5or5cor5sorSE? 240: (iPhone6or6sor7? 270: 300);
    _IDCardScanningWindowLayer.bounds = (CGRect){CGPointZero, {width, width * 1.574}};
    _IDCardScanningWindowLayer.cornerRadius = 15;
    _IDCardScanningWindowLayer.borderColor = [UIColor whiteColor].CGColor;
    _IDCardScanningWindowLayer.borderWidth = 1.5;
    [self.layer addSublayer:_IDCardScanningWindowLayer];
    
    // 最里层镂空
    UIBezierPath *transparentRoundedRectPath = [UIBezierPath bezierPathWithRoundedRect:_IDCardScanningWindowLayer.frame cornerRadius:_IDCardScanningWindowLayer.cornerRadius];
    
    // 最外层背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    [path appendPath:transparentRoundedRectPath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.6;
    
    [self.layer addSublayer:fillLayer];
    
    // 提示标签
    CGPoint center = self.center;
    center.x = CGRectGetMaxX(_IDCardScanningWindowLayer.frame) + 20;
    [self addTipLabelWithText:@"拍摄背面，请将身份证置于白色边框" center:center];
    
}

#pragma mark - 添加提示标签
-(void )addTipLabelWithText:(NSString *)text center:(CGPoint)center {
    UILabel *tipLabel = [[UILabel alloc] init];
    _titleLabel = tipLabel;
    tipLabel.text = text;
    
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    tipLabel.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    [tipLabel sizeToFit];
    
    tipLabel.center = center;
    
    [self addSubview:tipLabel];
}

- (void)updateWithBackTitle:(NSString *)title{
    [_titleLabel setText:title];
    
    if (self.showGuoHuiImage) {
        CGFloat facePathWidth = iPhone5or5cor5sorSE? 86: (iPhone6or6sor7? 98: 110);
        CGFloat facePathHeight = facePathWidth;
        CGRect rect = _IDCardScanningWindowLayer.frame;
        CGRect faceRect = (CGRect){CGRectGetMaxX(rect) - facePathWidth - 18,rect.origin.y +22,facePathWidth,facePathHeight};
        
        // 国徽框
        UIImageView *headIV = [[UIImageView alloc] initWithFrame:faceRect];
        //    _headView = headIV;
        headIV.image = [UIImage imageNamed:@"idCardGuoHui"];
        headIV.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        headIV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:headIV];
    }
}


@end

@interface XYTakePhotoController ()<AVCaptureMetadataOutputObjectsDelegate>
/** mode */
@property (nonatomic, assign)       XYTakePhotoMode mode;
/** imagesArray */
@property (nonatomic, strong)       NSMutableArray <UIImage *>* imageArray;
/** callBackHandler */
@property (nonatomic, copy)         void(^callBackHandler)(NSArray <UIImage *> *images, NSString *errorMsg);

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

@property (nonatomic)UIView *focusView;
@property (nonatomic)BOOL isflashOn;
@property (nonatomic, strong) UIButton *closeBtn;


@property (nonatomic)BOOL canCa;

@property (nonatomic, weak) UIButton *flashButton;
@property (nonatomic, weak) UIView *flashItemsView;
@property (nonatomic, assign) CGFloat flashViewWidth;
@property (nonatomic, strong) NSMutableArray *flashItemsArray;

/** idcardBackView */
@property (nonatomic, strong)       XYIDCardBackView * idcardBackView;

@end

static XYTakePhotoController *_instance;
@implementation XYTakePhotoController

#pragma mark - private methods
/// 查看相机权限
- (void)checkCameraAccessWithBlock:(void(^)(BOOL cameraAvailable))handler{
    
    // 检测相机设备是否可用
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!cameraAvailable) {
        if (handler) {
            handler(NO);
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"相机设备不可用" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 取消
            [self closeCarema];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NoCameraAccessAlertTitle message:NoCameraAccessAlertMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 取消
            [self closeCarema];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 去设置
            NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:^(BOOL success) {
                        // 成功进入设置
                    }];
                } else {
                    // Fallback on earlier versions
                    [[UIApplication sharedApplication] openURL:settingURL];
                }
            }
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        if (handler) {
            handler(NO);
        }
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                   // 用户授权
                    if (handler) {
                        handler(YES);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                   // 用户拒绝
                    if (handler) {
                        handler(NO);
                    }
                    [self closeCarema];
                });
            }
        }];
    }else
    {
        // 用户授权
        if (handler) {
            handler(YES);
        }
    }
}

#pragma mark - private methods
- (UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationFullScreen;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

+ (void)presentFromVC:(UIViewController *)fromVC mode:(XYTakePhotoMode)mode resultHandler:(void (^)(NSArray<UIImage *> * _Nonnull, NSString * _Nonnull))reslutHandler
{
    _instance = [XYTakePhotoController new];
    if (!fromVC) {
        fromVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    }
    _instance.mode = mode;
    _instance.callBackHandler = reslutHandler;
    [fromVC presentViewController:_instance animated:YES completion:^{
        [_instance buildUI];
    }];
    
}

#pragma mark - LazyLoad properties
- (NSMutableArray<UIImage *> *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[].mutableCopy;
    }
    return _imageArray;
}

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController) {
        @throw [NSException exceptionWithName:@"用法错误" reason:@"此类不支持导航控制器推出,请使用公开类方法" userInfo:nil];
    }
}

- (void)buildUI{
    
    // 检查授权
    [self checkCameraAccessWithBlock:^(BOOL cameraAvailable) {
        
        // 相机不可用
        if (!cameraAvailable) {
            if (self.callBackHandler) {
                self.callBackHandler(nil, @"无相机权限");
            }
        }else
        {
            // 创建自定义相机
            [self customCamera];
            [self customUI];
        }
    }];
}

- (void)customCamera{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
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
    self.previewLayer.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
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

- (void)customUI{
    XYIDCardBackView *idcardBackView = [[XYIDCardBackView alloc] initWithFrame:self.view.bounds];
    idcardBackView.showGuoHuiImage = (self.mode == XYTakePhotoModeSingleBack);
    [idcardBackView updateWithBackTitle:@"请将证件置于白色框内"];
    self.idcardBackView = idcardBackView;
    [self.view addSubview:idcardBackView];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(kScreen_Width - 40,37,30,30);
    [_closeBtn setImage:[UIImage imageNamed:@"photoClose"] forState: UIControlStateNormal];
    [_closeBtn setImage:[UIImage imageNamed:@"photoClose"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeCarema) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
    
    _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PhotoButton.frame = CGRectMake(kScreen_Width*1/2.0-30, kScreen_Height- 80, 60, 60);
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_PhotoButton];
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    //闪光灯选项
    UIView *flashItemsView = [[UIView alloc] init];
    flashItemsView.frame = CGRectMake(5, 37, 45, 45);
    [self.view addSubview:flashItemsView];
    flashItemsView.layer.cornerRadius = flashItemsView.frame.size.width/2;
    flashItemsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.flashItemsView = flashItemsView;
    flashItemsView.clipsToBounds = YES;
    
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat flashButtonWH = 34;
    CGFloat flashButtonX = (flashItemsView.bounds.size.width - flashButtonWH)/2;
    flashButton.frame = CGRectMake(flashButtonX, flashButtonX, 34, 34);
    [flashItemsView addSubview:flashButton];
    [flashButton setImage:[UIImage imageNamed:@"photo_flash_off"] forState:UIControlStateNormal];
    self.flashButton = flashButton;
    [flashButton addTarget:self action:@selector(choseFlashClick) forControlEvents:UIControlEventTouchUpInside];
    flashButton.transform = CGAffineTransformMakeRotation(M_PI*0.5);
    
    NSArray *titles = @[@"关闭",@"打开",@"自动",@"常亮"];
    self.flashItemsArray = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        UIButton *one = [UIButton buttonWithType:UIButtonTypeCustom];
        [one setTitle:titles[i] forState:UIControlStateNormal];
        one.titleLabel.font = [UIFont systemFontOfSize:16];
        [one setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [one setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [one sizeToFit];
        one.center = CGPointMake(flashItemsView.bounds.size.width/2, one.center.y);
        
        CGFloat margin = 70;
        CGFloat oneY = CGRectGetMaxY(flashButton.frame) + 42 + (one.bounds.size.height + margin) * i;
        CGRect oneframe = one.frame;
        oneframe.origin.y = oneY;
        one.frame = oneframe;
        _flashViewWidth = CGRectGetMaxY(one.frame) + 62;
        
        [flashItemsView addSubview:one];
        one.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        one.tag = i;
        [one addTarget:self action:@selector(oneFlashSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.flashItemsArray addObject:one];
        
        if (i == 0) {
            one.selected = YES;
        }
    }
    [self changeFlashModeTo:0];
    
    //前后摄像头
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"gjjNew_changeCamera"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 35, 25);
    button.center = CGPointMake(kScreen_Width / 4 * 3, _PhotoButton.center.y);
}


#pragma mark - contentDelegates
- (void)choseFlashClick{
    if (self.flashItemsView.frame.size.height == self.flashViewWidth ) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.flashItemsView.frame;
            frame.size.height = self.flashItemsView.bounds.size.width;
            self.flashItemsView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.flashItemsView.frame;
            frame.size.height = self.flashViewWidth;
            self.flashItemsView.frame = frame;
        }];
    }
}
- (void)oneFlashSelected:(UIButton *)button{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.flashItemsView.frame;
        frame.size.height = self.flashItemsView.bounds.size.width;
        self.flashItemsView.frame = frame;
    }];
    if (button.selected) {
        return;
    }
    
    for (UIButton *b in self.flashItemsArray) {
        if (b == button) {
            b.selected = YES;
        }else{
            b.selected = NO;
        }
    }
    [self changeFlashModeTo:button.tag];
}

- (void)changeFlashModeTo:(NSInteger)mode{
    if (mode == 0) {//关闭
        if ([_device lockForConfiguration:nil]) {
            [_device setFlashMode:AVCaptureFlashModeOff];
            [_device setTorchMode:AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
        }
        [self.flashButton setImage:[UIImage imageNamed:@"photo_flash_off"] forState:UIControlStateNormal];
    }
    if (mode == 1) {//打开
        if ([_device lockForConfiguration:nil]) {
            [_device setFlashMode:AVCaptureFlashModeOn];
            [_device setTorchMode:AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
            [self.flashButton setImage:[UIImage imageNamed:@"photo_flash_on"] forState:UIControlStateNormal];
        }
    }
    if (mode == 2) {//自动
        if ([_device lockForConfiguration:nil]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
            [_device setTorchMode:AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
            [self.flashButton setImage:[UIImage imageNamed:@"photo_flash_auto"] forState:UIControlStateNormal];
        }
    }
    if (mode == 3) {//常亮
        if ([_device lockForConfiguration:nil]) {
            [_device setFlashMode:AVCaptureFlashModeOff];
            [_device setTorchMode:AVCaptureTorchModeOn];
            [_device unlockForConfiguration];
            [self.flashButton setImage:[UIImage imageNamed:@"photo_flash_allLight"] forState:UIControlStateNormal];
        }
    }
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

#pragma mark - content Actions
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

#pragma mark - 截取照片
- (void) shutterCamera
{
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
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *fix = [self fixOrientation:image];
        UIImage *cut = [self cutImage:fix imageView:[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fix.size.width, fix.size.height)]];
        
        if (self.mode == XYTakePhotoModeFrontRear) {
            
            // 转换页面，重新开启
            [self.imageArray addObject:cut];
            
            self.idcardBackView.showGuoHuiImage = YES;
            [self.idcardBackView updateWithBackTitle:@"拍摄背面，请将身份证置于白色边框"];
            
            
            if (self.imageArray.count == 2) { // 两张图之后
                if (self.callBackHandler) {
                    self.callBackHandler(self.imageArray, nil);
                }
                
                [self closeCarema];
            }
            
        }else
        {
            [self.imageArray addObject:cut];
            if (self.callBackHandler) {
                self.callBackHandler(self.imageArray, nil);
            }
            
            [self closeCarema];
        }
    }];
}

- (void)closeCarema{
    [self dismissViewControllerAnimated:YES completion:^{
        _instance = nil;
    }];
}

#pragma mark - 图片处理
// 图片旋转
- (UIImage *)fixOrientation:(UIImage *)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage *)cutImage:(UIImage *)cutImage imageView:(UIImageView *)imageView{
    //裁剪代码
    CGFloat width01 = iPhone5or5cor5sorSE? 240: (iPhone6or6sor7? 270: 300);
    CGFloat scale = MIN(cutImage.size.width / kScreen_Width, cutImage.size.height / kScreen_Height);
    CGFloat clipWidht = width01 * scale;
    CGFloat clipHeight = width01 * scale * 1.574;
    CGRect cropFrame = CGRectMake((cutImage.size.width - clipWidht) * 0.5, (cutImage.size.height - clipHeight) * 0.5, clipWidht, clipHeight);
    CGFloat orgX = cropFrame.origin.x * (cutImage.size.width / imageView.frame.size.width);
    CGFloat orgY = cropFrame.origin.y * (cutImage.size.height / imageView.frame.size.height);
    CGFloat width = cropFrame.size.width * (cutImage.size.width / imageView.frame.size.width);
    CGFloat height = cropFrame.size.height * (cutImage.size.height / imageView.frame.size.height);
    CGRect cropRect = CGRectMake(orgX, orgY, width, height);
    CGImageRef imgRef = CGImageCreateWithImageInRect(cutImage.CGImage, cropRect);
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(cropFrame.size, 0, deviceScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, cropFrame.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, cropFrame.size.width, cropFrame.size.height), imgRef);
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    //左转90度
    UIImage *rotationImage = [UIImage imageWithCGImage:newImg.CGImage scale:2.0 orientation:UIImageOrientationLeft];
    return rotationImage;
}


#pragma mark - dealloc

- (void)dealloc
{
    NSLog(@" ----------- %@ --------dealloc --------",self);
}




@end
