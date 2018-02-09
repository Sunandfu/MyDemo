//
//  CellModel.h
//  formDemo
//
//  Created by qinyulun on 16/4/15.
//  Copyright © 2016年 leTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property (nonatomic, copy) NSString *title;

- (instancetype)initCellDataWithDic:(NSDictionary *)dic;

+ (instancetype)cellDataWithDic:(NSDictionary *)dic;

@end
