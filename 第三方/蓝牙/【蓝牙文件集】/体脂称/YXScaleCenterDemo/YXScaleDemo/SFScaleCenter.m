//
//  SFScaleCenter.m
//  YXScaleDemo
//
//  Created by 小富 on 2017/8/2.
//  Copyright © 2017年 xiaofu. All rights reserved.
//

#import "SFScaleCenter.h"
#import "YXScaleInfo.h"
#import "HTBodyfat.h"
#import "NSString+Change.h"

#pragma mark - 体脂秤

NSString * const YXBLEScaleName = @"Scale";

NSString * const YXScaleService = @"FFF0";

NSString * const YXScaleFFF1 = @"FFF1";//写

NSString * const YXScaleFFF4 = @"FFF4";//通知

@interface SFScaleCenter ()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    //发送前解析数据
    dispatch_queue_t sendMessageQueue;
    //收到后解析数据
    dispatch_queue_t analyticDataQueue;
}
@property (nonatomic,strong) CBCentralManager * centralManager;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, assign) NSInteger sex;

@end

@implementation SFScaleCenter

+ (instancetype)shareManager {
    static SFScaleCenter * sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [SFScaleCenter new];
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
    
    return self;
    
}

#pragma mark - CentralMethod

//搜索设备
- (void)scanScaleWithHeight:(CGFloat)height Weight:(CGFloat)weight Sex:(NSInteger)sex
{
    [self.centralManager stopScan];
    [self.deviceArray removeAllObjects];
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"蓝牙未打开，搜索失败");
        return;
    }else{
        self.height = height;
        self.weight = weight;
        self.sex = sex;
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
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
    }
    [self.centralManager connectPeripheral:peripheral options:nil];
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
        for (BLEDeviceInfo * info in self.deviceArray) {
            if ([info.peripheral isEqual:peripheral]) {
                return;
            }
        }
        BLEDeviceInfo * newDevice = [BLEDeviceInfo new];
        newDevice.name = peripheral.name;
        NSLog(@"advertising name：%@\nGAP name：%@", advertisementData[CBAdvertisementDataLocalNameKey],peripheral.name);
        newDevice.peripheral = peripheral;
        newDevice.UUIDString = peripheral.identifier.UUIDString;
        newDevice.RSSI = [RSSI integerValue];
        newDevice.advertisementData = advertisementData;
        [self.deviceArray addObject:newDevice];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (_delegate && [_delegate respondsToSelector:@selector(BLEDiscoverDevices)]) {
                [_delegate BLEDiscoverDevices];
            }
        });
    });
}
//连接设备成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral

{
    if ([peripheral.name containsString:YXBLEScaleName]) {
        self.scale = peripheral;
    }
    peripheral.delegate = self;
    //去发现服务
    [peripheral discoverServices:nil];
}
//连接设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(BLEDidFailToConnectPeripheral:)]) {
        [_delegate BLEDidFailToConnectPeripheral:peripheral];
    }
}
//断开设备成功
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if ([peripheral isEqual:self.scale]) {
        self.scale = nil;
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
    NSLog(@"发送指令:%@",value);
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
            //体脂秤
            if ([peripheral.name containsString:YXBLEScaleName]) {
                if ([characteristic.UUID.UUIDString isEqualToString:YXScaleFFF4]) {
                    if (characteristic.properties & CBCharacteristicPropertyNotify) {
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                    break;
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
        //秤
        if ([peripheral.name containsString:YXBLEScaleName]) {
            if (receiveStr.length >= 22) {
                NSLog(@"秤的数据:%@",receiveStr);
                dispatch_async(analyticDataQueue, ^(void) {
                    YXScaleInfo * receiveInfo = [self getScaleDataWithReceiveStr:[receiveStr substringToIndex:22] height:self.height age:self.weight sex:self.sex];
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        if (_delegate && [_delegate respondsToSelector:@selector(scale:didUpdateScaleInfo:)]) {
                            [_delegate scale:peripheral didUpdateScaleInfo:receiveInfo];
                        }
                    });
                });
            }
        }
        
    }
}
//写入特征值
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"写入特征值发生错误:%@",error);
        return;
    }else{
        NSLog(@"写入特征值:%@",characteristic.UUID.UUIDString);
    }
}
//通知状态改变
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"通知状态改变发生错误:%@",error);
        return;
    }else{
        if ([characteristic.UUID.UUIDString isEqualToString:YXScaleFFF4]) {
            if (_delegate && [_delegate respondsToSelector:@selector(BLEDidConnectScale:)]) {
                [_delegate BLEDidConnectScale:peripheral];
            }
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

#pragma mark - Scale

- (void)writeScaleStr:(NSString *)scaleStr toScale:(CBPeripheral *)scale
{
    [self writeValue:scaleStr forServiceUUIDStr:YXScaleService andCharacteristicUUIDStr:YXScaleFFF1 toPeripheral:scale];
}

//从体脂秤获取到的数据
- (YXScaleInfo *)getScaleDataWithReceiveStr:(NSString *)receiveStr height:(CGFloat)height age:(CGFloat)age sex:(NSInteger)sex
{
    if (receiveStr.length == 22)
    {
        NSLog(@"bluetooth data==:%@", receiveStr);
        
        NSString *byte6 = [receiveStr substringWithRange:NSMakeRange(10, 2)];
        NSString *byte7 = [receiveStr substringWithRange:NSMakeRange(12, 2)];
        NSString *byte8 = [receiveStr substringWithRange:NSMakeRange(14, 2)];
        long zukang = strtoul([[NSString stringWithFormat:@"%@%@%@",byte8,byte7,byte6] UTF8String], 0, 16);
        
        NSLog(@"~~~~~~~~~~~%ld~~~~~~~~~~~~~~~",zukang);
        
        NSString * byte4 = [receiveStr substringWithRange:NSMakeRange(6, 2)];
        NSString * byte5 = [receiveStr substringWithRange:NSMakeRange(8, 2)];
        long tizhong = strtoul([[NSString stringWithFormat:@"%@%@",byte5,byte4] UTF8String], 0, 16);
        //体脂类声明
        HTPeopleGeneral *peopleModel = [[HTPeopleGeneral alloc]init];
        
        CGFloat weightKg =     tizhong*0.01;
        CGFloat heightCm =     height;
        NSInteger ageNew =        age;
        NSInteger impedance =  (int)zukang;//阻抗系数
        SexType sexNew =        (SexType)sex;
        PeopleType peopleType = PeopleTypeOrdinary;
        
        //显示体脂参数
        BodyfatErrorType errorType = [peopleModel getBodyfatWithPeopleType:peopleType weightKg:weightKg heightCm:heightCm sex:sexNew age:ageNew impedance:impedance];
        
        YXScaleInfo * info = [YXScaleInfo new];
        info.athleteLevel = 0;
        info.group = 00;
        info.gender = sexNew;
        info.age = ageNew;
        info.height = height;
        info.weight = weightKg;
        info.fat = peopleModel.bodyfatPercentage;
        info.skeleton = peopleModel.boneKg;
        info.muscle = peopleModel.muscleKg;
        info.visceralFatRating = peopleModel.VFAL;
        info.moisture = peopleModel.waterPercentage;
        info.metabolicRate = peopleModel.BMR;
        info.BMI = peopleModel.BMI;
        info.dateStr = [self getBeijingNowTime];
        info.bodyAge = 0;
        switch(errorType){
            case ErrorTypeNone:{
                info.isError = NO;
                info.error = @"测量成功";
                if (peopleModel.BMI == 22) {
                    info.bodyAge = info.age - 5;
                }else if (peopleModel.BMI > 22 && peopleModel.BMI <= 30){
                    info.bodyAge = (info.age - 5)+(peopleModel.BMI - 22) * (5/(24.9-22));
                    if ((info.bodyAge - info.age) > 5 || (info.bodyAge - info.age) < -5) {
                        info.bodyAge = info.age + 8;
                    }
                }else if (peopleModel.BMI >= 10 && peopleModel.BMI < 22){
                    info.bodyAge = (info.age - 5)+(22 - peopleModel.BMI) * (5/(22-18.5));
                    if ((info.bodyAge - info.age) > 5 || (info.bodyAge - info.age) < -5) {
                        info.bodyAge = info.age + 5;
                    }
                }
            }break;
            case ErrorTypeImpedance:{
                info.isError = NO;
                info.error = @"阻抗有误！";
            }break;
            case ErrorTypeAge:{
                info.isError = YES;
                info.error = @"年龄参数有误！";
            }break;
            case ErrorTypeHeight:{
                info.isError = YES;
                info.error = @"身高参数有误！";
            }break;
            case ErrorTypeWeight:{
                info.isError = YES;
                info.error = @"体重参数有误！";
            }break;
            default:{
                info.isError = YES;
                info.error = @"未知错误！";
            }break;
        }
        return info;
    }
    return nil;
}
//获取当前的北京时间
-(NSString *)getBeijingNowTime{
    //获取当前的UTC时间  并将其转换为北京时间
    NSDate *UTCNow=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *BeiJingTime=[dateFormatter stringFromDate:UTCNow];
    return BeiJingTime;
}

#pragma mark - sendCode
- (void)getWeightData{
    [self writeValue:@"FD370000000000000000CA" forServiceUUIDStr:YXScaleService andCharacteristicUUIDStr:YXScaleFFF1 toPeripheral:self.scale];
}

- (void)turnOffScale
{
    [self writeValue:@"FD350000000000000000C8" forServiceUUIDStr:YXScaleService andCharacteristicUUIDStr:YXScaleFFF1 toPeripheral:self.scale];
}
@end
