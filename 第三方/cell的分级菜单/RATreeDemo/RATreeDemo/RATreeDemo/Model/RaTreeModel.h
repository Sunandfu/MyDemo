//
//  RaTreeModel.h
//  RATreeDemo
//
//  Created by l2cplat on 16/5/25.
//  Copyright © 2016年 zhukaiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaTreeModel : NSObject

@property (nonatomic,copy) NSString *name;//标题

@property (nonatomic,strong) NSArray *children;//子节点数组


//初始化一个model
- (id)initWithName:(NSString *)name children:(NSArray *)array;

//遍历构造器
+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

@end
