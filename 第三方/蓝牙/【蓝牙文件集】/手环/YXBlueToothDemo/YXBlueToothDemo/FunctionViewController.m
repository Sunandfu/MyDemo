//
//  FunctionViewController.m
//  YXBluetoothDemo
//
//  Created by 小富 on 2017/7/31.
//  Copyright © 2017年 xiaofu. All rights reserved.
//

#import "FunctionViewController.h"
#import "SFBleCenter.h"

@interface FunctionViewController ()<UITableViewDelegate,UITableViewDataSource,SFBleCenterDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *funcArray;
@property (nonatomic, strong) NSArray *funcDetailArray;
@property (nonatomic, strong) SFBleCenter *bleManger;
@property (nonatomic, strong) UITextView *showLabel;

@end

@implementation FunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.funcArray = @[@"获取当前步数",@"设置手环的时间",@"读取手环的电量",@"同步运动（跑步心率）数据",@"同步个人信息和闹钟数据",@"开启ANCS",@"关闭ANCS",@"开启心率监测",@"关闭心率监测",@"开启闹钟提醒",@"关闭闹钟提醒",@"开启久坐提醒",@"关闭久坐提醒",@"开启抬腕亮屏",@"关闭抬腕亮屏",@"打开相机拍照",@"获取手环版本",@"获取当天心率",@"同步睡眠与运动数据"];
    self.funcDetailArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"05",@"05",@"12",@"12",@"14",@"15",@"16",@"17",@"18",@"19和20"];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.bleManger = [SFBleCenter shareManager];
    self.bleManger.delegate = self;
    
    self.showLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-150, [UIScreen mainScreen].bounds.size.width, 150)];
    self.showLabel.backgroundColor = [UIColor blackColor];
    self.showLabel.editable = NO;
    self.showLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.showLabel];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.bleManger disconnectPeripheral:self.bleInfo.peripheral];
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-150) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.funcArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellID"];
    }
    cell.textLabel.text = self.funcArray[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"key=%@",self.funcDetailArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.bleManger getCurrentStep];
            break;
        case 1:
            [self.bleManger setBraceletTime];
            break;
        case 2:
            [self.bleManger readBraceletBattery];
            break;
        case 3:
            [self.bleManger syncSportData];
            break;
        case 4:
            // 同步个人信息  如身高175  体重65  以及对应的设置闹钟指令
            [self.bleManger syncPersonInfoWithHight:@"175" AndWeight:@"65" AndSendCodeArr:nil];//
            break;
        case 5:
            [self.bleManger openANCS];
            break;
        case 6:
            [self.bleManger closeANCS];
            break;
        case 7:
            [self.bleManger openHeartRateExamine];
            break;
        case 8:
            [self.bleManger closeHeartRateExamine];
            break;
        case 9:
            //  设置闹钟提醒  如：9：30   对应的时间 周一
            [self.bleManger openAlarmClockWithTime:@"09:30" AndWeek:@"1"];
            break;
        case 10:
            //  关闭闹钟提醒  如：9：30   对应的时间 周一
            [self.bleManger closeAlarmClockWithTime:@"09:30" AndWeek:@"1"];
            break;
        case 11:
            //  设置久坐时间  如：45 分钟
            [self.bleManger openLongSitWithTime:@"45"];
            break;
        case 12:
            //  关闭久坐提醒  如：45 分钟
            [self.bleManger closeLongSitWithTime:@"45"];
            break;
        case 13:
            //  设置抬腕亮屏时间段 如：08:00 - 22:00
            [self.bleManger openLiftWristScreenWithTime:@"08" AndEndTime:@"22"];
            break;
        case 14:
            [self.bleManger closeLiftWristScreen];
            break;
        case 15:
            [self.bleManger OpenCameraPhotograph];
            break;
        case 16:
            [self.bleManger GetBraceletVersion];
            break;
        case 17:
            [self.bleManger GetHeartRateWithDate:nil];
            break;
        case 18:
            [self.bleManger SynchronizeSportAndSleepDataWithDate:nil];
            break;
        default:
            break;
    }
}
#pragma mark - 蓝牙代理
- (void)peripheral:(nonnull CBPeripheral *)peripheral didUpdateValue:(nullable NSString *)value forCharacteristic:(nonnull CBCharacteristic *)characteristic{
    NSLog(@"value->%@",value);
}
- (void)peripheral:(nonnull CBPeripheral *)peripheral didUpdateValue:(nullable NSDictionary *)dicValue{
    // 除了跑步数据和睡眠数据之外   其余数据都在此处回调返回
    self.showLabel.text = [NSString stringWithFormat:@"%@",dicValue];
}
/**
 获取跑步心率数据
 
 @param bracelet 手环
 @param runItem  跑步心率
 */
- (void)bracelet:(nonnull CBPeripheral *)bracelet didUpdateRunItem:(nonnull SFRunItem *)runItem{
    NSDictionary * jsonDict = @{@"key":@"04",
                                @"startDate":runItem.startDate,
                                @"runSteps":[NSString stringWithFormat:@"%ld",(long)runItem.runSteps],
                                @"endDate":runItem.stopDate,
                                @"heartRate":runItem.heartArr,
                                @"heartCount":[NSString stringWithFormat:@"%ld",(unsigned long)runItem.heartArr.count]};
    NSLog(@"跑步心率数据->%@",jsonDict);
    self.showLabel.text = [NSString stringWithFormat:@"%@",jsonDict];
}
/**
 睡眠数据
 
 @param peripheral     外设
 @param sleepArray 特征值
 */
- (void)peripheral:(nonnull CBPeripheral *)peripheral didUpdateSleepValue:(nullable NSArray *)sleepArray{
    NSLog(@"睡眠数据->%@",sleepArray);
//    self.showLabel.text = [NSString stringWithFormat:@"%@",sleepArray];
}

@end
