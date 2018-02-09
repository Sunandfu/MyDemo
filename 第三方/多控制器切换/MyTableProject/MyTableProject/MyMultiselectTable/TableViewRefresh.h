//
//  TableViewRefresh.h
//
//  Created by 史岁富 on 15/11/18.
//  Copyright © 2015年 史岁富. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewRefresh : NSObject

@property (nonatomic,strong) NSMutableArray *tableViewsDataArray;

@property (nonatomic,strong) NSMutableArray *pageNumberArray;

- (TableViewRefresh *)initWithCount:(int)count;

- (void)addPageNumberWithIndex:(int)index;

- (void)subPageNumberWithIndex:(int)index;

- (void)resetPageNumberWithIndex:(int)index;

- (void)setDataWithData:(NSMutableArray *)data Index:(int)index;

@end
