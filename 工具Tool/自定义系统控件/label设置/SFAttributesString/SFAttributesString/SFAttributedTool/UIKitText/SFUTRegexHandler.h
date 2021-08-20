//
//  SFUTRegexHandler.h
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SFUIKitAttributesDefines.h"
@class SFUTRegexRecorder;

NS_ASSUME_NONNULL_BEGIN
@interface SFUTRegexHandler : NSObject<SFUTRegexHandlerProtocol>
- (instancetype)initWithRegex:(NSString *)regex;
@property (nonatomic, strong, readonly) SFUTRegexRecorder *recorder;
@end

@interface SFUTRegexRecorder : NSObject
@property (nonatomic) NSRegularExpressionOptions regularExpressionOptions;
@property (nonatomic) NSMatchingOptions matchingOptions;
@property (nonatomic, strong, nullable) id<SFUTAttributesProtocol> utOfReplaceWithString;
@property (nonatomic, copy, nullable) NSString *regex;
@property (nonatomic, copy, nullable) void(^replaceWithText)(id<SFUIKitTextMakerProtocol> make);
@property (nonatomic, copy, nullable) void(^update)(id<SFUTAttributesProtocol> make);
@property (nonatomic, copy, nullable) void(^handler)(NSMutableAttributedString *attrStr, NSTextCheckingResult *result);
@end
NS_ASSUME_NONNULL_END
