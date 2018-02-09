//
//  DXHeadlineTool.h
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXHeadlineTool : NSObject

//发送异步请求，获取数据，字典转模型
+ (void)headlineWithSuccessBlock:(void(^)(NSArray *array))successBlock errorBlock:(void(^)(NSError *error))errorBlock;



@end
