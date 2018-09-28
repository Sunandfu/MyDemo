//
//  NetRequestManager.h
//  HBGuard
//
//  Created by 小富 on 16/3/29.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

typedef enum{
    
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
    
}MyNetworkStatus;

//网络请求成功回调
typedef void(^SuccessCallBack)(AFHTTPRequestOperation *operation,id reponseObject);
//网络请求失败的回调
typedef void(^FailedCallBack)(AFHTTPRequestOperation *operation,NSError *error);
//传输图片二进制流
typedef void (^constructingBodyBlock)(id<AFMultipartFormData>formData);

typedef void( ^ ResponseSuccess)(id response);
typedef void( ^ ResponseFail)(NSError *error);

typedef void( ^ UploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);

typedef void( ^ DownloadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);
/**
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask URLSessionTask;




@interface NetRequestManager : NSObject
{
    AFHTTPRequestOperationManager *_manager;
}

/**
 *  单例
 *
 *  @return
 */
+ (NetRequestManager *)sharedNetworking;

/**
 *  获取网络
 */
@property (nonatomic,assign)MyNetworkStatus networkStats;
@property (nonatomic,copy) NSString *name;//网络状态
//请求时间  （必须设置）
@property (nonatomic, assign) double requestTime;
/**
 *  开启网络监测
 */
+ (void)startMonitoring;

//GET请求
+(void)GET:(NSString *)url parame:(NSDictionary *)dict SUccess:(SuccessCallBack)success failed:(FailedCallBack)failed;
//POST请求
+(void)POST:(NSString *)url parame:(NSDictionary *)dict SUccess:(SuccessCallBack)success failed:(FailedCallBack)failed;
//POST 上传


//POST上传图片的请求
+(void)POST:(NSString *)url parame:(NSDictionary *)dict constructingBodyWithBlock:(constructingBodyBlock)constructBody SUccess:(SuccessCallBack)success failed:(FailedCallBack)failed;


/**
 *  下载文件方法
 *
 *  @param url           下载地址
 *  @param saveToPath    文件保存的路径,如果不传则保存到Documents目录下，以文件本来的名字命名
 *  @param progressBlock 下载进度回调
 *  @param success       下载完成
 *  @param fail          失败
 *  @return 返回请求任务对象，便于操作
 */
+ (URLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(DownloadProgress )progressBlock
                              success:(ResponseSuccess )success
                              failure:(ResponseFail )fail;
/*
 ******************************************
 ***************   GET请求   **************
 ******************************************
 
 [NetRequestManager sharedNetworking].requestTime = 30.f;
 [NetRequestManager GET:@"http://www.baidu.com" parame:nil SUccess:^(AFHTTPRequestOperation *operation, id reponseObject) {
 NSLog(@"成功");
 } failed:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"失败");
 }];
 
 ******************************************
 ***************   POST请求   **************
 ******************************************
 
 [NetRequestManager sharedNetworking].requestTime = 30.f;
 [NetRequestManager POST:@"http://www.baidu.com" parame:nil SUccess:^(AFHTTPRequestOperation *operation, id reponseObject) {
 NSLog(@"成功");
 } failed:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"失败");
 }];
 
 ******************************************
 ***************   上传示例   **************
 ******************************************
 
 [NetRequestManager sharedNetworking].requestTime = 30.f;
 currentImage = [UIImage imageNamed:@""];
 self.imageName=@"myImage";
 self.imageData = UIImageJPEGRepresentation(currentImage,0.5);
 // 获取沙盒目录
 self.filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
 // 将图片写入文件
 [self.imageData writeToFile:self.filePath atomically:NO];
 //将图片保存到disk
 UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil);
 
 AFHTTPRequestOperationManager *manager2 = [[AFHTTPRequestOperationManager alloc] init];
 manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
 //单张图片图片和文字的上传
 [manager2 POST:URL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 if (self.imageData!=nil) {   // 图片数据不为空才传递
 [formData appendPartWithFileData:self.imageData name:self.imageName fileName:self.filePath mimeType:@"png"];
 }
 
 } success:^(AFHTTPRequestOperation *operation, id responseObject) {

 NSLog(@"上传成功");
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"请求失败");
 }];
 
 ******************************************
 ***************   下载示例   **************
 ******************************************
 
 @property (nonatomic,strong)URLSessionTask *task;
 //开始下载
 - (IBAction)startDownload:(id)sender {
 
 NSString *path=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/image.jpg"]];
 _task = [NetRequestManager downloadWithUrl:@"http://www.aomy.com/attach/2012-09/1347583576vgC6.jpg" saveToPath:path progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
 //封装方法里已经回到主线程，所有这里不用再调主线程了
 NSString *jindu = [NSString stringWithFormat:@"进度==%.2f",1.0 * bytesProgress/totalBytesProgress];
 NSLog(@"---------%@",jindu);
 } success:^(id response) {
 NSLog(@"下载完成---------%@",response);
 } failure:^(NSError *error) {
 NSLog(@"下载失败---------");
 }];
 }
 
 //暂停
 - (IBAction)suspend:(id)sender {
 [_task suspend];
 }
 
 //继续
 - (IBAction)resume:(id)sender {
 [_task resume];
 }
 
 ******************************************
 *************   网络实时监测   *************
 ******************************************
 [NetRequestManager startMonitoring];
 [self aotuNetworkIsOpen];
 
 - (void)aotuNetworkIsOpen{
 [self performSelector:@selector(aotuNetworkIsOpen) withObject:nil afterDelay:1];
 NSLog(@"网络状态->%@",[NetRequestManager sharedNetworking].name);
 }
 */

@end
