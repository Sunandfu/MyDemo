//
//  LHSqlite.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHDBBlock.h"
typedef NS_ENUM(NSInteger,LHSqliteType) {
    LHSqliteTypeWrite,
    LHSqliteTypeRead
};
@interface LHSqlite : NSObject

@property (nonatomic,strong) NSString* sqlPath;

@property (nonatomic,strong) NSDateFormatter* dateFormatter;

- (instancetype)initWithPath:(NSString*)dbPath;

+ (instancetype)sqliteWithPath:(NSString*)dbPath;

+ (instancetype)shareInstance;

- (void)executeSQLWithSqlstring:(NSString*)sqlString object:(id)model executeType:(LHSqliteType)type success:(success)successBlock fail:(fail)failBlock;

@end
