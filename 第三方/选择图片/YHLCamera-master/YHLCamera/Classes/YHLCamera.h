//
//  YHLCamera.h
//  YHLCamera_Example
//
//  Created by che on 2018/7/5.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YHLCameraBlock)(UIImage *image);

@interface YHLCamera : NSObject
//拍照
-(void)pz:(UIViewController *)vc;

-(void)stop:(YHLCameraBlock)block;
-(void)start;
@end
