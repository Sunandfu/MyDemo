//
//  ViewController.m
//  VVWaterWaveViewDemo
//
//  Created by 卫兵 on 16/9/13.
//  Copyright © 2016年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "VVWaterWaveView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet VVWaterWaveView *waterWaveViewTop;
@property (weak, nonatomic) IBOutlet VVWaterWaveView *waterWaveViewBottom;

@property (weak, nonatomic) IBOutlet UISlider *percentSlider;
@property (weak, nonatomic) IBOutlet UISlider *amplitudeSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waterWaveViewTop.percent = self.percentSlider.value;
    self.waterWaveViewTop.amplitude = self.amplitudeSlider.value;
    self.waterWaveViewTop.waveLayerColorArray = @[
                                                  [UIColor colorWithRed:131/255.0 green:169/255.0 blue:235/255.0 alpha:0.5],
                                                  [UIColor colorWithRed:131/255.0 green:169/255.0 blue:235/255.0 alpha:1.0]
                                                  ];
    [self.waterWaveViewTop startWave];
    
    self.waterWaveViewBottom.percent = self.percentSlider.value;
    self.waterWaveViewBottom.amplitude = self.amplitudeSlider.value;
    self.waterWaveViewBottom.waveLayerColorArray = @[
                                                     [UIColor colorWithRed:131/255.0 green:169/255.0 blue:235/255.0 alpha:0.5],
                                                     [UIColor colorWithRed:131/255.0 green:169/255.0 blue:235/255.0 alpha:0.7],
                                                     [UIColor colorWithRed:131/255.0 green:169/255.0 blue:235/255.0 alpha:1.0]
                                                     ];
    self.waterWaveViewBottom.layer.cornerRadius = self.waterWaveViewBottom.frame.size.width * 0.5;
    self.waterWaveViewBottom.clipsToBounds = YES;
    [self.waterWaveViewBottom startWave];
    
}

- (IBAction)percentChangeAction:(UISlider *)slider {
    self.waterWaveViewTop.percent = self.percentSlider.value;
    self.waterWaveViewBottom.percent = self.percentSlider.value;
}

- (IBAction)amplitudeChangeAction:(UISlider *)slider {
    self.waterWaveViewTop.amplitude = self.amplitudeSlider.value;
    self.waterWaveViewBottom.amplitude = self.amplitudeSlider.value;
}

@end
