//
//  DXDetail.h
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXDetail : NSObject

/** 新闻详情标题 */
@property (nonatomic, copy) NSString *title;
/** 新闻详情时间 */
@property (nonatomic, copy) NSString *ptime;
/** 新闻详情内容 */
@property (nonatomic, copy) NSString *body;

/** 新闻详情图片数组(希望这个数组中以后存放的都是新闻详情的配图模型 ,所以需要先做图片的模型,然后嵌套) */
@property (nonatomic, strong) NSArray *img;


@end
