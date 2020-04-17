//
//  YXFeedAdData.h
//  LunchAd
//
//  Created by shuai on 2018/10/15.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXFeedAdData : NSObject
/**
 大图Url
 */
@property (nonatomic,copy) NSString *imageUrl;
/**
 图标Url
 */
@property (nonatomic,copy) NSString *IconUrl;
/**
 标题
 */
@property (nonatomic,copy) NSString *adTitle;
/**
 描述
 */
@property (nonatomic,copy) NSString *adContent;

@property (nonatomic,assign) NSInteger adID;

/**
 跳转url
 */
@property (nonatomic,copy) NSString *clickedUrl;

/**
 创意按钮显示文字
 */
@property (nonatomic, copy) NSString *buttonText;


@end
