#import <Foundation/Foundation.h>

@class QNResponseInfo;

typedef void (^QNInternalProgressBlock)(long long totalBytesWritten, long long totalBytesExpectedToWrite);
typedef void (^QNCompleteBlock)(QNResponseInfo *info, NSDictionary *resp);
typedef BOOL (^QNCancelBlock)(void);

/**
 *    Http 客户端接口
 */
@protocol QNHttpDelegate <NSObject>

- (void)multipartPost:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
         withFileName:(NSString *)key
         withMimeType:(NSString *)mime
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock;

- (void)         post:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
          withHeaders:(NSDictionary *)headers
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com