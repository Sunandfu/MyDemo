//
//  ViewController.m
//  YXScaleDemo
//
//  Created by 小富 on 2017/8/2.
//  Copyright © 2017年 xiaofu. All rights reserved.
//

#import "ViewController.h"
#import "SFScaleCenter.h"

@interface ViewController ()<BLEManagerDelegate>{
    BOOL _canConnectScale;
}

@property (weak, nonatomic) IBOutlet UIButton *startWeighBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (nonatomic, strong) SFScaleCenter *scaleManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.scaleManager = [SFScaleCenter shareManager];
    self.scaleManager.delegate = self;
    _canConnectScale = YES;
}

- (IBAction)startWeighBtnClick:(id)sender {
    [self.startWeighBtn setTitle:@"请上秤" forState:UIControlStateNormal];
    //传入身高、体重、性别
    [self.scaleManager scanScaleWithHeight:175 Weight:65 Sex:1];
}

/**
 蓝牙开
 */
- (void)BLEPoweredOn{
    [self.startWeighBtn setTitle:@"点击开始测试体重" forState:UIControlStateNormal];
}

/**
 蓝牙关
 */
- (void)BLEPoweredOff{
    [self.startWeighBtn setTitle:@"蓝牙已关闭，请打开蓝牙" forState:UIControlStateNormal];
}

/**
 搜索到设备
 */
- (void)BLEDiscoverDevices{
    for (BLEDeviceInfo * info in self.scaleManager.deviceArray) {
        if (_canConnectScale) {
            if ([info.name containsString:YXBLEScaleName]) {
                [self.scaleManager stopScan];
                _canConnectScale = NO;
                [self.scaleManager connectPeripheral:info.peripheral];
            }
        }
    }
}

/**
 连接秤成功
 */
- (void)BLEDidConnectScale:(nonnull CBPeripheral *)peripheral{
    _canConnectScale = NO;
    [self.startWeighBtn setTitle:@"连接秤成功，正在测量" forState:UIControlStateNormal];
    [self.scaleManager getWeightData];
}

/**
 连接外设失败
 
 @param peripheral 外设
 */
- (void)BLEDidFailToConnectPeripheral:(nonnull CBPeripheral *)peripheral{
    _canConnectScale = YES;
}

/**
 断开外设成功
 
 @param peripheral 外设
 */
- (void)BLEDidDisconnectPeripheral:(nonnull CBPeripheral *)peripheral{
    _canConnectScale = YES;
}

#pragma mark - Peripheral

/**
 外设的特征值的值更新
 
 @param peripheral     外设
 @param value          特征值的值
 @param characteristic 特征值
 */
- (void)peripheral:(nonnull CBPeripheral *)peripheral didUpdateValue:(nullable NSString *)value forCharacteristic:(nonnull CBCharacteristic *)characteristic{
    NSLog(@"%@",value);
}

#pragma mark - Scale

/**
 秤的数据更新
 ************阻抗有误时，仍可测试出BMI,但是其他数据为0****************
 @param scale 秤
 @param info  数据
 */
- (void)scale:(nonnull CBPeripheral *)scale didUpdateScaleInfo:(nullable YXScaleInfo *)info{
    [self.scaleManager turnOffScale];
    [self.scaleManager disconnectPeripheral:self.scaleManager.scale];
    if (info.isError) {
        self.showLabel.text = [NSString stringWithFormat:@"error = %@\n\n体重(kg) %lf",info.error,info.weight];
    } else {
        NSDictionary * data = @{@"记录的时间":info.dateStr,
                                @"体重(kg)":[NSString stringWithFormat:@"%.1lf",info.weight],
                                @"身体年龄":[NSString stringWithFormat:@"%.0ld",(long)info.bodyAge],
                                @"内脏脂肪指数":[NSString stringWithFormat:@"%.0ld",(long)info.visceralFatRating],
                                @"水分含量(%)":[NSString stringWithFormat:@"%.1lf",info.moisture],
                                @"肌肉含量(kg)":[NSString stringWithFormat:@"%.1lf",info.muscle],
                                @"骨骼含量(kg)":[NSString stringWithFormat:@"%.1lf",info.skeleton],
                                @"代谢率":[NSString stringWithFormat:@"%.0ld",(long)info.metabolicRate],
                                @"脂肪含量(%)":[NSString stringWithFormat:@"%.0lf",info.fat],
                                @"身体质量指数":[NSString stringWithFormat:@"%.1lf",info.BMI]};
        NSString *str = @"";
        for (int i = 0; i < [data count]; i++) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ = %@\n", [[data allKeys] objectAtIndex:i], [[data allValues] objectAtIndex:i]]];
        }
        self.showLabel.text = [NSString stringWithFormat:@"%@\n\n%@",info.error,str];
    }
    [self.startWeighBtn setTitle:@"点击重新测量" forState:UIControlStateNormal];
}

@end
