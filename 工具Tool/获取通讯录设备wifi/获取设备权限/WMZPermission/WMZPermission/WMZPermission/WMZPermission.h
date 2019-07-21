//
//  WMZPermission.h
//  WMZPermission
//
//  Created by wmz on 2018/12/10.
//  Copyright © 2018年 wmz. All rights reserved.
//

#import <Foundation/Foundation.h>


//权限类型
typedef enum : NSUInteger{
    PermissionTypeCamera,           //相机权限
    PermissionTypeMic,              //麦克风权限
    PermissionTypePhoto,            //相册权限
    PermissionTypeLocationWhen,     //获取地理位置When
    PermissionTypeCalendar,         //日历
    PermissionTypeContacts,         //联系人
    PermissionTypeBlue,             //蓝牙
    PermissionTypeRemaine,          //提醒
    PermissionTypeHealth,           //健康
    PermissionTypeMediaLibrary      //多媒体
}PermissionType;

typedef void (^callBack) (BOOL granted, id  data);

NS_ASSUME_NONNULL_BEGIN

@interface WMZPermission : NSObject

/*
 * 提示
 */
@property(nonatomic,strong)NSString *tip;

/*
 * 单例
 */
+ (instancetype)shareInstance;

/*
 * 获取权限
 * @param  type       类型
 * @param  block      回调
 */
- (void)permissonType:(PermissionType)type withHandle:(callBack)block;


@end

NS_ASSUME_NONNULL_END
