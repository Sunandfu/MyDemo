//
//  DWModel.h
//  DWMenu
//
//  Created by Dwang on 16/4/26.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWModel : NSObject

@property (copy, nonatomic) NSString *text;

- (instancetype) initWithDict:(NSDictionary *)dict;
+ (instancetype) leftMenuWithDict:(NSDictionary *)dict;

+ (NSArray *) menuModel;


@end
