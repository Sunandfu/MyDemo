//
//  CameraViewController.h
//  myCustomCamera
//
//  Created by 小富 on 2016/11/10.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myImageBlcok)(UIImage *image);

@interface CameraViewController : UIViewController

@property (nonatomic, strong) myImageBlcok imageBlcok;

- (void)getCameraImage:(myImageBlcok)imageBlcok;

@end
