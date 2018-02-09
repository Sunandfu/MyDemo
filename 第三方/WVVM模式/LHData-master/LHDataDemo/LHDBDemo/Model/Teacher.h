//
//  Teacher.h
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/7.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teacher : NSObject

@property (nonatomic,strong) NSString* name;

@property (nonatomic,strong) NSString* imageUrl;

@property NSInteger age;

@property (nonatomic,strong) NSNumber* height;

@property char c;

@property (nonatomic,strong) NSArray* studentName;

@property (nonatomic,strong) NSDictionary* studentInfo;



@end
