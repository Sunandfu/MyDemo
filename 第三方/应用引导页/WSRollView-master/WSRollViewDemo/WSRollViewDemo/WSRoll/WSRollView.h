//
//  WSRollView.h
//  WSRollImageView
//
//  Created by iMac on 16/11/29.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSRollView : UIView

//如果设置了本地图片数组和网络图片,本地图片将不会生效.网络图片优先级高

/**
 本地图片
 */
@property(nonatomic,strong)UIImage *image;


/**
 网络图片URL
 */
@property(nonatomic,strong)NSString *rollImageURL;


/**
 滚动的时间间隔,是每次滚动的距离需要的时间，设置越小，移动越快。默认是0.05秒
 */
@property(nonatomic,assign)CGFloat timeInterval;

/**
 每次滚动的距离 默认为1个像素
 */
@property(nonatomic,assign)CGFloat rollSpace;


/**
 *  开始滚动
 */
- (void)startRoll;


@end
