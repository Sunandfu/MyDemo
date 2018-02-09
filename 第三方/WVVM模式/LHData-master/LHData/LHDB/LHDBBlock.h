//
//  LHDBBlock.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#ifndef LHDBBlock_h
#define LHDBBlock_h

typedef void(^success)(NSArray* result);

typedef void(^fail)(NSError* error);

typedef void(^callback)(void);

typedef void(^integerBlock)(NSInteger parameter);

#endif /* LHDBBlock_h */
