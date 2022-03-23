//
//  YHLCameraViewController.h
//  YHLCamera_Example
//
//  Created by che on 2018/7/5.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    driverFrontType=1,//驾驶证正本正面
    driverBackType,//驾驶证正本背面
    driverCopyType,//驾驶证副本
    drivingFrontType,//行驶证正本正面
    drivingCopyType,//行驶证副本正面
    idFrontType,//身份证正面
    idBackType,//身份证背面
    personType,//个人上半身照片
    defaultType
} cameraType;

@protocol YHLCameraViewDelegate <NSObject>

- (void)camera:(UIImage *)image;
@end

@interface YHLCameraViewController : UIViewController

@property (nonatomic, weak) id <YHLCameraViewDelegate> delegate;

-(instancetype)initWithParam:(cameraType)type;

@end
