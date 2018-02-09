//
//  ListModel.h
//  HRVApp201601
//
//  Created by 小富 on 16/4/12.
//  Copyright © 2016年 betterlife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic, copy) NSString *checktime;
@property (nonatomic, copy) NSString *ecgPath;
@property (nonatomic, copy) NSString *osVersion;
@property (nonatomic, copy) NSString *userId;

- (void)dictionary:(NSDictionary *)dic;

@end
