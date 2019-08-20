//
//  ChuanshanjiaObject.h
//  TestAdA
//
//  Created by lurich on 2019/8/14.
//  Copyright © 2019 YX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChuanshanjiaObject : NSObject<BUNativeExpressAdViewDelegate>

@property (nonatomic, strong) BUNativeExpressAdManager *nativeExpressAdManager;

@end

NS_ASSUME_NONNULL_END
