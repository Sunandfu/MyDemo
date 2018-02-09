//
//  NetRequestManager.h
//  HBGuard
//
//  Created by 小富 on 16/3/29.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//网络请求成功回调
typedef void(^SuccessCallBack)(AFHTTPRequestOperation *operation,id reponseObject);
//网络请求失败的回调
typedef void(^FailedCallBack)(AFHTTPRequestOperation *operation,NSError *error);

//传输图片二进制流
typedef void (^constructingBodyBlock)(id<AFMultipartFormData>formData);

@interface NetRequestManager : NSObject
{
    AFHTTPRequestOperationManager *_manager;
}
//请求时间  （必须设置）
@property (nonatomic, assign) double requestTime;
//初始化网络请求控制器
+(NetRequestManager *)manager;
//GET请求
+(void)GET:(NSString *)url parame:(NSDictionary *)dict Success:(SuccessCallBack)success failed:(FailedCallBack)failed;
//POST请求
+(void)POST:(NSString *)url parame:(NSDictionary *)dict Success:(SuccessCallBack)success failed:(FailedCallBack)failed;


//POST 上传


//POST上传图片的请求
+(void)POST:(NSString *)url parame:(NSDictionary *)dict constructingBodyWithBlock:(constructingBodyBlock)constructBody Success:(SuccessCallBack)success failed:(FailedCallBack)failed;

/*  网络设置
 NSAppTransportSecurity
 下添加NSAllowsArbitraryLoads类型 YES
 
 [NetRequestManager manager].requestTime = 10.0f;
 
 [NetRequestManager GET:@"http://www.google.com.hk" parame:nil SUccess:^(AFHTTPRequestOperation *operation, id reponseObject) {
 [SVProgressHUD showSuccessWithStatus:@"成功"];
 } failed:^(AFHTTPRequestOperation *operation, NSError *error) {
 [SVProgressHUD showErrorWithStatus:@"失败"];
 }];
 */

@end
