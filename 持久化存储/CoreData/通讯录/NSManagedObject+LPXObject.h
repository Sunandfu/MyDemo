//
//  NSManagedObject+LPXObject.h
//  通讯录
//
//  Created by 卢鹏肖 on 16/4/21.
//  Copyright © 2016年 卢鹏肖. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (LPXObject)

/**
 *  获得实体名
 */
+ (NSString *) entityName;

/**
 *  获得一个单列对象
 */
+ (instancetype) instanceObject;

/**
 *  快速创建可管理的对象
 *
 *  @param managedObjectContext 知道管理对象
 */
+ (instancetype) instanceNewObjectWithContext:(NSManagedObjectContext *) managedObjectContext;

/**
 *  快速保存
 */
- (void) save;

@end
