//
//  DetailViewController.h
//  THPlayer
//
//  Created by inveno on 16/3/24.
//  Copyright © 2016年 inveno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTPlayer.h"
#import "VideoModel.h"


@interface DetailViewController : UIViewController

@property (strong, nonatomic)HTPlayer *htPlayer;
@property (strong, nonatomic)VideoModel *model;
@property (strong, nonatomic)UIView *videoView;

- (void)reloadData;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com