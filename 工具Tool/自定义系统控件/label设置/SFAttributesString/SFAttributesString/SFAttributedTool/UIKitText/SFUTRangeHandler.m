//
//  SFUTRangeHandler.m
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/13.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SFUTRangeHandler.h"
#import "SFUTAttributes.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SFUTRangeHandler
- (instancetype)initWithRange:(NSRange)range {
    self = [super init];
    if ( !self ) return nil;
    _recorder = [[SFUTRangeRecorder alloc] init];
    _recorder.range = range;
    return self;
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
@end

@implementation SFUTRangeRecorder
@end
NS_ASSUME_NONNULL_END
