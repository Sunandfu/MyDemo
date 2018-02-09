//
//  UIImage+Categories.m
//  FiveStar
//
//  Created by Leon on 13-4-18.
//
//

@implementation UIImage (Categories)

- (UIImage *)scaleToSize:(CGSize)size {
    if (self.size.width == size.width && self.size.height == size.height)
        return self;
    else {
        // 把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片

        //        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
        //        [UIImagePNGRepresentation(scaledImage) writeToFile:pngPath atomically:YES];

        return scaledImage;
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)compressWithRate:(CGFloat)rate {
    NSData *data = UIImageJPEGRepresentation(self, rate);
    return [UIImage imageWithData:data];
}

@end
