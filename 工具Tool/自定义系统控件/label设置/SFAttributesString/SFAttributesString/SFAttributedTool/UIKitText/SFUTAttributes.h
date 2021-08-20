//
//  SFUTAttributes.h
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFUIKitAttributesDefines.h"
#import "SFUTRecorder.h"

NS_ASSUME_NONNULL_BEGIN
@interface SFUTAttributes : NSObject<SFUTAttributesProtocol>
@property (nonatomic, strong, readonly) SFUTRecorder *recorder;
@end
NS_ASSUME_NONNULL_END
