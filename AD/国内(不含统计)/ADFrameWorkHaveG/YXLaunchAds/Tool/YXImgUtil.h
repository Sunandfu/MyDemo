//
//  YXImgUtil.h
//  WalkerDSP
//
//  Created by Luo on 15/12/14.
//  Copyright © 2015年 emaryjf. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^successBlock)(UIImage *img);
typedef void(^gifSuccessBlock)(NSData *data);
typedef void(^failBlock)(NSError *error);
typedef void (^savedSuccessBlock) (void);
typedef void (^savedFailBlock)(NSError *error);

@interface YXImgUtil : NSObject

+(void) saveImg:(NSString *)imgUrl savedSuccess:(savedSuccessBlock) sucBlock failBlock:(failBlock) failBlock ;

+(void) imgWithUrl:(NSString *) imgUrl successBlock:(successBlock) sucBlock failBlock:(failBlock) faiBlock;


+(void)imgWithUrlWithOutCache:(NSString *)imgUrl successBlock:(successBlock)sucBlock failBlock:(failBlock)faiBlock;

+(void) gifImgWithUrl:(NSString *) imgUrl successBlock:(gifSuccessBlock) sucBlock failBlock:(failBlock) faiBlock;


@end
