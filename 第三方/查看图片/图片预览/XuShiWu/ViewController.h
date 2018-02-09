//
//  ViewController.h
//  XuShiWu
//
//  Created by xsw on 15/12/23.
//  Copyright © 2015年 xsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface ViewController : UIViewController<iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *V_titleView;
@property (weak, nonatomic) IBOutlet UIButton *B_type;

@property (weak, nonatomic) IBOutlet UIImageView *titleImg;

@property (nonatomic, retain) IBOutlet iCarousel *carousel;

@property (nonatomic,assign) BOOL wrap;

//音乐部分
@property (nonatomic, strong) IBOutlet UIButton *typeButton;  //播放状态
@property (weak, nonatomic) IBOutlet UIImageView *Img_type;



@end

