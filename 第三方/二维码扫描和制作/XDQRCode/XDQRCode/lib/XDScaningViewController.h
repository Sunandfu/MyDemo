//
//  XDScaningViewController.h
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import <QuartzCore/QuartzCore.h>

@interface XDScaningViewController : UIViewController

@property (nonatomic, copy) void (^backValue)(NSString *scannedStr);

/**
 *生成二维码
 * text 字符串Data
 * size 清晰度
 */
- (UIImage*)generateQRCode:(NSString*)text size:(CGFloat)size;

@end

//UIVIew
@interface XDScanningView : UIView

+ (NSInteger)width;
+ (NSInteger)height;

@end
