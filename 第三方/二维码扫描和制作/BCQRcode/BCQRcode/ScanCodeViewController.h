//
//  ScanCodeViewController.h
//  BCQRcode
//
//  Created by Jack on 16/4/20.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;
    AVCaptureMetadataOutput * output;
    NSInteger lineNum;
    BOOL upOrDown;
    NSTimer *lineTimer;
}

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@end
