//
//  NSManagedObject+LPXObject.m
//  通讯录
//
//  Created by 卢鹏肖 on 16/4/21.
//  Copyright © 2016年 卢鹏肖. All rights reserved.
//

#import "NSManagedObject+LPXObject.h"
#import "LPXCoreDataManager.h"

@implementation NSManagedObject (LPXObject)

/**
 *  获得实体名
 */
+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

/**
 *  快速创建可管理的对象
 *
 *  @param managedObjectContext 知道管理对象
 */
+ (instancetype)instanceNewObjectWithContext:(NSManagedObjectContext *)managedObjectContext {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:managedObjectContext];
}

/**
 *  快速创建管理对象
 */
+ (instancetype)instanceObject {
    return [self instanceNewObjectWithContext:[LPXCoreDataManager sharedInstance].managedObjectContext];
}

/**
 *  保存
 */
- (void)save {
    [[LPXCoreDataManager sharedInstance] saveCpntent];
}

@end
