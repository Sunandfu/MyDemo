//
//  CocoaGroup.h
//  CocoaPicker
//
//  Created by Cocoa Lee on 15/8/26.
//  Copyright (c) 2015年 Cocoa Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#define COLORSELECT [UIColor colorWithRed:0.39f green:0.80f blue:0.70f alpha:1.00f]

@interface CocoaGroup : NSObject
@property(nonatomic,strong)NSArray *imageArray;
+(instancetype) CocoaShareInstance ;

@end
