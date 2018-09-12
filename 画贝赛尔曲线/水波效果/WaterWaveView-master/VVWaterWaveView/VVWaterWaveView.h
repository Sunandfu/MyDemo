//
//  VVWaterWaveView.h
//  WaveView
//
//  Created by 卫兵 on 16/8/30.
//  Copyright © 2016年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVWaterWaveView : UIView

@property (nonatomic, assign, readonly) BOOL waveing;
/** 百分比 */
@property (nonatomic, assign) CGFloat percent;

@property (nonatomic, strong) NSArray<UIColor *> *waveLayerColorArray;

/** 振幅，也就是上下的高度变化范围 */
@property (nonatomic, assign) CGFloat amplitude;

-(void)reset;
- (void)startWave;
- (void)stopWave;

@end
