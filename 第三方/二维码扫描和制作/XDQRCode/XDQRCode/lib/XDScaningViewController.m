//
//  XDScaningViewController.m
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.

#import "XDScaningViewController.h"
#import "HistoryTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface XDScaningViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) XDScaningWarningTone tone;
@property (nonatomic, strong) XDScanningView *overView;

@property (nonatomic, strong) AVCaptureDevice *backCamera;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic) BOOL isTorchOn;

@end

@implementation XDScaningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCapture];
    [self initUI];
    [self config];
}

- (void)config{
    _tone = XDScaningWarningToneSound;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initOverView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.overView removeFromSuperview];
    self.overView = nil;
}
- (void)initUI{
    NSArray *imageNames = @[@"history", @"flash_on", @"album", @"return"];
    for (int i = 0; i<4; i++) {
        [self.view addSubview:[self buttonWithImage:imageNames[i] tag:i selector:@selector(buttonsAction:)]];
    }
}

- (UIButton *)buttonWithImage:(NSString *)imageName tag:(int)tag selector:(SEL)selector{
    UIButton *b = [[UIButton alloc]initWithFrame:tag==3?CGRectMake(15, [UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 20, ButtonSize.width, ButtonSize.height):CGRectMake(ScreenSize.width*.25*(tag+1)-ButtonSize.width*.5, ScreenSize.height - ButtonFromBottom - ButtonSize.height, ButtonSize.width, ButtonSize.height)];
    [b setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [b addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    b.layer.cornerRadius = ButtonSize.width*.5;
    b.layer.borderColor = [UIColor blackColor].CGColor;
    b.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    b.layer.borderWidth = .5;
    [b setTag:tag];
    return b;
}

- (void)buttonsAction:(UIButton *)btn{
    switch (btn.tag) {
        case 0://历史
            [self history:btn];
            break;
        case 1://灯
            [self openTorch:btn];
            break;
        case 2://相册
            [self selectImageFormAlbum:btn];
            break;
        case 3://返回
            [self backButtonActioin:btn];
            break;
        default:
            break;
    }
}


- (void)initOverView{
    self.overView = [[XDScanningView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view insertSubview:self.overView atIndex:1];
}

- (void)initCapture{
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    self.backCamera = [[[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack] devices] firstObject];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.backCamera error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    NSLog(@"%f", self.backCamera.activeFormat.videoMaxZoomFactor);
    
    
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode];
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.session startRunning];
    });
    
    
    CGFloat screenHeight = ScreenSize.height;
    CGFloat screenWidth = ScreenSize.width;
    
    CGRect cropRect = CGRectMake((screenWidth - TransparentArea([XDScanningView width], [XDScanningView height]).width) / 2,
                                 (screenHeight - TransparentArea([XDScanningView width], [XDScanningView height]).height) / 2,
                                 TransparentArea([XDScanningView width], [XDScanningView height]).width,
                                 TransparentArea([XDScanningView width], [XDScanningView height]).height);
    
    [output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                         cropRect.origin.x / screenWidth,
                                         cropRect.size.height / screenHeight,
                                         cropRect.size.width / screenWidth)];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *metadateObject = [metadataObjects objectAtIndex:0];
        stringValue = metadateObject.stringValue;
        [self readingFinshedWithMessage:stringValue];
    }
    

}

- (void)readingFinshedWithMessage:(NSString *)msg{
    if (msg) {
        [self.session stopRunning];
        [self saveInformation:msg];
        [self playSystemSoundWithStyle:_tone];
        self.backValue(msg);
        [self backButtonActioin:nil];
    }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"读取失败！" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}



- (void)saveInformation:(NSString *)strValue{
    
    NSMutableArray *history = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"history"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[strValue, [self getSystemTime]] forKeys:@[@"value",@"time"]];
    if (!history) history = [NSMutableArray array];
    [history addObject:dic];
    [[NSUserDefaults standardUserDefaults]setObject:history forKey:@"history"];
}

- (NSString *)getSystemTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

- (void)playSystemSoundWithStyle:(XDScaningWarningTone)tone{
    
    NSString *path = [NSString stringWithFormat:@"%@/scan.wav", [[NSBundle mainBundle] resourcePath]];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(filePath), &soundID);
    
    switch (tone) {
        case XDScaningWarningToneSound:
            AudioServicesPlaySystemSound(soundID);
            break;
        case XDScaningWarningToneVibrate:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            break;
        case XDScaningWarningToneSoundAndVibrate:
            AudioServicesPlaySystemSound(soundID);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@ -- 内存警告", self.description);
    // Dispose of any resources that can be recreated.
}

- (void)backButtonActioin:(UIButton *)button{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)history:(UIButton *)button{
    HistoryTableViewController *history = [[HistoryTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:history animated:YES];
}
- (void)selectImageFormAlbum:(UIButton *)btn{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.mediaTypes = @[@"public.image"];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (UIImage*)generateQRCode:(NSString*)text size:(CGFloat)size{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [text dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return [self createNonInterpolatedUIImageFormCIImage:qrFilter.outputImage withSize:size];
}
//将CGImage转换成UIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
    float i = 0;
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    while (i <= 4) {
        //修改照片对比度参数 0---4
        [lighten setValue:@(i) forKey:@"inputContrast"];
        CIImage *result = [lighten valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
        //修改后的照片
        //        image = [UIImage imageWithCGImage:cgImage];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
        if (features.count >= 1) {
            CIQRCodeFeature *feature = [features firstObject];
            NSString *scannedResult = feature.messageString;
            [self readingFinshedWithMessage:scannedResult];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        //变化区间可以自行设置
        i = i+0.5;
    }
}

- (void)openTorch:(UIButton *)button{
    self.isTorchOn = !self.isTorchOn;
    [self.backCamera lockForConfiguration:nil];
    if (self.isTorchOn) {
        [self.backCamera setTorchMode:AVCaptureTorchModeOn];
        [button setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
    }else{
        [self.backCamera setTorchMode:AVCaptureTorchModeOff];
        [button setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
    }
    [self.backCamera unlockForConfiguration];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ViewWillDisappearNotification" object:nil];
}

- (void)dealloc{
    NSLog(@"%@dead", self.description);
}

@end

#pragma XDScanningView

@interface XDScanningView ()
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) CGFloat origin;
@property (assign, nonatomic) BOOL isReachEdge;


@property (assign, nonatomic) XDScaningLineMoveMode lineMoveMode;
@property (assign, nonatomic) XDScaningLineMode lineMode;
@property (assign, nonatomic) XDScaningWarningTone warninTone;

@end


@implementation XDScanningView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}


- (void)initConfig{
    
    self.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewWillDisappear:) name:@"ViewWillDisappearNotification" object:nil];
    
    self.lineMode = XDScaningLineModeDeafult;
    self.lineMoveMode = XDScaningLineMoveModeDown;

    self.line = [self creatLine];
    [self addSubview:self.line];
    [self starMove];
    
}

- (UIView *)creatLine{
    
    if (_lineMoveMode == XDScaningLineMoveModeNone) return nil;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(ScreenSize.width*.5 - TransparentArea([XDScanningView width], [XDScanningView height]).width*.5, ScreenSize.height*.5 - TransparentArea([XDScanningView width], [XDScanningView height]).height*.5, TransparentArea([XDScanningView width], [XDScanningView height]).width, 2)];
    if (_lineMode == XDScaningLineModeDeafult) {
        line.backgroundColor = LineColor;
        self.origin = line.frame.origin.y;
    }
    
    if (_lineMode == XDScaningLineModeImge) {
        line.backgroundColor = [UIColor clearColor];
        self.origin = line.frame.origin.y;
        UIImageView *v = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        v.contentMode = UIViewContentModeScaleAspectFill;
        v.frame = CGRectMake(0, 0, line.frame.size.width, line.frame.size.height);
        [line addSubview:v];
    }
    
    if (_lineMode == XDScaningLineModeGrid) {
        line.clipsToBounds = YES;
        CGRect frame = line.frame;
        frame.size.height = TransparentArea([XDScanningView width], [XDScanningView height]).height;
        line.frame = frame;
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_net"]];
        iv.frame = CGRectMake(0, -TransparentArea([XDScanningView width], [XDScanningView height]).height, line.frame.size.width, TransparentArea([XDScanningView width], [XDScanningView height]).height);
        [line addSubview:iv];
    }

    return line;
}

- (void)starMove{
    
    
    
    if (_lineMode == XDScaningLineModeDeafult) {  //注意！！！此模式非常消耗性能的哦
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.0125 target:self selector:@selector(showLine) userInfo:nil repeats:YES];
        [self.timer fire];
    }
    
    if (_lineMode == XDScaningLineModeImge) {
        
        [self showLine];
    }
    
    if (_lineMode == XDScaningLineModeGrid) {
        
        UIImageView *iv = _line.subviews[0];
        [UIView animateWithDuration:1.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            iv.transform = CGAffineTransformTranslate(iv.transform, 0, TransparentArea([XDScanningView width], [XDScanningView height]).height);
        } completion:^(BOOL finished) {
            iv.frame = CGRectMake(0, -TransparentArea([XDScanningView width], [XDScanningView height]).height, self->_line.frame.size.width, TransparentArea([XDScanningView width], [XDScanningView height]).height);
            [self starMove];
        }];
    }
}

- (void)showLine{
    
    if (_lineMode == XDScaningLineModeDeafult) {
        CGRect frame = self.line.frame;
        self.isReachEdge?(frame.origin.y -= LineMoveSpeed):(frame.origin.y += LineMoveSpeed);
        self.line.frame = frame;
        
        UIView *shadowLine = [[UIView alloc]initWithFrame:self.line.frame];
        shadowLine.backgroundColor = self.line.backgroundColor;
        [self addSubview:shadowLine];
        [UIView animateWithDuration:LineShadowLastInterval animations:^{
            shadowLine.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowLine removeFromSuperview];
        }];
        
        if (_lineMoveMode == XDScaningLineMoveModeDown) {
            if (self.line.frame.origin.y - self.origin >= TransparentArea([XDScanningView width], [XDScanningView height]).height) {
                [self.line removeFromSuperview];
                CGRect frame = self.line.frame;
                frame.origin.y = ScreenSize.height*.5 - TransparentArea([XDScanningView width], [XDScanningView height]).height*.5;
                self.line.frame = frame;
            }
            
        }else if(_lineMoveMode==XDScaningLineMoveModeUpAndDown){
            if (self.line.frame.origin.y - self.origin >= TransparentArea([XDScanningView width], [XDScanningView height]).height) {
                self.isReachEdge = !self.isReachEdge;
            }else if (self.line.frame.origin.y == self.origin){
                self.isReachEdge = !self.isReachEdge;
            }
        }
    }
    
    if (_lineMode == XDScaningLineModeImge) {
            [self imagelineMoveWithMode:_lineMoveMode];
    }
}

- (void)imagelineMoveWithMode:(XDScaningLineMoveMode)mode{
    
    [UIView animateWithDuration:2 animations:^{
        CGRect frame = self.line.frame;
        frame.origin.y +=  TransparentArea([XDScanningView width], [XDScanningView height]).height-2;
        self.line.frame = frame;
    } completion:^(BOOL finished) {
        if (mode == XDScaningLineMoveModeDown) {
            CGRect frame = self.line.frame;
            frame.origin.y = ScreenSize.height*.5 - TransparentArea([XDScanningView width], [XDScanningView height]).height*.5;
            self.line.frame = frame;
            [self imagelineMoveWithMode:mode];
        }else{
            [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect frame = self.line.frame;
                frame.origin.y = ScreenSize.height*.5 - TransparentArea([XDScanningView width], [XDScanningView height]).height*.5;
                self.line.frame = frame;
            } completion:^(BOOL finished) {
                [self imagelineMoveWithMode:mode];
            }];
        }
    }];
    
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 40/255.0, 40/255.0, 40/255.0, .5);
    CGContextFillRect(context, rect);
    NSLog(@"%@", NSStringFromCGSize(TransparentArea([XDScanningView width], [XDScanningView height])));
    CGRect clearDrawRect = CGRectMake(rect.size.width / 2 - TransparentArea([XDScanningView width], [XDScanningView height]).width / 2,
                                      rect.size.height / 2 - TransparentArea([XDScanningView width], [XDScanningView height]).height / 2,
                                      TransparentArea([XDScanningView width], [XDScanningView height]).width,TransparentArea([XDScanningView width], [XDScanningView height]).height);
    
    CGContextClearRect(context, clearDrawRect);
    [self addWhiteRect:context rect:clearDrawRect];
    [self addCornerLineWithContext:context rect:clearDrawRect];
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    //右下角
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

+ (NSInteger)width{
    if (Iphone4||Iphone5) {
        return Iphone45ScanningSize_width;
    }else if(Iphone6){
        return Iphone6ScanningSize_width;
    }else if(Iphone6Plus){
        return Iphone6PlusScanningSize_width;
    }else{
        return 300;
    }
}

+ (NSInteger)height{
    if (Iphone4||Iphone5) {
        return Iphone45ScanningSize_height;
    }else if(Iphone6){
        return Iphone6ScanningSize_height;
    }else if(Iphone6Plus){
        return Iphone6PlusScanningSize_height;
    }else{
        return 300;
    }
}

- (void)viewWillDisappear:(NSNotification *)noti{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)dealloc{
    NSLog(@"%@dead", self.description);
}

@end

