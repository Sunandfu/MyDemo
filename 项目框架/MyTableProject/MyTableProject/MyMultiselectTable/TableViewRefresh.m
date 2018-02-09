//
//  TableViewRefresh.m
//
//  Created by 史岁富 on 15/11/18.
//  Copyright © 2015年 史岁富. All rights reserved.
//

#import "TableViewRefresh.h"

@implementation TableViewRefresh

- (TableViewRefresh *)initWithCount:(int)count{
    self.tableViewsDataArray = [[NSMutableArray alloc]init];
    self.pageNumberArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<count; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [self.tableViewsDataArray addObject:arr];
        NSNumber *page = @1;
        [self.pageNumberArray addObject:page];
    }
    return self;
}
- (void)addPageNumberWithIndex:(int)index{
    int  page = [self.pageNumberArray[index] intValue];
        page++;
    [self.pageNumberArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:page]];
}
- (void)subPageNumberWithIndex:(int)index{
    int  page = [self.pageNumberArray[index] intValue];
    if (page>1) {
        page--;
    }
    [self.pageNumberArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:page]];
}
- (void)resetPageNumberWithIndex:(int)index{
    [self.pageNumberArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
}
- (void)setDataWithData:(NSMutableArray *)data Index:(int)index {
    int page = [self.pageNumberArray[index] intValue];
    NSMutableArray *arr = self.tableViewsDataArray[index];
    if (page == 1) {
        [arr removeAllObjects];
    }
    [arr addObjectsFromArray:data];
    [self.tableViewsDataArray  replaceObjectAtIndex:index withObject:arr];
}
@end
