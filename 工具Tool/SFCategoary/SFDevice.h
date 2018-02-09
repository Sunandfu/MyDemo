//
//  SFDevice.h
//  wuxiangundongview
//
//  Created by 小富 on 16/4/20.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFDevice : NSObject

+ (NSString *)Device_CurrentLanguage;//手机所使用语言
+ (NSString *)Device_Model;//手机类型
+ (NSString *)Device_UUID;//
+ (NSString *)Device_LocalHost;//路由器IP地址
+ (NSString *)Device_MachineModel;//系统版本
+ (NSString *)Device_MachineModelName;//手机类型
+ (NSString *)Device_SystemUptime;//以运行时间
+ (NSString *)Device_MacAddress;//
+ (NSString *)Device_IpAddressWIFI;//
+ (NSString *)Device_IpAddressCell;//

+ (unsigned long)Device_DiskSpace;//手机内置总硬盘大小
+ (unsigned long)Device_DiskSpaceFree;//剩余存储大小
+ (unsigned long)Device_DiskSpaceUsed;//已使用存储大小
+ (unsigned long)Device_MemoryTotal;//手机内存大小
+ (unsigned long)Device_MemoryUsed;//已占用内存大小
+ (unsigned long)Device_MemoryFree;//剩余内存大小
+ (unsigned long)Device_MemoryActive;//正在使用内存大小
+ (unsigned long)Device_MemoryInactive;//空闲内存大小
+ (unsigned long)Device_MemoryWired;//有线的
+ (unsigned long)Device_MemoryPurgable;//未知

+ (NSUInteger)Device_CpuCount;//
+ (NSArray *)Device_CpuUsagePerProcessor;//
+ (float)Device_CpuUsage;//
+ (NSString *)Device_SystemVersion;//系统版本号

+ (BOOL)canMakePhoneCalls;//是否可以打电话
+ (BOOL)isiTV NS_ENUM_AVAILABLE_IOS(9_0);
+ (BOOL)isiPad NS_ENUM_AVAILABLE_IOS(3_2);
+ (BOOL)isiPhone NS_ENUM_AVAILABLE_IOS(3_2);
+ (BOOL)isRtina NS_ENUM_AVAILABLE_IOS(4_0);
+ (BOOL)isRequiresPhoneOS;//是否是手机
+ (BOOL)isScreenSizeEqualToSize:(CGSize)size;//

+ (NSString *)APP_Version;//
+ (NSString *)APP_BuildVersion;//
+ (NSString *)APP_BundleName;//
+ (NSString *)APP_Identifier;//
+ (NSString *)APP_BundleSeedID;//
+ (NSString *)APP_SchemaWithName:(NSString *)name;//
+ (NSString *)APP_Schema;//
+ (NSURL *)APP_DocumentsURL;//
+ (NSString *)APP_DocumentsPath;//
+ (NSURL *)APP_CachesURL;//
+ (NSString *)APP_CachesPath;//
+ (NSURL *)APP_LibraryURL;//
+ (NSString *)APP_LibraryPath;//
+ (unsigned long)APP_MemoryUsage;//
+ (float)APP_CpuUsage;//

@end
