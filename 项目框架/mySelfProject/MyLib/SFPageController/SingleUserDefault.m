//
//  SingleUserDefault.m
//  HBGuard
//
//  Created by 王振兴 on 15/11/22.
//  Copyright © 2015年 YunXiang. All rights reserved.
//

#import "SingleUserDefault.h"


@implementation SingleUserDefault

//NSString * const selectedSectionTitles_key = @"selectedSectionTitles_key";
//NSString * const noSelectedSectionTitles_key = @"noSelectedSectionTitles_key";

static SingleUserDefault * sharedSingleUserDefault;
+(SingleUserDefault *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleUserDefault = [[SingleUserDefault alloc] init];
    });
    return sharedSingleUserDefault;
}

//#pragma mark - 频道属性
//
///// 默认频道
//- (NSMutableArray *)defaultChanels {
//    
//    if (_defaultChanels == nil) {
//        _defaultChanels = [[NSMutableArray alloc]initWithObjects:@"推荐",@"热门",@"三七", nil];
//    }
//    return _defaultChanels;
//}
//
///// 已添加
//- (void)setSelectedSectionTitles:(NSMutableArray *)selectedSectionTitles {
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[self arrayToJson:selectedSectionTitles] forKey:selectedSectionTitles_key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (NSMutableArray *)selectedSectionTitles {
//    
//    NSString *section_titles_string;
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:selectedSectionTitles_key]) {
//        [self setSelectedSectionTitles:self.defaultChanels];
//    }
//    section_titles_string = [[NSUserDefaults standardUserDefaults] objectForKey:selectedSectionTitles_key];
//    
//    return [self arrayWithJsonString:section_titles_string];
//
//}
//
///// 未添加
//- (void)setNoSelectedSectionTitles:(NSMutableArray *)noSelectedSectionTitles {
//    [[NSUserDefaults standardUserDefaults] setObject:[self arrayToJson:noSelectedSectionTitles] forKey:noSelectedSectionTitles_key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (NSMutableArray *)noSelectedSectionTitles {
//    NSString *section_titles_string;
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:noSelectedSectionTitles_key]){
//        [self setNoSelectedSectionTitles:[[NSMutableArray alloc] initWithObjects:@"心胀病",@"高血压",@"脂肪肝",@"糖尿病",@"高血脂",@"脑卒中",@"脑栓塞",@"心肌炎",@"心律失常",@"心肌梗塞",@"心力衰竭",@"动脉硬化",@"冠心病",@"心绞痛",@"中医",@"抗癌",@"亚健康",@"两性",@"育儿",@"劲椎",@"感冒", nil]];
//    }
//    section_titles_string = [[NSUserDefaults standardUserDefaults] objectForKey:noSelectedSectionTitles_key];
//    
//    return [self arrayWithJsonString:section_titles_string];
//    
//}
//
//
//#pragma mark - json 操作
//
//- (NSString*)arrayToJson:(NSMutableArray *)array
//{
//    NSError *parseError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
//    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//}
//
//- (NSMutableArray *)arrayWithJsonString:(NSString *)jsonString {
//    if (jsonString == nil) {
//        return nil;
//    }
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
//                         
//                                                        options:NSJSONReadingMutableContainers
//                         
//                                                          error:&err];
//    
//    if(err) {
//        NSLog(@"json解析失败：%@",err);
//        return nil;
//    }
//    return array;
//}


@end
