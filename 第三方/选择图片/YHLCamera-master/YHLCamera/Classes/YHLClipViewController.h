//
//  YHLClipViewController.h
//  YHLCamera_Example
//
//  Created by che on 2018/7/5.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHLClipViewDelegate <NSObject>

- (void)resetCameraClick;
- (void)okCameraClick;
@end

@interface YHLClipViewController : UIViewController

@property (nonatomic, weak) id <YHLClipViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;

@end
