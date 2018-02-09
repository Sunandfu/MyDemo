//
//  DXDetailImg.m
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import "DXDetailImg.h"

@implementation DXDetailImg

+ (instancetype)detailImgWithDict:(NSDictionary *)dict {

    DXDetailImg *img = [[self alloc] init];
    
    [img setValuesForKeysWithDictionary:dict];
    
    return img;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
