//
//  DXDetailTool.m
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import "DXDetailTool.h"
#import "DXHTTPManager.h"
#import "DXDetail.h"
#import "MJExtension.h"

@implementation DXDetailTool

//发送异步请求，获取数据，字典转模型
+ (void)detailWithDicid:(NSString *)docid successBlock:(void(^)(DXDetail *tetail))successBlock errorBlock:(void(^)(NSError *error))errorBlock {
    
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", docid];
    
    [[DXHTTPManager manager] GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        [responseObject writeToFile:@"/Users/xiongdexi/Desktop/Data/newsDetail.plist" atomically:YES];

        NSDictionary *dict = responseObject[docid];
        DXDetail *tetail = [DXDetail objectWithKeyValues:dict];
        // 成功的回调
        if (successBlock) {
            successBlock(tetail);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"加载出错, %@", error);
        if (errorBlock) {
            errorBlock(error);
        }
    }];

}


@end
