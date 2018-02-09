//
//  BlueToothManager.h
//  BluetoothPrint
//
//  Created by Tgs on 16/3/7.
//  Copyright © 2016年 Tgs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager * _manager;
    CBPeripheral * _per;
    CBCharacteristic * _char;
    CBCharacteristic * _readChar;
    
    NSMutableArray * _peripheralList;
    NSData * _responseData;
    void (^conReturnBlock)(CBCentralManager *central ,CBPeripheral *peripheral,NSString *stateStr);
    void (^printSuccess)(BOOL sizeValue);
    void (^bluetoothListArr)(NSMutableArray *blueToothArray);
    BOOL valuePrint;
}

/**
 *  创建BlueToothManager单例
 *
 *  @return BlueToothManager单例
 */
+(instancetype)getInstance;

/**
 *  开始扫描
 */
- (void)startScan;

/**
 *  停止扫描
 */
-(void)stopScan;

/**
 *  获得设备列表
 *
 *  @return 设备列表
 */
-(NSMutableArray *)getNameList;

/**
 *  连接设备
 *
 *  @param per 选择的设备
 */
-(void)connectPeripheralWith:(CBPeripheral *)per;

/**
 *  打开通知
 */
-(void)openNotify;

/**
 *  关闭停止
 */
-(void)cancelNotify;

/**
 *  发送信息给蓝牙
 *
 *  @param str 遵循通信协议的设定
 */
- (void)sendDataWithString:(NSString *)str andInfoData:(NSData *)infoData;

/**
 *  展示蓝牙返回的结果
 */
-(void)showResult;

/**
 *  断开连接
 *
 *  @param per 连接的per
 */
-(void)cancelPeripheralWith:(CBPeripheral *)per;
/**
 * 连接蓝牙状态信息回调
 * @param stateStr: 连接成功--SUCCESS，连接失败--ERROR，断开连接--DISCONNECT,无蓝牙信息--BLUEDISS
 **/
-(void)connectInfoReturn:(void(^)(CBCentralManager *central ,CBPeripheral *peripheral ,NSString *stateStr))myBlock;
/**
 * 打印字典信息
 @param stateStr:typeNum 1-本地商品打印，本地服务--0 ，易商城--2
 **/
-(void)getBluetoothPrintWith:(NSDictionary *)dictionary andPrintType:(NSInteger)typeNum;
-(void)getPrintSuccessReturn:(void(^)(BOOL sizeValue))printBlock;
-(void)getBlueListArray:(void (^)(NSMutableArray *blueToothArray))listBlock;
@end
