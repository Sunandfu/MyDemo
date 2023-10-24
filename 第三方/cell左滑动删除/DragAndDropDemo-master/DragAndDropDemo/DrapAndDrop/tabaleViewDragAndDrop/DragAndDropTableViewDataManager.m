//
//  DragAndDropTableViewDataManager.m
//  CardScrlDemo
//
//  Created by lotus on 2019/12/31.
//  Copyright © 2019 lotus. All rights reserved.
//

#import "DragAndDropTableViewDataManager.h"
#import <UIKit/UIKit.h>

@interface DragAndDropTableViewDataManager ()
@property (nonatomic, strong) NSMutableArray <NSString *>* listData;
@end
@implementation DragAndDropTableViewDataManager


- (void)setupDataSource
{
    self.listData = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        NSString *str = [NSString stringWithFormat:@"cell--%ld", i];
        [self.listData addObject:str];
    }
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}
- (NSString *)cellDataForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.listData.count) {
        return self.listData[indexPath.row];
    }

    return nil;
}

- (void)moveFromIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (sourceIndexPath.row == toIndexPath.row) return;

    NSString *object = [self  cellDataForIndexPath:sourceIndexPath];
    if (!object) return;

    [self.listData removeObjectAtIndex:sourceIndexPath.row];
    [self.listData insertObject:object atIndex:toIndexPath.row];
}
- (void)addData:(NSString *)data ForIndexPath:(NSIndexPath *)indexPath;
{
    if (data == nil) {
        return;
    }
    [self.listData insertObject:data atIndex:indexPath.row];
}
@end


