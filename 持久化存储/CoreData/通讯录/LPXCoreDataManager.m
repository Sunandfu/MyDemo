//
//  LPXCoreDataManager.m
//  coreData练习
//
//  Created by 卢鹏肖 on 16/4/20.
//  Copyright © 2016年 卢鹏肖. All rights reserved.
//

#import "LPXCoreDataManager.h"

@implementation LPXCoreDataManager

/**
 *   单列
 */
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 *  保存
 */
- (void)saveCpntent {
    [self.managedObjectContext save:nil];
}

/**
 *  快速获取路径的ulr
 */
- (NSURL *) applicationDocumentURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 *  管理上下文对象
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        //指定调度器
        _managedObjectContext.persistentStoreCoordinator = self.persistenStoreCoordinator;
    }
    return _managedObjectContext;
}

/**
 *  管理模型的对象
 */
- (NSManagedObjectModel *)managerdObjectModel {
    if (_managerdObjectModel == nil) {
        // 快速获取url
//        _managerdObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self applicationDocumentURL]];
        // 从bundle路径合并描述文件
        _managerdObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
    }
    return _managerdObjectModel;
}

/**
 *  持久化存储调度器
 */
- (NSPersistentStoreCoordinator *)persistenStoreCoordinator {
    if (_persistenStoreCoordinator == nil) {
        _persistenStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managerdObjectModel]];
        NSURL *url = [[self applicationDocumentURL] URLByAppendingPathComponent:@"myData.db"];
        [_persistenStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url  options:nil error:nil];
    }
    return _persistenStoreCoordinator;
}




@end
