//
//  RaTreeModel.m
//  RATreeDemo
//
//  Created by l2cplat on 16/5/25.
//  Copyright © 2016年 zhukaiqi. All rights reserved.
//

#import "RaTreeModel.h"

@implementation RaTreeModel

- (id)initWithName:(NSString *)name children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children
{
    return [[self alloc] initWithName:name children:children];
}
@end
