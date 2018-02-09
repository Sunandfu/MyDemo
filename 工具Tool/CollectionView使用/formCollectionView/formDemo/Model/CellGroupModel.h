//
//  CellGroupModel.h
//  formDemo
//
//  Created by qinyulun on 16/4/15.
//  Copyright © 2016年 leTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellGroupModel : NSObject

@property (nonatomic,copy)   NSString *headerImg;
@property (nonatomic,copy)   NSString *headerTitle;
@property (nonatomic,strong) NSArray *titleList;

- (instancetype)initCellDataWithDic:(NSDictionary *)dic;

+ (instancetype)cellDataWithDic:(NSDictionary *)dic;

@end
