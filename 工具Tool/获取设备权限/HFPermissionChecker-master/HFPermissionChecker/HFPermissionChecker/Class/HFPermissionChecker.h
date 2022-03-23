//
//  HFPermissionChecker.h
//  HFPermissionChecker
//
//  Created by hui hong on 2019/1/24.
//  Copyright © 2019 hui hong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, HFPermissionCheckerType) {
    HFPermissionCheckerTypeNone                 = 1 << 0,
    // 通知
    HFPermissionCheckerTypeNotification         = 1 << 1,
    // 定位
    HFPermissionCheckerTypeLocation             = 1 << 2,
    // 麦克风
    HFPermissionCheckerTypeMicrophone           = 1 << 3,
    // 相机
    HFPermissionCheckerTypeCamera               = 1 << 4,
    // 相册
    HFPermissionCheckerTypePhoto                = 1 << 5,
    // 通讯录
    HFPermissionCheckerTypeContacts             = 1 << 6,
    // 日历
    HFPermissionCheckerTypeCalendar             = 1 << 7,
    // 提醒事项
    HFPermissionCheckerTypeReminder             = 1 << 8
};

typedef NS_ENUM(NSInteger, HFPermissionStatus)
{
    HFPermissionStatusNone = -1,
    // 受限
    HFPermissionStatusRestricted,
    // 拒绝
    HFPermissionStatusDenied,
    // 授权
    HFPermissionStatusAuthorized
};

typedef void(^HFPermissionCheckerCompleteBlock) (BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType);

@interface HFPermissionChecker : NSObject

+ (void)permissionChecker:(HFPermissionCheckerType)permissionType
            completeBlock:(HFPermissionCheckerCompleteBlock)completeBlock;

@end

