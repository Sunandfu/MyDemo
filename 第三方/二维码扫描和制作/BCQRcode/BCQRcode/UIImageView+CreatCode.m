//
//  UIImageView+CreatCode.m
//  BCQRcode
//
//  Created by Jack on 16/4/20.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "UIImageView+CreatCode.h"
#define ImageSize self.bounds.size.width

@implementation UIImageView (CreatCode)
- (void)creatCode:(NSString *)codeContent Image:(UIImage *)codeImage andImageCorner:(CGFloat)imageCorner {
    
    //用CoreImage框架实现二维码的生成，下面方法最好异步调用
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIFilter *codeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        //每次调用都恢复其默认属性
        [codeFilter setDefaults];
        
        NSData *codeData = [codeContent dataUsingEncoding:NSUTF8StringEncoding];
        
        //设置滤镜数据
        [codeFilter setValue:codeData forKey:@"inputMessage"];
        
        //获得滤镜输出的图片
        CIImage *outputImage = [codeFilter outputImage];
        
        //这里的图像必须经过位图转换，不然会很模糊
        
        UIImage *translateImage = [self creatUIImageFromCIImage:outputImage andSize:ImageSize];
        
        //这里如果不想设置圆角，直接传一个image就好了
        UIImage *resultImage = [self setSuperImage:translateImage andSubImage:[self imageCornerRadius:imageCorner andImage:codeImage]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.image = resultImage;
         
        });
       
        
        
});
    
    
    
    
    
    
    
    
    
    
}


//这里的size我是用imageview的宽度来算的，你可以改为自己想要的size
- (UIImage *)creatUIImageFromCIImage:(CIImage *)image andSize:(CGFloat)size {

    //下面是创建bitmao没什么好解释的,不懂得自行百度或者参考官方文档
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceGray();
    
    CGContextRef contextRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorRef, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef imageRef = [context createCGImage:image fromRect:extent];

    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
    
    CGContextScaleCTM(contextRef, scale, scale);
    
    CGContextDrawImage(contextRef, extent, imageRef);

    CGImageRef  newImage = CGBitmapContextCreateImage(contextRef);
    CGContextRelease(contextRef);
    CGImageRelease(imageRef);
    
    
    
    return [UIImage imageWithCGImage:newImage];

}

//这里将二维码上方的图片设置圆角并缩放
- (UIImage *)imageCornerRadius:(CGFloat)cornerRadius andImage:(UIImage *)image {

    //这里是将图片进行处理，frame不能太大，否则会挡住二维码
    CGRect frame = CGRectMake(0, 0, ImageSize/5, ImageSize/5);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius] addClip];
    
    [image drawInRect:frame];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    return clipImage;

}


- (UIImage *)setSuperImage:(UIImage *)superImage andSubImage:(UIImage *)subImage {

    //将两张图片绘制在一起
    UIGraphicsBeginImageContextWithOptions(superImage.size, YES, 0);
    [superImage drawInRect:CGRectMake(0, 0, superImage.size.width, superImage.size.height)];
    [subImage drawInRect:CGRectMake((ImageSize - ImageSize/5)/2, (ImageSize - ImageSize/5)/2, subImage.size.width, subImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return resultImage;

}
@end
