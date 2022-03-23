//
//  YHLCamera.m
//  YHLCamera_Example
//
//  Created by che on 2018/7/5.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import "YHLCamera.h"
#import <AVFoundation/AVFoundation.h>

@interface YHLCamera ()

@property (nonatomic,strong) AVCaptureSession *session;

@end

@implementation YHLCamera


-(void)pz:(UIViewController *)vc{
    //1.创建媒体管理会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    self.session=session;
    
    //判断分辨率是否支持1280*720，支持就设置为1280*720
    //    if( [session canSetSessionPreset:AVCaptureSessionPreset1280x720] ) {
    //        session.sessionPreset=AVCaptureSessionPreset1280x720;
    //    }
    
    //2.获取后置摄像头设备对象
    AVCaptureDevice *device =nil;
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice*camera in cameras) {
        if(camera.position==AVCaptureDevicePositionBack) {//取得后置摄像头
            device = camera;
        }
    }
    if(!device) {
        NSLog(@"取得后置摄像头错误");
        return;
    }
    
    //3.创建输入数据对象
    NSError*error =nil;
    AVCaptureDeviceInput*captureInput = [[AVCaptureDeviceInput alloc]initWithDevice:device error:&error];
    if(error) {
        NSLog(@"创建输入数据对象错误");
        return;
    }
    
    //4.创建输出数据对象
    AVCaptureStillImageOutput*imageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary*setting =@{AVVideoCodecKey:AVVideoCodecJPEG};
    [imageOutput setOutputSettings:setting];
    
    //5.添加输入数据对象和输出对象到会话中
    if([session canAddInput:captureInput]) {
        [session addInput:captureInput];
    }
    if([session canAddOutput:imageOutput]) {
        [session addOutput:imageOutput];
    }
    
    //6.创建视频预览图层
    AVCaptureVideoPreviewLayer*videoLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    videoLayer.frame=vc.view.bounds;
    videoLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    vc.view.layer.masksToBounds=YES;
    [vc.view.layer insertSublayer:videoLayer atIndex:0];
    //这里需要设置相机开始捕捉画面
    [session startRunning];//开始捕捉
}

//- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
//{
//    if (error) {
//        NSLog(@"保存失败");
//    }else{
//        NSLog(@"保存成功");
//    }
//}

-(void)start{
    
    [self.session startRunning];
}
-(void)stop:(YHLCameraBlock)block{
    AVCaptureStillImageOutput *ar = self.session.outputs.firstObject;
    AVCaptureConnection *myVideoConnection = [ar connectionWithMediaType:AVMediaTypeVideo];
    [ar captureStillImageAsynchronouslyFromConnection:myVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
        //完成撷取时的处理程序(Block)
        if (imageDataSampleBuffer) {//fixOrientation
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            //取得的静态影像
            UIImage *myImage = [[UIImage alloc] initWithData:imageData];
            
//            UIImageWriteToSavedPhotosAlbum(myImage,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
            
            [self.session stopRunning];
            if (block) {
                block(myImage);
            }
        }
    }];
}

-(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:1.0 orientation:UIImageOrientationUp];
    //返回剪裁后的图片
    return newImage;
    
}

@end
