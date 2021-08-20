//
//  SFUTRangeHandler.h
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/13.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SFUIKitAttributesDefines.h"
@class SFUTRangeRecorder;

NS_ASSUME_NONNULL_BEGIN
@interface SFUTRangeHandler : NSObject<SFUTRangeHandlerProtocol>
- (instancetype)initWithRange:(NSRange)range;
@property (nonatomic, strong, readonly) SFUTRangeRecorder *recorder;
@end

@interface SFUTRangeRecorder : NSObject
@property (nonatomic) NSRange range;
@property (nonatomic, strong, nullable) id<SFUTAttributesProtocol> utOfReplaceWithString;
@property (nonatomic, copy, nullable) void(^replaceWithText)(id<SFUIKitTextMakerProtocol> make);
@property (nonatomic, copy, nullable) void(^update)(id<SFUTAttributesProtocol> make);
@end
NS_ASSUME_NONNULL_END
