//
//  BlueToothManager.m
//  BluetoothPrint
//
//  Created by Tgs on 16/3/7.
//  Copyright © 2016年 Tgs. All rights reserved.
//

#import "BlueToothManager.h"

@implementation BlueToothManager

//创建单例类
+(instancetype)getInstance
{
    static BlueToothManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BlueToothManager alloc]init];
        
    });
    return manager;
    
}
//开始扫描
- (void)startScan
{
    //    [LCProgressHUD showLoadingText:@"正在扫描"];
    
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    _peripheralList = [[NSMutableArray alloc]initWithCapacity:0];
}

//停止扫描
-(void)stopScan
{
    [_manager stopScan];
    
}

//检查蓝牙信息
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"蓝牙打开，开始扫描");
        [central scanForPeripheralsWithServices:nil options:nil];
    }
    else
    {
        NSLog(@"蓝牙不可用");
    }
}

//扫描到的设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@===%@",peripheral.name,RSSI);
    [_peripheralList addObject:peripheral];
    if (bluetoothListArr) {
        bluetoothListArr(_peripheralList);
    }
}
-(void)getBlueListArray:(void (^)(NSMutableArray *blueToothArray))listBlock{
    bluetoothListArr = [listBlock copy];
}
//获取扫描到设备的列表
-(NSMutableArray *)getNameList
{
    
    return _peripheralList;
    
}

//连接设备
-(void)connectPeripheralWith:(CBPeripheral *)per
{
    if (per!=nil) {
        valuePrint = NO;
        _per = nil;
        _char = nil;
        _readChar = nil;
        [_manager connectPeripheral:per options:nil];
    }
}

//连接设备失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (conReturnBlock) {
        conReturnBlock(central,peripheral,@"ERROR");
    }
    //    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

//设备断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (conReturnBlock) {
        conReturnBlock(central,peripheral,@"DISCONNECT");
    }
    //    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
}

//连接设备成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _per = peripheral;
    [_per setDelegate:self];
    [_per discoverServices:nil];
    
}
//成功回调
-(void)connectInfoReturn:(void(^)(CBCentralManager *central ,CBPeripheral *peripheral,NSString *stateStr))myBlock{
    conReturnBlock = [myBlock copy];
}
//扫描设备的服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        //        NSLog(@"扫描%@的服务发生的错误是：%@",peripheral.name,[error localizedDescription]);
        
    }
    else
    {
        for (CBService *service in peripheral.services) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
        if (conReturnBlock) {
            conReturnBlock(nil,peripheral,@"SUCCESS");
        }
    }
}



//扫描服务的特征值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        //        NSLog(@"扫描服务：------->%@的特征值的错误是：%@",service.UUID,[error localizedDescription]);
    }
    else
    {
        for (CBCharacteristic * cha in service.characteristics)
        {
            CBCharacteristicProperties p = cha.properties;
            if (p & CBCharacteristicPropertyBroadcast) {
            }
            if (p & CBCharacteristicPropertyRead) {
            }
            if (p & CBCharacteristicPropertyWriteWithoutResponse) {
                _char = cha;
                //                NSLog(@"WriteWithoutResponse---扫描服务：%@的特征值为：%@",service.UUID,cha.UUID);
            }
            if (p & CBCharacteristicPropertyWrite) {
                //                NSLog(@"Write---扫描服务：%@的特征值为：%@",service.UUID,cha.UUID);
            }
            if (p & CBCharacteristicPropertyNotify) {
                _readChar = cha;
            }
            [_per readValueForCharacteristic:cha];
            [_per discoverDescriptorsForCharacteristic:cha];
        }
    }
}

//获取特征值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        //        NSLog(@"获取特征值%@的错误为%@",characteristic.UUID,error);
        
    }
    else
    {
        //        NSLog(@"------->特征值：%@  value：%@",characteristic.UUID,characteristic.value);
        _responseData = characteristic.value;
        
    }
}

//扫描特征值的描述
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        //        NSLog(@"搜索到%@的Descriptors的错误是：%@",characteristic.UUID,error);
        
    }
    else
    {
        //        NSLog(@",,,,,,,,,,,characteristic uuid:%@",characteristic.UUID);
        //
        //        for (CBDescriptor * d in characteristic.descriptors)
        //        {
        //            NSLog(@"------->Descriptor uuid:%@",d.UUID);
        //
        //        }
    }
}

//获取描述值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    //    if (error)
    //    {
    //        NSLog(@"获取%@的描述的错误是：%@",peripheral.name,error);
    //    }
    //    else
    //    {
    //        NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
    //
    //    }
}

//像蓝牙发送信息
- (void)sendDataWithString:(NSString *)str andInfoData:(NSData *)infoData
{
    if (_per==nil||_char==nil) {
        valuePrint = NO;
        if (conReturnBlock) {
            conReturnBlock(nil ,nil,@"BLUEDISS");
            return;
        }
    }else{
        valuePrint = YES;
        if (str==nil||str.length==0) {
            if (_per && _char)
            {
                switch (_char.properties & 0x04) {
                    case CBCharacteristicPropertyWriteWithoutResponse:
                    {
                        [_per writeValue:infoData forCharacteristic:_char type:CBCharacteristicWriteWithoutResponse];
                        break;
                        
                    }
                    default:
                    {
                        [_per writeValue:infoData forCharacteristic:_char type:CBCharacteristicWriteWithoutResponse];
                        break;
                    }
                }
                
            }
            
        }else{
            NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
            if (_per && _char)
            {
                switch (_char.properties & 0x04) {
                    case CBCharacteristicPropertyWriteWithoutResponse:
                    {
                        [_per writeValue:data forCharacteristic:_char type:CBCharacteristicWriteWithoutResponse];
                        break;
                        
                    }
                    default:
                    {
                        [_per writeValue:data forCharacteristic:_char type:CBCharacteristicWriteWithoutResponse];
                        break;
                    }
                }
                
            }
        }
        
    }
    
}
-(void)getPrintSuccessReturn:(void(^)(BOOL sizeValue))printBlock{
    printSuccess = [printBlock copy];
}
//展示蓝牙返回的信息
-(void)showResult
{
    if (printSuccess&&valuePrint==YES) {
        printSuccess(YES);
    }
}

-(void)getBluetoothPrintWith:(NSDictionary *)dictionary andPrintType:(NSInteger)typeNum{
    NSString *title = @"易田电商";
    //    店铺名字
    NSString *STR1 = [NSString stringWithFormat:@"%@%@\n",dictionary[@"shopname"],@" (销售单)"];
    NSString *str2 = @"- - - - - - - - - - - - - - - -";
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *titleData = [title dataUsingEncoding:enc];
    NSData *shopNameData = [STR1 dataUsingEncoding:enc];
    NSData *xiantiao = [str2 dataUsingEncoding:enc];
    //    下单时间
    NSString *timeStr = [NSString stringWithFormat:@"时间:%@\n",[dictionary objectForKey:@"date"]];
    NSData *timeData = [timeStr dataUsingEncoding:enc];
    //    订单号
    NSString *orderNumStr =[NSString stringWithFormat:@"订单:%@\n",[dictionary objectForKey:@"id"]];
    NSData *orderNumData = [orderNumStr dataUsingEncoding:enc];
    //    用户姓名
    NSString *userName =[NSString stringWithFormat:@"姓名:%@\n",[dictionary objectForKey:@"consignee"]];
    NSData *userNameData = [userName dataUsingEncoding:enc];
    //    用户电话
    NSString *userPhone =[NSString stringWithFormat:@"电话:%@\n",[dictionary objectForKey:@"telphone"]];
    NSData *userPhoneData = [userPhone dataUsingEncoding:enc];
    //    用户地址
    NSString *userAddress =[NSString stringWithFormat:@"地址:%@\n",[dictionary objectForKey:@"address"]];
    NSData *userAddressData = [userAddress dataUsingEncoding:enc];
    NSString *proL = @"单价         数量          小计\n";
    NSData *proData = [proL dataUsingEncoding:enc];
    //   商品数据
    NSArray *productArray = [[NSArray alloc]initWithArray:[dictionary objectForKey:@"goodsArr"]];
    
    double totalMo = 0.00;
    double shifuMo = 0.00;
    if (typeNum==2) {
        totalMo = [[dictionary objectForKey:@"total"] doubleValue]+[[dictionary objectForKey:@"freight"] doubleValue];
        shifuMo = [[dictionary objectForKey:@"shifu"] doubleValue]+[[dictionary objectForKey:@"freight"] doubleValue];
    }else{
        totalMo = [[dictionary objectForKey:@"total"] doubleValue];
        shifuMo = [[dictionary objectForKey:@"shifu"] doubleValue];
    }
    //    总计
    NSString *str11 = [NSString stringWithFormat:@"￥%.1f",totalMo];
    double sizeLen0 =368.00/32.00;
    double sizeTo0 = str11.length;
    double len0 = 368.00-sizeTo0*sizeLen0;
    Byte str11Arr[] = {0x1b,0x24,(int)len0,1};
    NSData *str11ArrData= [NSData dataWithBytes: str11Arr length: sizeof(str11Arr)];
    NSData *str11Data = [str11 dataUsingEncoding:enc];
    //    折扣
    NSString *str12 = [NSString stringWithFormat:@"￥%.1f",[[dictionary objectForKey:@"zhekou"] doubleValue]];
    double sizeLen2 =368.00/32.00;
    double sizeTo2 = str12.length;
    double len2 = 368.00-sizeTo2*sizeLen2;
    Byte str12Arr[] = {0x1b,0x24,(int)len2,1};
    NSData *str12ArrData= [NSData dataWithBytes: str12Arr length: sizeof(str12Arr)];
    NSData *str12Data = [str12 dataUsingEncoding:enc];
    //    运费
    NSString *str14 = [NSString stringWithFormat:@"￥%.1f",[[dictionary objectForKey:@"freight"] doubleValue]];
    double sizeLen4 =368.00/32.00;
    double sizeTo4 = str14.length;
    double len4 = 368.00-sizeTo4*sizeLen4;
    Byte str14Arr[] = {0x1b,0x24,(int)len4,1};
    NSData *str14ArrData= [NSData dataWithBytes: str14Arr length: sizeof(str14Arr)];
    NSData *str14Data = [str14 dataUsingEncoding:enc];
    //    实付
    NSString *str13 = [NSString stringWithFormat:@"￥%.1f",shifuMo];
    double sizeLen3 =368.00/32.00;
    double sizeTo3 = str13.length;
    double len3 = 368.00-sizeTo3*sizeLen3;
    Byte str13Arr[] = {0x1b,0x24,(int)len3,1};
    NSData *str13ArrData= [NSData dataWithBytes: str13Arr length: sizeof(str13Arr)];
    NSData *str13Data = [str13 dataUsingEncoding:enc];
    
    NSString *totalMoney =@"\n总计:";
    NSData *totalMoneyData = [totalMoney dataUsingEncoding:enc];
    //    折扣
    NSString *kill =@"\n折扣:";
    NSData *killData = [kill dataUsingEncoding:enc];
    //    运费
    //    折扣
    NSString *firght =@"\n运费:";
    NSData *firghtData = [firght dataUsingEncoding:enc];
    //    实付
    NSString *asPay =@"\n实付:";
    NSData *asPayData = [asPay dataUsingEncoding:enc];
    
    NSString *dianhua2 = [NSString stringWithFormat:@"\n服务电话:%@|%@\n",dictionary[@"servicephone1"],dictionary[@"servicephone2"]];
    NSData *dianhuaData = [dianhua2 dataUsingEncoding:enc];
    NSString *dianhua4 = @"400-666-3867";
    NSString *dianhua5 = [NSString stringWithFormat:@"%@%@\n",@"加盟/投诉:",dianhua4];
    NSData *tousuData = [dianhua5 dataUsingEncoding:enc];
    NSString *finally1 = @"谢谢惠顾,欢迎下次光临!\n";
    NSData *finallyData = [finally1 dataUsingEncoding:enc];
    NSMutableArray *proInfoDataArray = [[NSMutableArray alloc]init];//数据data
    NSMutableArray *proSizeDataArray = [[NSMutableArray alloc]init];//位置data
    for (int i=0; i<productArray.count; i++) {
        NSMutableArray *proay = [[NSMutableArray alloc]init];//数据data
        NSMutableArray *proSizeay = [[NSMutableArray alloc]init];//位置data
        
        NSDictionary *dicll = [[NSDictionary alloc]initWithDictionary:[productArray objectAtIndex:i]];
        NSString *proName = [NSString stringWithFormat:@"\n%@\n",[dicll objectForKey:@"spname"]];
        NSData *proNameData = [proName dataUsingEncoding:enc];
        [proay addObject:proNameData];
        NSString *proPrice = [NSString stringWithFormat:@"￥%.1f",[[dicll objectForKey:@"price"] doubleValue]];
        NSData *proPriceData = [proPrice dataUsingEncoding:enc];
        [proay addObject:proPriceData];
        Byte array7[] = {0x1b,0x24,0,0};
        NSData *data7= [NSData dataWithBytes: array7 length: sizeof(array7)];
        [proSizeay addObject:data7];
        NSString *proNum = [dicll objectForKey:@"num"];
        Byte array8[] = {0x1b,0x24,150,0};
        NSData *data8= [NSData dataWithBytes: array8 length: sizeof(array8)];
        [proSizeay addObject:data8];
        NSData *proNumData = [proNum dataUsingEncoding:enc];
        [proay addObject:proNumData];
        NSString *proAmount = [NSString stringWithFormat:@"￥%.1f",[[dicll objectForKey:@"Amount"] doubleValue]];
        NSData *proAmountData = [proAmount dataUsingEncoding:enc];
        [proay addObject:proAmountData];
        double sizeLen =368.00/32.00;
        double sizeTo = proAmount.length;
        double len =368.00-sizeTo*sizeLen;
        Byte arrayxa[] = {0x1b,0x24,(int)len,1};
        NSData *dataxa= [NSData dataWithBytes: arrayxa length: sizeof(arrayxa)];
        [proSizeay addObject:dataxa];
        [proInfoDataArray addObject:proay];
        [proSizeDataArray addObject:proSizeay];
    }
    
    
    //    初始化打印机
    Byte insuArray[] ={ 0x1B,0x40};
    NSData *InsuData= [NSData dataWithBytes: insuArray length: sizeof(insuArray)];
    //换行
    Byte array[] ={ 0x0A};
    NSData *data1= [NSData dataWithBytes: array length: sizeof(array)];
    //设置字体大小
    //    Byte array3[] = {0x1D,0x21,10};//放大横向、纵向各一倍
    //    NSData *data3= [NSData dataWithBytes: array3 length: sizeof(array3)];
    //    Byte ziti1[] = {0x1D,0x21,00};//取消字体放大
    //    NSData *ziti= [NSData dataWithBytes: ziti1 length: sizeof(ziti1)];
    //居中
    Byte array4[] = {0x1B,0x61,1};
    NSData *data4= [NSData dataWithBytes: array4 length: sizeof(array4)];
    //居左
    Byte array6[] = {0x1B,0x61,0};
    NSData *data6= [NSData dataWithBytes: array6 length: sizeof(array6)];
    //粗体打印
    Byte array5[] = {0x1B,0x45,0};
    NSData *data5= [NSData dataWithBytes: array5 length: sizeof(array5)];
    //位置
    NSMutableData *mainData = [[NSMutableData alloc]init];
    [mainData appendData:InsuData];//初始化
    [mainData appendData:data1];//换行
    //    [_manager sendDataWithString:nil andInfoData:data3];//字体放大
    [mainData appendData:data5];//粗体打印
    [mainData appendData:data4];//居中
    [mainData appendData:titleData];//易田电商----文本
    [mainData appendData:data1];//换行
    [mainData appendData:shopNameData];//加盟店名字
    [mainData appendData:data6];//居左
    [mainData appendData:xiantiao];//线条
    [mainData appendData:data1];//换行
    [mainData appendData:timeData];//下单时间
    [mainData appendData:orderNumData];//下单订单
    [mainData appendData:xiantiao];//线条
    [mainData appendData:data1];//换行
    [mainData appendData:userNameData];//用户名
    [mainData appendData:userPhoneData];//用户电话
    [mainData appendData:userAddressData];//用户地址
    [mainData appendData:xiantiao];//线条
    [mainData appendData:data1];//换行
    [mainData appendData:proData];//名称数量
    [mainData appendData:xiantiao];//线条
    for (int i=0; i<productArray.count; i++) {
        NSArray *dataee = [proInfoDataArray objectAtIndex:i];
        NSArray *dataww = [proSizeDataArray objectAtIndex:i];
        [mainData appendData:data6];//居左
        [mainData appendData:dataee[0]];//商品名字
        [mainData appendData:dataww[0]];//单价位置
        [mainData appendData:dataee[1]];//商品单价
        [mainData appendData:dataww[1]];//数量位置
        [mainData appendData:dataee[2]];//商品数量
        [mainData appendData:dataww[2]];//小计位置
        [mainData appendData:dataee[3]];//商品小计
        //        sleep(1);
    }
    [mainData appendData:data1];//换行
    [mainData appendData:xiantiao];//线条
    //    运费
    [mainData appendData:data6];//居左
    [mainData appendData:firghtData];//运费标签
    [mainData appendData:str14ArrData];//运费位置
    [mainData appendData:str14Data];//运费
    //    总计
    [mainData appendData:data6];//居左
    [mainData appendData:totalMoneyData];//居左
    [mainData appendData:str11ArrData];//末尾位置
    [mainData appendData:str11Data];//总价
    //    折扣
    [mainData appendData:data6];//居左
    [mainData appendData:killData];//居左
    [mainData appendData:str12ArrData];//末尾位置
    [mainData appendData:str12Data];//折扣
    
    //    实付
    [mainData appendData:data6];//居左
    [mainData appendData:asPayData];//居左
    [mainData appendData:str13ArrData];//末尾位置
    [mainData appendData:str13Data];//实付
    [mainData appendData:data1];//换行
    [mainData appendData:data6];//居左
    [mainData appendData:xiantiao];//线条
    [mainData appendData:dianhuaData];//加盟商电话
    [mainData appendData:tousuData];//投诉电话
    [mainData appendData:data4];//居中
    [mainData appendData:finallyData];//欢迎光临
    [mainData appendData:data1];//换行
    [mainData appendData:data1];//换行
    [mainData appendData:data1];//换行
    valuePrint = NO;
    [self openNotify];
    [self sendDataWithString:nil andInfoData:mainData];//线条
    [self showResult];
}

//隐藏HUD
- (void)hideHUD {
    
    //    [LCProgressHUD hide];
}

//打开通知
-(void)openNotify
{
    if (_readChar!=nil&&_per!=nil) {
        [_per setNotifyValue:YES forCharacteristic:_readChar];
    }
}

//关闭通知
-(void)cancelNotify
{
    [_per setNotifyValue:NO forCharacteristic:_readChar];
    
}

//断开连接
-(void)cancelPeripheralWith:(CBPeripheral *)per
{
    [_manager cancelPeripheralConnection:_per];
    
}

@end
