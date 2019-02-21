//
//  WMDExampleDefine.h
//  WMDemo
//
//  Created by carl on 2017/12/4.
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WMDExampleViewControl <NSObject>
@end

@protocol WMDExampleViewModel <NSObject>
@property (nonatomic, copy) NSString *slotID;
@end
