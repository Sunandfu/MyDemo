//
//  ViewController.m
//  YXBluetoothDemo
//
//  Created by 小富 on 2017/7/31.
//  Copyright © 2017年 xiaofu. All rights reserved.
//

#import "ViewController.h"
#import "SFBleCenter.h"
#import "FunctionViewController.h"

#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SFBleCenterDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) SFBleCenter *bleManger;
@property (nonatomic, strong) SFBLEDeviceInfo *selectedBleInfo;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bleManger = [SFBleCenter shareManager];
    self.bleManger.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSArray array];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = self.bleManger.deviceArray;
    [self.view addSubview:self.tableView];
}
- (IBAction)searchBluetoothDervices{
    [self.bleManger startScan];
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
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
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellID"];
    }
    SFBLEDeviceInfo *bleInfo = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"设备名:%@",bleInfo.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"MAC地址:%@",bleInfo.macAdress];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    label.text = @"点击目标设备进行连接";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SFBLEDeviceInfo *bleInfo = self.dataArray[indexPath.row];
    self.selectedBleInfo = bleInfo;
    [self.bleManger connectPeripheral:bleInfo.peripheral];
}
#pragma mark - 蓝牙代理
/**
 蓝牙开
 */
- (void)BLEPoweredOn{
    NSLog(@"蓝牙已打开");
}

/**
 蓝牙关
 */
- (void)BLEPoweredOff{
    NSLog(@"蓝牙已关闭");
}

/**
 连接手环成功
 */
- (void)BLEDidConnectBraceletToConnectPeripheral:(nonnull CBPeripheral *)peripheral{
    NSLog(@"连接外设成功");
    FunctionViewController *funcVC = [FunctionViewController new];
    funcVC.bleInfo = self.selectedBleInfo;
    [self.navigationController pushViewController:funcVC animated:YES];
}

/**
 返回的设备数组
 */
- (void)BLEDiscoverDevices:(NSArray *_Nullable)devices{
    self.dataArray = devices;
    [self.tableView reloadData];
}

/**
 连接外设失败
 
 @param peripheral 外设
 */
- (void)BLEDidFailToConnectPeripheral:(nonnull CBPeripheral *)peripheral{
    NSLog(@"连接外设失败");
}
/**
 断开外设成功
 
 @param peripheral 外设
 */
- (void)BLEDidDisconnectPeripheral:(nonnull CBPeripheral *)peripheral{
    NSLog(@"断开外设成功");
}

@end
