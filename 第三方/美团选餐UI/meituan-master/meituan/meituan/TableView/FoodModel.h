//
//  FoodModel.h
//  meituan
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *foodId;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, assign) NSInteger praise_content;
@property (nonatomic, assign) NSInteger month_saled;
@property (nonatomic, assign) float min_price;

@end
