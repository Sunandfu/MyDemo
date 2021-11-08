//
//  SFImgUtil.h
//  WalkerDSP
//
//  Created by Luo on 15/12/14.
//  Copyright © 2015年 emaryjf. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SFImageTypeOther,
    SFImageTypeGif,
    SFImageTypePng,
    SFImageTypeJpeg,
} SFImageType;

typedef void(^successBlock)(UIImage *img,NSData *imgData,SFImageType type);
typedef void(^failBlock)(NSError *error);

typedef void (^savedSuccessBlock) (void);
typedef void (^savedFailBlock)(NSError *error);

@interface SFImgUtil : NSObject

+(void) saveImg:(NSString *)imgUrl savedSuccess:(savedSuccessBlock) sucBlock failBlock:(failBlock) failBlock ;

+(void) imgWithUrl:(NSString *) imgUrl successBlock:(successBlock) sucBlock failBlock:(failBlock) faiBlock;


@end
