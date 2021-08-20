//
//  SFUTRegexHandler.m
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SFUTRegexHandler.h"
#import "SFUTAttributes.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SFUTRegexHandler
- (instancetype)initWithRegex:(NSString *)regex {
    self = [super init];
    if ( !self ) return nil;
    _recorder = [SFUTRegexRecorder new];
    _recorder.regex = regex;
    return self;
}

- (void (^)(void (^ _Nonnull)(NSMutableAttributedString *attrStr, NSTextCheckingResult * _Nonnull)))handler {
    return ^(void(^block)(NSMutableAttributedString *attrStr, NSTextCheckingResult *result)) {
        self.recorder.handler = block;
    };
}
- (void (^)(void (^ _Nonnull)(id<SFUIKitTextMakerProtocol> _Nonnull)))replaceWithText {
    return ^(void(^block)(id<SFUIKitTextMakerProtocol> make)) {
        self.recorder.replaceWithText = block;
    };
}
- (id<SFUTAttributesProtocol>  _Nonnull (^)(NSString * _Nonnull))replaceWithString {
    return ^id<SFUTAttributesProtocol>(NSString *string) {
        SFUTAttributes *attr = [SFUTAttributes new];
        attr.recorder->string = string;
        self.recorder.utOfReplaceWithString = attr;
        return attr;
    };
}
- (void (^)(void (^ _Nonnull)(id<SFUTAttributesProtocol> _Nonnull)))update {
    return ^(void(^block)(id<SFUTAttributesProtocol> make)) {
        self.recorder.update = block;
    };
}
- (id<SFUTRegexHandlerProtocol>  _Nonnull (^)(NSMatchingOptions))matchingOptions {
    return ^id<SFUTRegexHandlerProtocol>(NSMatchingOptions ops) {
        self.recorder.matchingOptions = ops;
        return self;
    };
}
- (id<SFUTRegexHandlerProtocol>  _Nonnull (^)(NSRegularExpressionOptions))regularExpressionOptions {
    return ^id<SFUTRegexHandlerProtocol>(NSRegularExpressionOptions ops) {
        self.recorder.regularExpressionOptions = ops;
        return self;
    };
}
@end

@implementation SFUTRegexRecorder
- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _matchingOptions = NSMatchingWithoutAnchoringBounds;
    return self;
}
@end
NS_ASSUME_NONNULL_END
