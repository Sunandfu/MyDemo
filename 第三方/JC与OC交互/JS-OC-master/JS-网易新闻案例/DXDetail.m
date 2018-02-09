//
//  DXDetail.m
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import "DXDetail.h"
#import "DXDetailImg.h"
#import "MJExtension.h"

@implementation DXDetail
+ (NSDictionary *)objectClassInArray {

    return @{@"img" : [DXDetailImg class]};
    
}

@end
