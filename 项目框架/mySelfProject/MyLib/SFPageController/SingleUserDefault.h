//
//  SingleUserDefault.h
//  HBGuard
//
//  Created by 王振兴 on 15/11/22.
//  Copyright © 2015年 YunXiang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SingleUserDefault : NSObject
//@property (nonatomic,strong)NSArray *singleArry;
///已添加频道
@property (nonatomic,strong)NSMutableArray * selectedSectionTitles;
///未添加频道
//@property (nonatomic,strong)NSMutableArray * noSelectedSectionTitles;
///默认频道
//@property (nonatomic,strong) NSMutableArray *defaultChanels;
///单例模式
+ (SingleUserDefault *) sharedInstance;


@end
