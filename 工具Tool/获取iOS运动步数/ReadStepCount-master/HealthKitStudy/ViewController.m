//
//  ViewController.m
//  HealthKitStudy
//
//  Created by Macx on 16/2/27.
//  Copyright © 2016年 wlll. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>

@interface ViewController ()

@property (nonatomic, strong) HKHealthStore *healthStore;

@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //查看healthKit在设备上是否可用，ipad不支持HealthKit
    if(![HKHealthStore isHealthDataAvailable])
    {
        NSLog(@"设备不支持healthKit");
    }
    
    //创建healthStore实例对象
    self.healthStore = [[HKHealthStore alloc] init];
    
    //设置需要获取的权限这里仅设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
    
    //从健康应用中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success)
        {
            NSLog(@"获取步数权限成功");
            
            [self readStepCount];
        }
        else
        {
            NSLog(@"获取步数权限失败");
        }
    }];
    
}


- (void)readStepCount
{
    //查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //NSSortDescriptors用来告诉healthStore
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    //limit给1表示查询最近1条的数据
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:nil limit:1 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        //打印查询结果
        NSLog(@"resultCount = %ld result = %@",results.count,results);
        //对结果进行单位换算
        HKQuantitySample *result = results[0];
        HKQuantity *quantity = result.quantity;
        NSString *str = (NSString *)quantity;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.stepLabel.text = [NSString stringWithFormat:@"最新步数：%@",str];
            self.stepLabel.adjustsFontSizeToFitWidth = YES;
        }];
        
    }];
    //执行查询
    [self.healthStore executeQuery:sampleQuery];
}



@end
