//
//  ListModel.m
//  HRVApp201601
//
//  Created by 小富 on 16/4/12.
//  Copyright © 2016年 betterlife. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

- (void)dictionary:(NSDictionary *)dic{
    self.checktime = dic[@"checktime"];
    self.ecgPath = dic[@"ecgPath"];
    self.osVersion = dic[@"osVersion"];
    self.userId = dic[@"userId"];
}

@end
