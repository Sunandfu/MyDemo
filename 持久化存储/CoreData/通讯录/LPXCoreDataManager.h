//
//  LPXCoreDataManager.h
//  coreData练习
//
//  Created by 卢鹏肖 on 16/4/20.
//  Copyright © 2016年 卢鹏肖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LPXCoreDataManager : NSObject

/**
 *  管理上下文对象
 */
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;

/**
 *   管理模型对象
 */
@property(nonatomic,strong)NSManagedObjectModel *managerdObjectModel;

/**
 *  持久化存储调度器
 */
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistenStoreCoordinator;

/**
 *  单列对象
 */
+ (instancetype) sharedInstance;

/**
 *  保存上下文
 */
- (void) saveCpntent;

@end
