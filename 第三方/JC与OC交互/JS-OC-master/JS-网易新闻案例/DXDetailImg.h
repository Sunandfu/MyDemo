//
//  DXDetailImg.h
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXDetailImg : NSObject
/** 图片的尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片的描述(所处的位置) */
@property (nonatomic, copy) NSString *ref;
/** 图片的url地址 */
@property (nonatomic, copy) NSString *src;

+ (instancetype)detailImgWithDict:(NSDictionary *)dict;


@end
