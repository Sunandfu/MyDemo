//
//  QiniuAuthPolicy.h
//  QiniuSDK
//
//  Created by Qiniu Developers 2013
//

#import <Foundation/Foundation.h>

// NOTE: Generally speaking, this class is not required for client development.
// The token string should be retrieved from your biz server.

// Refer to the spec: http://docs.qiniu.com/api/put.html#uploadToken
@interface QiniuPutPolicy : NSObject

@property (retain, nonatomic) NSString *scope;
@property (retain, nonatomic) NSString *callbackUrl;
@property (retain, nonatomic) NSString *callbackBody;
@property (retain, nonatomic) NSString *returnUrl;
@property (retain, nonatomic) NSString *returnBody;
@property (retain, nonatomic) NSString *asyncOps;
@property (retain, nonatomic) NSString *endUser;
@property int expires;
/**
 *  修改 Mike
 */
@property (retain, nonatomic) NSString *persistentOps;
@property (retain, nonatomic) NSString *persistentPipeline;


// Make uptoken string.
- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com