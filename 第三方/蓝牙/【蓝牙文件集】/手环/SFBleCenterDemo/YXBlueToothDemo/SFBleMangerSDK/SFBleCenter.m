
//
//  BLEManager.m
//  electronicScale
//
//  Created by 云镶网络科技公司 on 2016/10/11.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import "SFBleCenter.h"
#import "SynchronizeDervice.h"

#pragma mark - 手环
NSString * const YXBLEBraceletName = @"H2";

NSString * const YXBraceletBatteryService = @"180F";
NSString * const YXBraceletBattery = @"2A19";

NSString * const YXBraceletService = @"FFF0";//服务的UUID
NSString * const YXBraceletFFF1 = @"FFF1";//通知
NSString * const YXBraceletFFF2 = @"FFF2";//写
NSString * const YXBraceletFFF3 = @"FFF3";//通知
NSString * const YXBraceletFFF4 = @"FFF4";//写

@interface SFBleCenter ()<CBCentralManagerDelegate,CBPeripheralDelegate,SynchronizeDelegate>
{
    //发送前解析数据
    dispatch_queue_t sendMessageQueue;
    //收到后解析数据
    dispatch_queue_t analyticDataQueue;
}
@property (nonatomic,strong) CBCentralManager * centralManager;

@property (nonatomic,strong) SFRunItem * currentItem;

@property (nonatomic,strong) SFBLEDeviceInfo * braceletInfo;

@property (nonatomic, strong) SynchronizeDervice *synchronize;

@end

@implementation SFBleCenter

+ (instancetype)shareManager {
    static SFBleCenter * sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [SFBleCenter new];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _bleOpen = NO;
    _bleConnect = NO;
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:[NSNumber numberWithBool:YES]}];
    self.deviceArray = [NSMutableArray array];
    sendMessageQueue = dispatch_queue_create("YXSendMessage", NULL);
    analyticDataQueue = dispatch_queue_create("YXAnalyticData", NULL);
    self.synchronize = [[SynchronizeDervice alloc] initWith:self.currentBracelet];
    self.synchronize.delegate = self;
    return self;
    
}

#pragma mark - CentralMethod

//搜索设备
- (void)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> * )serviceUUIDs
{
    [self.centralManager stopScan];
    [self.deviceArray removeAllObjects];
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"蓝牙未打开，搜索失败");
        return;
    }else{
        [self.centralManager scanForPeripheralsWithServices:serviceUUIDs options:nil];
    }
}

//开始搜索
- (void)startScan
{
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}
//停止搜索
- (void)stopScan
{
    [self.centralManager stopScan];
}
//连接设备
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
{
    if (!peripheral) {
        NSLog(@"请搜索设备");
        return;
    }
    //连接设备前 停止搜索
    [self.centralManager stopScan];
    if (peripheral.state == CBPeripheralStateConnected || peripheral.state == CBPeripheralStateConnecting) {
        NSLog(@"设备已连接或者正在连接");
        return;
    }else{
        self.currentBracelet = peripheral;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}
//断开连接
- (void)disconnectPeripheral:(nonnull CBPeripheral *)peripheral
{
    if (peripheral.state == CBPeripheralStateDisconnected || peripheral.state == CBPeripheralStateDisconnecting) {
        NSLog(@"设备未连接或正在断开连接");
        return;
    }else{
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

#pragma mark - CentralManagerDelegate

//设备状态回调
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnsupported:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStatePoweredOn:{
            _bleOpen = YES;
            if (_delegate && [_delegate respondsToSelector:@selector(BLEPoweredOn)]) {
                [_delegate BLEPoweredOn];
            }
        }break;
        case CBCentralManagerStatePoweredOff:
            _bleOpen = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(BLEPoweredOff)]) {
                [_delegate BLEPoweredOff];
            }
            break;
    }
}
//搜索到设备的回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    dispatch_async(analyticDataQueue, ^(void) {
        //外设已经存在在数组中
        for (SFBLEDeviceInfo * info in self.deviceArray) {
            if ([info.peripheral isEqual:peripheral]) {
                return;
            }
        }
        SFBLEDeviceInfo * newDevice = [SFBLEDeviceInfo new];
        newDevice.name = peripheral.name;
        NSLog(@"advertising name：%@\nGAP name：%@", advertisementData[CBAdvertisementDataLocalNameKey],peripheral.name);
        newDevice.peripheral = peripheral;
        newDevice.UUIDString = peripheral.identifier.UUIDString;
        newDevice.RSSI = [RSSI integerValue];
        newDevice.advertisementData = advertisementData;
        NSData * macAdressData = advertisementData[@"kCBAdvDataManufacturerData"];
        if (macAdressData) {
            const Byte * bytes = macAdressData.bytes;
            NSString * str = @"";
            for (NSInteger i = 2; i < macAdressData.length; i++) {
                str = [NSString stringWithFormat:@"%@%02x:",str,bytes[i] & 0xff];
            }
            str = [str substringToIndex:str.length-1];
            newDevice.macAdress = [[str uppercaseString] substringToIndex:17];
        }
        if ((newDevice.macAdress.length>0)&&(newDevice.name.length>0)) {
            [self.deviceArray addObject:newDevice];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (_delegate && [_delegate respondsToSelector:@selector(BLEDiscoverDevices:)]) {
                [_delegate BLEDiscoverDevices:self.deviceArray];
            }
        });
    });
}

//连接设备成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral

{
    _bleConnect = YES;
    if ([peripheral.name hasPrefix:YXBLEBraceletName]) {
        self.currentBracelet = peripheral;
    }
    peripheral.delegate = self;
    //去发现服务
    [peripheral discoverServices:nil];
}
//连接设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _bleConnect = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(BLEDidFailToConnectPeripheral:)]) {
        [_delegate BLEDidFailToConnectPeripheral:peripheral];
    }
}
//断开设备成功
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _bleConnect = NO;
    if ([peripheral isEqual:self.currentBracelet]) {
        self.currentBracelet = nil;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(BLEDidDisconnectPeripheral:)]) {
        [_delegate BLEDidDisconnectPeripheral:peripheral];
    }
}

#pragma mark - PeripheralMethod

/**
 写入数据到特征值
 
 @param value                 数据
 @param serviceUUIDStr        服务的UUIDStr
 @param characteristicUUIDStr 特征值的UUIDStr
 @param peripheral            外设
 */
- (void)writeValue:(NSString *)value forServiceUUIDStr:(NSString *)serviceUUIDStr andCharacteristicUUIDStr:(NSString *)characteristicUUIDStr toPeripheral:(CBPeripheral *)peripheral{
    if (!peripheral) {
        NSLog(@"请连接设备");
        return;
    }
    CBService * service = [self getServiceByUUIDString:serviceUUIDStr fromPeripheral:peripheral];
    CBCharacteristic * characteristic = [self getCharacteristicByUUIDString:characteristicUUIDStr fromService:service];
//    NSLog(@"发送指令:%@",value);
    //根据属性自动选择写入方式
    if (characteristic.properties & CBCharacteristicPropertyWrite) {
        [peripheral writeValue:[self dataFromHexString:value] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse){
        [peripheral writeValue:[self dataFromHexString:value] forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    }else{
        NSLog(@"此特征值不能写入");
    }
}

/**
 订阅通知
 
 @param enabled               是否打开通知
 @param serviceUUIDStr        服务的UUIDStr
 @param characteristicUUIDStr 特征值的UUIDStr
 @param peripheral            外设
 */
- (void)setNotifyValue:(BOOL)enabled forServiceUUIDStr:(NSString *)serviceUUIDStr andCharacteristicUUIDStr:(NSString *)characteristicUUIDStr toPeripheral:(CBPeripheral *)peripheral{
    CBService * service = [self getServiceByUUIDString:serviceUUIDStr fromPeripheral:peripheral];
    CBCharacteristic * characteristic = [self getCharacteristicByUUIDString:characteristicUUIDStr fromService:service];
    [peripheral setNotifyValue:enabled forCharacteristic:characteristic];
}

#pragma mark - PeripheralDelegate
//找到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"发现服务发生错误:%@",error.localizedDescription);
        return;
    }else{
        for (CBService * service in peripheral.services) {
            //去发现特征值
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}
//找到服务的特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"发现特征值发生错误:%@",error);
        return;
    }else{
        for (CBCharacteristic * characteristic in service.characteristics) {
            //手环
            if ([peripheral.name hasPrefix:YXBLEBraceletName]) {
                if ([characteristic.UUID.UUIDString isEqualToString:YXBraceletBattery]) {
                    if (characteristic.properties & CBCharacteristicPropertyNotify) {
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                }
                if ([characteristic.UUID.UUIDString isEqualToString:YXBraceletFFF1]) {
                    if (characteristic.properties & CBCharacteristicPropertyNotify) {
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                }
                if ([characteristic.UUID.UUIDString isEqualToString:YXBraceletFFF3]) {
                    if (characteristic.properties & CBCharacteristicPropertyNotify) {
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                }
            }
        }
    }
}

#pragma mark - 特征值更新 设置手机提醒
//特征值更新
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"特征值更新发生错误:%@",error);
        return;
    }else{
        NSString * receiveStr = [self hexStringFromData:characteristic.value];
        
        if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:forCharacteristic:)]) {
            [_delegate peripheral:peripheral didUpdateValue:receiveStr forCharacteristic:characteristic];
        }
        //手环
        if ([peripheral.name hasPrefix:YXBLEBraceletName]) {
            //获取步数
            if ([receiveStr hasPrefix:@"2609"]) {
                dispatch_async(analyticDataQueue, ^(void) {
                    NSInteger steps = [self getStepWithStr:receiveStr];
                    if (steps == 16777215) {
                        steps = 0;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        NSDictionary *dict = @{@"key":@"01",@"data":@(steps)};
                        if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                            [_delegate peripheral:peripheral didUpdateValue:dict];
                        }
                    });
                });
            }
            //设置时间成功
            if ([receiveStr hasPrefix:@"2204"]) {
                NSDictionary *dict = @{@"key":@"02",@"data":@"1"};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            //获取电池电量
            if ([characteristic.UUID.UUIDString isEqualToString:YXBraceletBattery]) {
                NSInteger valueNum = [self translateToTenWithString:receiveStr];
                NSDictionary *dict = @{@"key":@"03",@"data":@(valueNum)};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            //获取跑步数据
            if ([receiveStr hasPrefix:@"b3"]) {
                dispatch_async(analyticDataQueue, ^(void) {
                    NSString * checkStr = [receiveStr substringWithRange:NSMakeRange(4, 2)];
                    if ([checkStr isEqualToString:@"02"] && receiveStr.length >= 34) {
                        self.currentItem = [self getRunDataWithStr:receiveStr];
                    }else{
                        if (self.currentItem) {
                            self.currentItem.heartArr = [self.currentItem.heartArr arrayByAddingObjectsFromArray:[self getHeartRateWithStr:receiveStr]];;
                            if (self.currentItem.heartArr.count < self.currentItem.heartCount) {
                                NSDictionary *dict = @{@"key":@"04",@"data":[NSString stringWithFormat:@"心率数据不够,心率数据:%ld,要求心率数据:%ld",(long)self.currentItem.heartArr.count,(long)self.currentItem.heartCount]};
                                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                                    [_delegate peripheral:peripheral didUpdateValue:dict];
                                }
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^(void) {
                                    if (_delegate && [_delegate respondsToSelector:@selector(bracelet:didUpdateRunItem:)]) {
                                        [_delegate bracelet:peripheral didUpdateRunItem:self.currentItem];
                                    }
                                });
                            }
                        }
                    }
                });
                
            }
            //同步个人信息与闹钟数据成功
            if ([receiveStr hasPrefix:@"23"]) {
                NSDictionary *dict = @{@"key":@"05",@"data":@"同步个人信息与闹钟数据成功"};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            //开启ANCS
            if ([receiveStr hasPrefix:@"a1"]) {
                NSDictionary *dict = @{@"key":@"06",@"data":@"请求开启ANCS配对"};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            //设置久坐提醒
            if ([receiveStr hasPrefix:@"32"]) {
                NSDictionary *dict = @{@"key":@"12",@"data":@"设置久坐提醒成功"};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            //开启拍照功能
            if ([receiveStr hasPrefix:@"a4"]) {
                NSDictionary *dict = @{@"key":@"16",@"data":@"跳到拍照按钮"};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            //打开相机
            if ([receiveStr isEqualToString:@"f50000"]) {
                NSDictionary *dict = @{@"key":@"16",@"data":@"开始拍照"};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            //获取版本号
            if ([receiveStr hasPrefix:@"fb0c"]) {
                NSString *FWVerSion1 = [receiveStr substringWithRange:NSMakeRange(22, 2)];
                unsigned long sion1 = strtoul([FWVerSion1 UTF8String],0,16);
                NSString *FWVerSion2 = [receiveStr substringWithRange:NSMakeRange(24, 2)];
                unsigned long sion2 = strtoul([FWVerSion2 UTF8String],0,16);
                NSString *FWVerSion3 = [receiveStr substringWithRange:NSMakeRange(26, 2)];
                unsigned long sion3 = strtoul([FWVerSion3 UTF8String],0,16);
                NSString *dataersion = [NSString stringWithFormat:@"%c%c%c",(int)sion1,(int)sion2,(int)sion3];
                NSString *fwVersion = [NSString stringWithFormat:@"V%c.%c.%c",(int)sion1,(int)sion2,(int)sion3];
                NSDictionary *dict = @{@"key":@"17",@"data":dataersion,@"version":fwVersion};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            //24小时心率
            if ([receiveStr hasPrefix:@"25"]) {
                [self.synchronize upDateHeartRateForCharacteristic:receiveStr];
            }
            //睡眠与运动数据
            if ([receiveStr hasPrefix:@"24"] || [receiveStr hasPrefix:@"4"] || [receiveStr hasPrefix:@"0"]) {
                [self.synchronize handleSleepAndSportData:receiveStr];
            }
            //开启找手机功能
            if ([receiveStr hasPrefix:@"f30101"]) {
                NSDictionary *dict = @{@"key":@"21",@"data":@"开启手环找手机功能"};
                if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                    [_delegate peripheral:peripheral didUpdateValue:dict];
                }
            }
            if ([receiveStr hasPrefix:@"a601"]) {//是否打开手机ANCS推送
                if ([receiveStr isEqualToString:@"a60100"]) {
                    NSDictionary *dict = @{@"data":@"已开启推送"};
                    if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                        [_delegate peripheral:peripheral didUpdateValue:dict];
                    }
                } else if ([receiveStr isEqualToString:@"a60101"]) {
                    //开启
                    NSDictionary *dict = @{@"data":@"已关闭推送"};
                    if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
                        [_delegate peripheral:peripheral didUpdateValue:dict];
                    }
                }
            }
        }
    }
}

-(void)synchronizeHeartRateDoneWithArray:(NSArray *)HeartRateArray{
    NSDictionary *dict = @{@"data":HeartRateArray,@"key":@"18"};
    if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
        [_delegate peripheral:self.currentBracelet didUpdateValue:dict];
    }
}
-(void)synchronizeSportDataDoneWithArray:(NSArray *)SportDataArray{
    NSDictionary *dict = @{@"data":SportDataArray,@"key":@"20"};
    if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateValue:)]) {
        [_delegate peripheral:self.currentBracelet didUpdateValue:dict];
    }
}
-(void)synchronizeSleepDataDoneWithArray:(NSArray *)SleepDataArray{
    if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didUpdateSleepValue:)]) {
        [_delegate peripheral:self.currentBracelet didUpdateSleepValue:SleepDataArray];
    }
}
//写入特征值
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"写入特征值发生错误:%@",error);
        return;
    }else{
//        NSLog(@"写入特征值:%@",characteristic.UUID.UUIDString);
    }
}
//通知状态改变
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"通知状态改变发生错误:%@",error);
        return;
    }else{
//        NSLog(@"通知状态改变:%@",characteristic.UUID.UUIDString);
        if ([characteristic.UUID.UUIDString isEqualToString:YXBraceletFFF1]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_delegate && [_delegate respondsToSelector:@selector(BLEDidConnectBraceletToConnectPeripheral:)]) {
                    [_delegate BLEDidConnectBraceletToConnectPeripheral:peripheral];
                }
            });
        }
    }
}
//读取RSSI
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    for (SFBLEDeviceInfo * info in self.deviceArray) {
        if ([info.peripheral isEqual:peripheral]) {
            info.RSSI = [RSSI integerValue];
            return;
        }
    }
}

#pragma mark - Tool

- (CBPeripheral *)retrievePeripheralWithIdentifierUUIDString:(nonnull NSString *)UUIDString
{
    NSUUID * UUID = [[NSUUID alloc]initWithUUIDString:UUIDString];
    NSArray<CBPeripheral *> * deviceArr = [self.centralManager retrievePeripheralsWithIdentifiers:@[UUID]];
    return [deviceArr firstObject];
}

- (NSArray<CBPeripheral *> *)retrievePeripheralArrWithIdentifierUUIDStringArr:(NSArray<NSString *> *)UUIDStringArr
{
    NSMutableArray * UUIDArr = [NSMutableArray array];
    for (NSString * UUIDString in UUIDStringArr) {
        NSUUID * UUID = [[NSUUID alloc]initWithUUIDString:UUIDString];
        [UUIDArr addObject:UUID];
    }
    return [self.centralManager retrievePeripheralsWithIdentifiers:UUIDArr];
}

- (CBPeripheral *)retrieveConnectedPeripheralWithServiceUUIDString:(nonnull NSString *)UUIDString
{
    CBUUID * UUID = [CBUUID UUIDWithString:UUIDString];
    NSArray<CBPeripheral *> * deviceArr = [self.centralManager retrieveConnectedPeripheralsWithServices:@[UUID]];
    return [deviceArr firstObject];
}
//通过服务的UUID去获取服务
- (CBService *)getServiceByUUIDString:(NSString *)UUIDString fromPeripheral:(CBPeripheral *)peripheral
{
    for (CBService * service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:UUIDString]) {
            return service;
        }
    }
    return nil;
}
//通过特征值的UUID去获取特征值
- (CBCharacteristic *)getCharacteristicByUUIDString:(NSString *)UUIDString fromService:(CBService *)service
{
    for (CBCharacteristic * characteristic in service.characteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:UUIDString]) {
            return characteristic;
        }
    }
    return nil;
}
#pragma mark - Data

- (NSData *)dataFromHexString:(NSString *)hexString
{
    //要求偶数
    if (hexString.length%2 != 0){
        return nil;
    }
    Byte tempByte[1] = {0};
    NSMutableData * data = [NSMutableData data];
    for (NSInteger i = 0; i < hexString.length; i += 2)
    {
        NSString * hexChar = [hexString substringWithRange:NSMakeRange(i, 2)];
        tempByte[0] = strtoull([hexChar UTF8String], 0, 16);
        [data appendBytes:tempByte length:1];
    }
    return data;
}

- (NSString *)hexStringFromData:(NSData *)data
{
    const Byte * bytes = data.bytes;
    NSString * hexStr = @"";
    for (NSInteger i = 0; i < data.length; i++) {
        hexStr = [NSString stringWithFormat:@"%@%02x",hexStr,bytes[i] & 0xff];
    }
    return hexStr;
}
- (NSString *)translateToSixTeenWithNum:(NSInteger)num
{
    NSString * str = [[NSString alloc]initWithFormat:@"%02lx",(long)num & 0xff];
    
    return str;
}
- (NSInteger)translateToTenWithString:(NSString *)string
{
    NSInteger num = (NSInteger)strtoull([string UTF8String], 0, 16);
    
    return (long)num;
}
- (NSInteger)getStepWithStr:(NSString *)str
{
    str = [str substringWithRange:NSMakeRange(4, 6)];
    return [self translateToTenWithString:str];
}

#pragma mark - Bracelet

- (NSArray<NSString *> *)getHeartRateWithStr:(NSString *)str
{
    NSInteger dataLength = str.length - 6;
    str = [str substringWithRange:NSMakeRange(4,dataLength)];
    
    NSMutableArray * numArr = [NSMutableArray array];
    for (NSInteger i = 0; i < dataLength/2; i++) {
        NSString * numStr = [str substringWithRange:NSMakeRange(i*2, 2)];
        NSString * num = [NSString stringWithFormat:@"%ld",(long)[self translateToTenWithString:numStr]];
        [numArr addObject:num];
    }
    
    return [numArr copy];
}

- (SFRunItem *)getRunDataWithStr:(NSString *)str
{
    str = [str substringWithRange:NSMakeRange(4, 30)];
    
    SFRunItem * runItem = [SFRunItem new];
    
    NSInteger  numArr[20] = {0};
    for (NSInteger i = 0; i < 13; i++) {
        NSString * numStr = [str substringWithRange:NSMakeRange(i*2, 2)];
        numArr[i] = [self translateToTenWithString:numStr];
    }
    runItem.gap = numArr[0];
    runItem.startYear = numArr[1];
    runItem.startMonth = numArr[2];
    runItem.startDay = numArr[3];
    runItem.startHour = numArr[4];
    runItem.startMinute = numArr[5];
    runItem.startSecond = numArr[6];
    runItem.startDate = [NSString stringWithFormat:@"20%02ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)runItem.startYear,(long)runItem.startMonth,(long)runItem.startDay,(long)runItem.startHour,(long)runItem.startMinute,(long)runItem.startSecond];
    runItem.showStartDate = [NSString stringWithFormat:@"20%02ld年%02ld月%02ld日 %02ld:%02ld:%02ld",(long)runItem.startYear,(long)runItem.startMonth,(long)runItem.startDay,(long)runItem.startHour,(long)runItem.startMinute,(long)runItem.startSecond];
    runItem.stopYear = numArr[7];
    runItem.stopMonth = numArr[8];
    runItem.stopDay = numArr[9];
    runItem.stopHour = numArr[10];
    runItem.stopMinute = numArr[11];
    runItem.stopSecond = numArr[12];
    runItem.stopDate = [NSString stringWithFormat:@"20%02ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)runItem.stopYear,(long)runItem.stopMonth,(long)runItem.stopDay,(long)runItem.stopHour,(long)runItem.stopMinute,(long)runItem.stopSecond];
    runItem.showStopDate = [NSString stringWithFormat:@"20%02ld年%02ld月%02ld日 %02ld:%02ld:%02ld",(long)runItem.stopYear,(long)runItem.stopMonth,(long)runItem.stopDay,(long)runItem.stopHour,(long)runItem.stopMinute,(long)runItem.stopSecond];
    runItem.runSteps = [self translateToTenWithString:[str substringWithRange:NSMakeRange(26, 4)]];
    runItem.heartCount = [self getSpendTimeWithStartDate:runItem.startDate stopDate:runItem.stopDate]/120;
    runItem.spendTime = [self getSpendTimeWithStartDate:runItem.startDate stopDate:runItem.stopDate];
    if ([self checkRunDateIsOkWithStartDate:runItem.startDate stopDate:runItem.stopDate]) {
        return runItem;
    }else{
        return nil;
    }
}

//写入手环的数据
- (void)writeValue:(NSString *)value forCharacteristicUUIDStr:(NSString *)characteristicUUIDStr toBracelet:(CBPeripheral *)bracelet
{
    NSInteger maxLength = 40;
    NSInteger count = value.length/maxLength + (value.length%maxLength ? 1 : 0);
    for (NSInteger i = 0; i < count; i++) {
        NSString * sectionCmd;
        if (i == count-1) {
            sectionCmd = [value substringWithRange:NSMakeRange(i*maxLength, value.length-i*maxLength)];
        }else{
            sectionCmd = [value substringWithRange:NSMakeRange(i*maxLength, maxLength)];
        }
        [self writeValue:sectionCmd forServiceUUIDStr:YXBraceletService andCharacteristicUUIDStr:characteristicUUIDStr toPeripheral:bracelet];
    }
}

//计算手环命令的校验码（有数据长度位）
- (NSString *)getBraceletCheckStrbyCmd_1:(NSString *)cmd
{
    //数据长度
    NSString * dataCount = [cmd substringWithRange:NSMakeRange(2, 2)];
    NSInteger count = [self translateToTenWithString:dataCount];
    //计算校正位
    NSInteger checkNum = 0;
    if (cmd.length >= (count+2)*2) {
        for (NSInteger i = 0; i < count; i++) {
            NSString * dataStr = [cmd substringWithRange:NSMakeRange(4+2*i, 2)];
            NSInteger dataNum = [self translateToTenWithString:dataStr];
            checkNum = checkNum ^ dataNum;
        }
    }else{
        NSLog(@"数据长度错误");
    }
    return [self translateToSixTeenWithNum:checkNum];
}
- (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop
{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yy-MM-dd HH:mm:ss";
    NSDate * startDate = [dateFormatter dateFromString:start];
    NSDate * stopDate = [dateFormatter dateFromString:stop];
    NSTimeInterval interval = [stopDate timeIntervalSinceDate:startDate];
    return (NSInteger)interval;
}
//计算手环命令的校验码（无数据长度位）
- (NSString *)getBraceletCheckStrbyCmd_2:(NSString *)cmd
{
    //数据长度
    NSInteger count = cmd.length/2-2;
    //计算校正位
    NSInteger checkNum = 0;
    for (NSInteger i = 0; i < count; i++) {
        NSString * dataStr = [cmd substringWithRange:NSMakeRange(4+2*i, 2)];
        NSInteger dataNum = [self translateToTenWithString:dataStr];
        checkNum = checkNum ^ dataNum;
    }
    return [self translateToSixTeenWithNum:checkNum];
}
- (BOOL)checkRunDateIsOkWithStartDate:(NSString *)start stopDate:(NSString *)stop
{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yy-MM-dd HH:mm:ss";
    NSDate * startDate = [dateFormatter dateFromString:start];
    NSDate * stopDate = [dateFormatter dateFromString:stop];
    
    if ([startDate compare:stopDate] == NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}
//对十六进制字符串异或
- (NSString *)yihuoStrWithString:(NSString *)codeStr{
    if (codeStr.length%2!=0) {
        NSLog(@"异或字符串错误");
        return @"00";
    }
    NSString *yhStr;
    unsigned long red = 0x00;
    for (int i=0; i<codeStr.length/2; i++) {
        NSString *str1 = [NSString stringWithFormat:@"0x%@",[codeStr substringWithRange:NSMakeRange(i*2, 2)]];
        unsigned long red1 = strtoul([str1 UTF8String],0,16);
        yhStr = [[NSString alloc] initWithFormat:@"%1hhx",(unsigned char) (red ^ red1)];
        unsigned long tmp = strtoul([yhStr UTF8String],0,16);
        red = tmp;
    }
    if (yhStr.length==1) {
        yhStr = [NSString stringWithFormat:@"0%@",yhStr];
    } else {
        yhStr= [NSString stringWithFormat:@"%@",yhStr];
    }
    return yhStr;
}
- (void)updataHeartRateWithDateStr:(NSString *)dateString{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *UTCNow;
    if (dateString) {
        UTCNow = [dateFormatter1 dateFromString:dateString];//格林尼治时间
    } else {
        UTCNow = [NSDate date];
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ee"];
    NSString *weekNum = [dateFormatter stringFromDate:UTCNow];
    
    if (weekNum.intValue==1) {
        weekNum = @"07";
    } else {
        weekNum = [NSString stringWithFormat:@"%.2d",weekNum.intValue-1];
    }
    [NSThread sleepForTimeInterval:0.2];
    [self sendOrderToBraceletWithOrder:[NSString stringWithFormat:@"C501%@%@",weekNum,weekNum]];
}
//二进制字符串转十六进制字符串
- (NSString *)data16StrWithData2Str:(NSString *)data2Str {
    if (data2Str.length%4!=0) {
        NSLog(@"二进制字符串有误");
        return @"fe";
    }
    NSString *str16 = @"";
    for (int i=0; i<data2Str.length/4; i++) {
        NSString *str = [data2Str substringWithRange:NSMakeRange(i*4, 4)];
        if ([str isEqualToString:@"0000"]) {
            str16 = [str16 stringByAppendingString:@"0"];
        } else if ([str isEqualToString:@"0001"]) {
            str16 = [str16 stringByAppendingString:@"1"];
        } else if ([str isEqualToString:@"0010"]) {
            str16 = [str16 stringByAppendingString:@"2"];
        } else if ([str isEqualToString:@"0011"]) {
            str16 = [str16 stringByAppendingString:@"3"];
        } else if ([str isEqualToString:@"0100"]) {
            str16 = [str16 stringByAppendingString:@"4"];
        } else if ([str isEqualToString:@"0101"]) {
            str16 = [str16 stringByAppendingString:@"5"];
        } else if ([str isEqualToString:@"0110"]) {
            str16 = [str16 stringByAppendingString:@"6"];
        } else if ([str isEqualToString:@"0111"]) {
            str16 = [str16 stringByAppendingString:@"7"];
        } else if ([str isEqualToString:@"1000"]) {
            str16 = [str16 stringByAppendingString:@"8"];
        } else if ([str isEqualToString:@"1001"]) {
            str16 = [str16 stringByAppendingString:@"9"];
        } else if ([str isEqualToString:@"1010"]) {
            str16 = [str16 stringByAppendingString:@"a"];
        } else if ([str isEqualToString:@"1011"]) {
            str16 = [str16 stringByAppendingString:@"b"];
        } else if ([str isEqualToString:@"1100"]) {
            str16 = [str16 stringByAppendingString:@"c"];
        } else if ([str isEqualToString:@"1101"]) {
            str16 = [str16 stringByAppendingString:@"d"];
        } else if ([str isEqualToString:@"1110"]) {
            str16 = [str16 stringByAppendingString:@"e"];
        } else if ([str isEqualToString:@"1111"]) {
            str16 = [str16 stringByAppendingString:@"f"];
        }
    }
    return str16;
}
//根据时间  开关获得开启闹钟发送指令
- (NSString *)sendAlarmCode:(NSString *)timeStr AndWeek:(NSString *)weekNumStr isOpen:(BOOL)open{
    NSString *str116 = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[timeStr substringToIndex:2].intValue]];
    NSString *str216 = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[timeStr substringFromIndex:3].intValue]];
    NSString *weekStr = [self data16StrWithData2Str:weekNumStr];
    
    if (str116.length==1) {
        str116 = [NSString stringWithFormat:@"0%@",str116];
    } else {
        str116= [NSString stringWithFormat:@"%@",str116];
    }
    if (str216.length==1) {
        str216 = [NSString stringWithFormat:@"0%@",str216];
    } else {
        str216= [NSString stringWithFormat:@"%@",str216];
    }
    NSString *naozhongStr1;
    if (open) {
        naozhongStr1 = [NSString stringWithFormat:@"01%@%@01%@",str116,str216,weekStr];
    } else {
        naozhongStr1 = [NSString stringWithFormat:@"00%@%@01%@",str116,str216,weekStr];
    }
    return naozhongStr1;
}
#pragma mark - 指令集合

//设置闹钟时间
- (void)setBraceletTime
{
    dispatch_async(sendMessageQueue, ^(void) {
        NSString * cmd = @"c207";
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSCalendarUnit type = NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitQuarter|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitYearForWeekOfYear|NSCalendarUnitNanosecond|NSCalendarUnitCalendar|NSCalendarUnitTimeZone;
        
        NSDateComponents *components = [calendar components:type fromDate:[NSDate date]];
        
        NSInteger byte3 = components.year % 2000;
        NSString * byte3Str = [self translateToSixTeenWithNum:byte3];
        cmd = [cmd stringByAppendingString:byte3Str];
        
        NSInteger byte4 = components.month;
        NSString * byte4Str = [self translateToSixTeenWithNum:byte4];
        cmd = [cmd stringByAppendingString:byte4Str];
        
        NSInteger byte5 = components.day;
        NSString * byte5Str = [self translateToSixTeenWithNum:byte5];
        cmd = [cmd stringByAppendingString:byte5Str];
        
        NSInteger byte6 = components.hour;
        NSString * byte6Str = [self translateToSixTeenWithNum:byte6];
        cmd = [cmd stringByAppendingString:byte6Str];
        
        NSInteger byte7 = components.minute;
        NSString * byte7Str = [self translateToSixTeenWithNum:byte7];
        cmd = [cmd stringByAppendingString:byte7Str];
        
        NSInteger byte8 = components.second;
        NSString * byte8Str = [self translateToSixTeenWithNum:byte8];
        cmd = [cmd stringByAppendingString:byte8Str];
        
        NSInteger byte9 = components.weekday-1;
        NSString * byte9Str = [self translateToSixTeenWithNum:byte9];
        cmd = [cmd stringByAppendingString:byte9Str];
        
        NSInteger checkNum = byte3 ^ byte4 ^ byte5 ^ byte6 ^ byte7 ^ byte8 ^ byte9;
        NSString * checkStr = [self translateToSixTeenWithNum:checkNum];
        cmd = [cmd stringByAppendingString:checkStr];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self writeValue:cmd forCharacteristicUUIDStr:YXBraceletFFF2 toBracelet:self.currentBracelet];
        });
    });
}
- (void)syncPersonInfoWithHight:(NSString *)heightStr AndWeight:(NSString *)weightStr AndSendCodeArr:(NSArray *)sendAlarmCodeArr
{
    dispatch_async(sendMessageQueue, ^(void) {
        NSMutableArray *sendCodeArr = [NSMutableArray arrayWithArray:sendAlarmCodeArr];
        NSString *senStr = @"";
        NSString *codeStr = @"";
        senStr = [senStr stringByAppendingString:@"832f"];
        for (NSString *datasendCode in sendCodeArr) {
            senStr = [senStr stringByAppendingString:datasendCode];
            NSString *str1 = [self yihuoStrWithString:datasendCode];
            codeStr = [codeStr stringByAppendingString:str1];
        }
        for (int i=0; i<94-sendCodeArr.count*10; i++) {
            senStr = [senStr stringByAppendingString:@"0"];
        }
        
        int weight = [heightStr intValue];
        if (weight <=0) {
            weight = 65;
        }
        int height = [weightStr intValue];
        if (height <=0) {
            height = 175;
        }
        NSString *personInfo = [NSString stringWithFormat:@"%.2x%.2x", height,weight];
        NSString *personInfoSetActive = @"01";
        // walk stride & running stride
        personInfo = [personInfo stringByAppendingString:@"4141"];
        senStr = [senStr stringByReplacingCharactersInRange:NSMakeRange(72, 8) withString:personInfo];
        senStr = [senStr stringByReplacingCharactersInRange:NSMakeRange(96, 2) withString:personInfoSetActive];
        codeStr = [codeStr stringByAppendingString:personInfo];
        codeStr = [codeStr stringByAppendingString:personInfoSetActive];
        
        senStr = [senStr stringByAppendingString:[self yihuoStrWithString:codeStr]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self writeValue:senStr forCharacteristicUUIDStr:YXBraceletFFF2 toBracelet:self.currentBracelet];
        });
    });
}
//读取手环电量
- (void)readBraceletBattery
{
    CBService * service = [self getServiceByUUIDString:YXBraceletBatteryService fromPeripheral:self.currentBracelet];
    CBCharacteristic * characteristic = [self getCharacteristicByUUIDString:YXBraceletBattery fromService:service];
    if (characteristic.properties & CBCharacteristicPropertyRead) {
        [self.currentBracelet readValueForCharacteristic:characteristic];
    }
}
- (void)sendOrderToBraceletWithOrder:(NSString *)order{
    [self writeValue:order forCharacteristicUUIDStr:YXBraceletFFF2 toBracelet:self.currentBracelet];
}
//获取运动步数
- (void)getCurrentStep{
    [self sendOrderToBraceletWithOrder:@"c6010808"];
}
//同步跑步数据
- (void)syncSportData{
    [self sendOrderToBraceletWithOrder:@"b30000"];
}
//获取版本号
- (void)sendOrderWithGetVersion{
    [self sendOrderToBraceletWithOrder:@"FB0000"];
}
- (void)openANCS{
    [self sendOrderToBraceletWithOrder:@"A1010101"];
}
- (void)closeANCS{
    [self sendOrderToBraceletWithOrder:@"A1010000"];
}
//开启心率监测
- (void)openHeartRateExamine{
    [self sendOrderToBraceletWithOrder:@"93050000000001"];
}
//关闭心率监测
- (void)closeHeartRateExamine{
    [self sendOrderToBraceletWithOrder:@"93050000000000"];
}
//开启闹钟提醒
- (void)openAlarmClockWithTime:(NSString *)time AndWeek:(NSString *)weekNumStr{
    NSString *alarmStr = [self sendAlarmCode:time AndWeek:weekNumStr isOpen:YES];
    [self syncPersonInfoWithHight:@"175" AndWeight:@"65" AndSendCodeArr:@[alarmStr]];
}
//关闭闹钟提醒
- (void)closeAlarmClockWithTime:(NSString *)time AndWeek:(NSString *)weekNumStr{
    NSString *alarmStr = [self sendAlarmCode:time AndWeek:weekNumStr isOpen:NO];
    [self syncPersonInfoWithHight:@"175" AndWeight:@"65" AndSendCodeArr:@[alarmStr]];
}
/**
 开启久坐提醒
 @param number 久坐时间  如: 45
 */
- (void)openLongSitWithTime:(NSString *_Nullable)number{
    NSString *str = [NSString stringWithFormat:@"0x%.02d",(number.intValue)];
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    unsigned long red = strtoul([str UTF8String],0,16);
    NSString *zhiliang11 = [[NSString alloc] initWithFormat:@"%1hhx",(unsigned char) (red ^ 0x08 ^ 0x14 ^ 0x7f ^ 0x01)];
    NSString *tmpStr11;
    if (zhiliang11.length==1) {
        tmpStr11 = [NSString stringWithFormat:@"0%@",zhiliang11];
    } else {
        tmpStr11= [NSString stringWithFormat:@"%@",zhiliang11];
    }
    NSString *jiuzuoStr = [NSString stringWithFormat:@"8605010814%.2dfe%@",number.intValue,tmpStr11];
    [self sendOrderToBraceletWithOrder:jiuzuoStr];
}

/**
 关闭久坐提醒
 @param number 久坐时间  如: 45
 */
- (void)closeLongSitWithTime:(NSString *_Nullable)number{
    NSString *str = [NSString stringWithFormat:@"0x%.02d",(number.intValue)];
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    unsigned long red = strtoul([str UTF8String],0,16);
    NSString *zhiliang11 = [[NSString alloc] initWithFormat:@"%1hhx",(unsigned char) (red ^ 0x08 ^ 0x14 ^ 0x7f ^ 0x00)];
    NSString *tmpStr11;
    if (zhiliang11.length==1) {
        tmpStr11 = [NSString stringWithFormat:@"0%@",zhiliang11];
    } else {
        tmpStr11= [NSString stringWithFormat:@"%@",zhiliang11];
    }
    NSString *jiuzuoStr = [NSString stringWithFormat:@"8605000814%.2dfe%@",number.intValue,tmpStr11];
    [self sendOrderToBraceletWithOrder:jiuzuoStr];
}
//开启抬腕亮屏
- (void)openLiftWristScreenWithTime:(NSString *_Nullable)startTime AndEndTime:(NSString *_Nullable)endTime{
    NSString *stringZero = [NSString stringWithFormat:@"01"];
    unsigned long checkNum = (stringZero.intValue ^ startTime.intValue ^ endTime.intValue) & 0xff;
    NSString *yihuo = checkNum < 16 ?([NSString stringWithFormat:@"0%lx", checkNum]) : ([NSString stringWithFormat:@"%lx", checkNum]);
    NSString *hour1 = startTime.intValue < 16 ?([NSString stringWithFormat:@"0%x", startTime.intValue]) : ([NSString stringWithFormat:@"%x", startTime.intValue]);
    NSString *hour2 = endTime.intValue < 16 ?([NSString stringWithFormat:@"0%x", endTime.intValue]) : ([NSString stringWithFormat:@"%x", endTime.intValue]);
    NSString *sendStr = [NSString stringWithFormat:@"A703%@%@%@%@",stringZero,hour1,hour2,yihuo];
    [self sendOrderToBraceletWithOrder:sendStr];
}
//关闭抬腕亮屏
- (void)closeLiftWristScreen{
    [self sendOrderToBraceletWithOrder:@"A70300001717"];
}

//打开相机拍照
- (void)OpenCameraPhotograph{
    [self sendOrderToBraceletWithOrder:@"A50000"];
}
//获取手环版本
- (void)GetBraceletVersion{
    [self sendOrderToBraceletWithOrder:@"FB0000"];
}
//获取当天心率数据
- (void)GetHeartRateWithDate:(NSString *_Nullable)dateStr{
    self.synchronize.heartLongStr = @"";
    [self updataHeartRateWithDateStr:dateStr];
}
//同步运动与睡眠数据
- (void)SynchronizeSportAndSleepDataWithDate:(NSString *_Nullable)dateStr{
    self.synchronize.orignalData = @"";
    [self.synchronize syncSleepAndSportWithDateStr:dateStr];
}
@end
