//
//  DXHeadlineTool.m
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import "DXHeadlineTool.h"
#import "DXHTTPManager.h"
#import "DXHeadline.h"
#import "MJExtension.h"

@implementation DXHeadlineTool

// 发送异步请求,加载数据, 字典转模型
+ (void)headlineWithSuccessBlock:(void (^)(NSArray *))successBlock errorBlock:(void (^)(NSError *))errorBlock {
    
    
    NSString *urlString = @"http://c.m.163.com/nc/article/headline/T1348647853363/0-140.html";
    // 使用自定义的manager发送请求
    [[DXHTTPManager manager] GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //        NSLog(@"%@", responseObject);
        /**
         *  将上面的 id  _Nonnull 类型改为NSDictionary *,因为我们通过分析服务器返回的json数据,就是一个一个的数组
         *  而且数组有一个写入的方法writeToFile:, 可以将这些数据存起来
         */
        [responseObject writeToFile:@"/Users/xiongdexi/Desktop/Data/wangyi.plist" atomically:YES];
        
        
        // 新闻字典数组
        NSArray *dictArray = responseObject[@"T1348647853363"];
        NSMutableArray *mArray = [NSMutableArray array];
        [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //        DXHeadline *model = [self headlineWithDcit:obj];
//            DXHeadline *model = [DXHeadline headlineWithDcit:obj];
            DXHeadline *model = [DXHeadline objectWithKeyValues:obj];
            
            [mArray addObject:model];
        }];
        // 成功的回调
        if (successBlock) {
            successBlock(mArray.copy);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@", error);
        // 错误的回调
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}


@end
