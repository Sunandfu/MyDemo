//
//  SFUIKitTextMaker.m
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SFUIKitTextMaker.h"
#import "SFUTRegexHandler.h"
#import "SFUTRangeHandler.h"

NS_ASSUME_NONNULL_BEGIN
inline static BOOL _rangeContains(NSRange main, NSRange sub) {
    return (main.location <= sub.location) && (main.location + main.length >= sub.location + sub.length);
}

inline static NSRange _textRange(NSAttributedString *text) {
    return NSMakeRange(0, text.length);
}

@interface SFUIKitTextMaker ()
@property (nonatomic, strong, readonly) NSMutableArray<SFUTAttributes *> *uts;
@property (nonatomic, strong, readonly) NSMutableArray<SFUTAttributes *> *updates;
@property (nonatomic, strong, readonly) NSMutableArray<SFUTRegexHandler *> *regexs;
@property (nonatomic, strong, readonly) NSMutableArray<SFUTRangeHandler *> *ranges;
@end

@implementation SFUIKitTextMaker
@synthesize uts = _uts;
- (NSMutableArray<SFUTAttributes *> *)uts {
    if ( !_uts ) _uts = [NSMutableArray array];
    return _uts;
}
@synthesize updates = _updates;
- (NSMutableArray<SFUTAttributes *> *)updates {
    if ( !_updates ) _updates = [NSMutableArray array];
    return _updates;
}
@synthesize regexs = _regexs;
- (NSMutableArray<SFUTRegexHandler *> *)regexs {
    if ( !_regexs ) _regexs = [NSMutableArray array];
    return _regexs;
}
@synthesize ranges = _ranges;
- (NSMutableArray<SFUTRangeHandler *> *)ranges {
    if ( !_ranges ) _ranges = [NSMutableArray array];
    return _ranges;
}

- (id<SFUTAttributesProtocol>  _Nonnull (^)(NSString * _Nonnull))append {
    return ^id<SFUTAttributesProtocol>(NSString *str) {
        SFUTAttributes *ut = [SFUTAttributes new];
        ut.recorder->string = str;
        [self.uts addObject:ut];
        return ut;
    };
}
- (id<SFUTAttributesProtocol>  _Nonnull (^)(NSRange))update {
    return ^id<SFUTAttributesProtocol>(NSRange range) {
        SFUTAttributes *ut = [SFUTAttributes new];
        ut.recorder->range = range;
        [self.updates addObject:ut];
        return ut;
    };
}
- (id<SFUTAttributesProtocol>  _Nonnull (^)(void (^ _Nonnull)(id<SFUTImageAttachment> _Nonnull)))appendImage {
    return ^id<SFUTAttributesProtocol>(void(^block)(id<SFUTImageAttachment> make)) {
        SFUTAttributes *ut = [SFUTAttributes new];
        SFUTImageAttachment *attachment = [SFUTImageAttachment new];
        ut.recorder->attachment = attachment;
        block(attachment);
        [self.uts addObject:ut];
        return ut;
    };
}
- (id<SFUTAttributesProtocol>  _Nonnull (^)(NSAttributedString * _Nonnull))appendText {
    return ^id<SFUTAttributesProtocol>(NSAttributedString *attrStr) {
        SFUTAttributes *ut = [SFUTAttributes new];
        ut.recorder->attrStr = [attrStr mutableCopy];
        [self.uts addObject:ut];
        return ut;
    };
}
- (id<SFUTRegexHandlerProtocol>  _Nonnull (^)(NSString * _Nonnull))regex {
    return ^id<SFUTRegexHandlerProtocol>(NSString *regex) {
        SFUTRegexHandler *handler = [[SFUTRegexHandler alloc] initWithRegex:regex];
        [self.regexs addObject:handler];
        return handler;
    };
}
- (id<SFUTRangeHandlerProtocol>  _Nonnull (^)(NSRange))range {
    return ^id<SFUTRangeHandlerProtocol>(NSRange range) {
        SFUTRangeHandler *handler = [[SFUTRangeHandler alloc] initWithRange:range];
        [self.ranges addObject:handler];
        return handler;
    };
}
- (NSMutableAttributedString *)install {
    // default values
    SFUTRecorder *recorder = self.recorder;
    if ( recorder->font == nil ) recorder->font = [UIFont systemFontOfSize:14];
    if ( recorder->textColor == nil ) recorder->textColor = [UIColor blackColor];

    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    [self _appendUTAttributesToResultIfNeeded:result];
    [self _executeUpdateHandlersIfNeeded:result];
    [self _executeRangeHandlersIfNeeded:result];
    [self _executeUpdateHandlersIfNeeded:result];
    [self _executeRegexHandlersIfNeeded:result];
    [self _executeUpdateHandlersIfNeeded:result];
    return result;
}

- (void)_appendUTAttributesToResultIfNeeded:(NSMutableAttributedString *)result {
    if ( _uts ) {
        for ( SFUTAttributes *ut in _uts ) {
            id _Nullable current = [self _convertToUIKitTextForUTAttributes:ut];
            if ( current != nil ) {
                [result appendAttributedString:current];
            }
        }
        _uts = nil;
    }
}

- (NSMutableAttributedString *_Nullable)_convertToUIKitTextForUTAttributes:(SFUTAttributes *)attr {
    NSMutableAttributedString *_Nullable current = nil;
    SFUTRecorder *recorder = attr.recorder;
    if      ( recorder->string != nil ) {
        current = [[NSMutableAttributedString alloc] initWithString:recorder->string];
    }
    else if ( recorder->attachment != nil ) {
        SFUTVerticalAlignment alignment = recorder->attachment.alignment;
        UIImage *image = recorder->attachment.image;
        CGRect bounds = recorder->attachment.bounds;
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = recorder->attachment.image;
        attachment.bounds = [self _adjustVerticalOffsetOfImageAttachmentForBounds:bounds imageSize:image.size alignment:alignment commonFont:self.recorder->font];
        current = [NSAttributedString attributedStringWithAttachment:attachment].mutableCopy;
    }
    
    if      ( current != nil ) {
        [self _setCommonValuesForUTAttributesRecorderIfNeeded:recorder];
        id attributes = [self _convertToUIKitTextAttributesForUTAttributesRecorder:recorder];
        [current addAttributes:attributes range:_textRange(current)];
    }
    else if ( recorder->attrStr != nil ) {
        current = recorder->attrStr;
        // ignore common values
        // [self _setCommonValuesForUTAttributesRecorderIfNeeded:recorder];
        id attributes = [self _convertToUIKitTextAttributesForUTAttributesRecorder:recorder];
        [current addAttributes:attributes range:_textRange(current)];
    }
    
    return current;
}

- (void)_executeRangeHandlersIfNeeded:(NSMutableAttributedString *)result {
    if ( _ranges ) {
        for ( SFUTRangeHandler *handler in _ranges ) {
            SFUTRangeRecorder *recorder = handler.recorder;
            if ( _rangeContains(_textRange(result), recorder.range) ) {
                if      ( recorder.utOfReplaceWithString != nil ) {
                    [self _executeReplaceWithString:result ut:recorder.utOfReplaceWithString inRange:recorder.range];
                }
                else if ( recorder.replaceWithText != nil ) {
                    [self _executeReplaceWithText:result handler:recorder.replaceWithText inRange:recorder.range];
                }
                else if ( recorder.update != nil ) {
                    [self _appendUpdateHandlerToUpdates:recorder.update inRange:recorder.range];
                }
            }
        }
        _ranges = nil;
    }
}

- (void)_executeRegexHandlersIfNeeded:(NSMutableAttributedString *)result {
    if ( _regexs ) {
        for ( SFUTRegexHandler *handler in _regexs ) {
            NSString *string = result.string;
            NSRange resultRange = NSMakeRange(0, result.length);
            SFUTRegexRecorder *recorder = handler.recorder;
            if ( recorder.regex.length < 1 )
                continue;
            
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:recorder.regex options:recorder.regularExpressionOptions error:nil];
            NSMutableArray<NSTextCheckingResult *> *results = [NSMutableArray new];
            [regular enumerateMatchesInString:string options:recorder.matchingOptions range:resultRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                if ( result ) [results addObject:result];
            }];
            
            [results enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSRange range = obj.range;
                if ( recorder.update != nil ) {
                    [self _appendUpdateHandlerToUpdates:recorder.update inRange:range];
                }
                else if ( recorder.utOfReplaceWithString != nil ) {
                    [self _executeReplaceWithString:result ut:recorder.utOfReplaceWithString inRange:range];
                }
                else if ( recorder.replaceWithText != nil ) {
                    [self _executeReplaceWithText:result handler:recorder.replaceWithText inRange:range];
                }
                else if ( recorder.handler != nil ) {
                    recorder.handler(result, obj);
                }
            }];
        }
        _regexs = nil;
    }
}

- (void)_executeReplaceWithString:(NSMutableAttributedString *)result ut:(id<SFUTAttributesProtocol>)ut inRange:(NSRange)range {
    if ( _rangeContains(_textRange(result), range) ) {
        SFUTAttributes *uta = (id)ut;
        [self _setSubtextCommonValuesToRecorder:uta.recorder inRange:range result:result];
        id _Nullable subtext = [self _convertToUIKitTextForUTAttributes:uta];
        if ( subtext ) {
            [result replaceCharactersInRange:range withAttributedString:subtext];
        }
    }
}

- (void)_executeReplaceWithText:(NSMutableAttributedString *)result handler:(void(^)(id<SFUIKitTextMakerProtocol> maker))handler inRange:(NSRange)range {
    if ( _rangeContains(_textRange(result), range) ) {
        SFUIKitTextMaker *maker = [SFUIKitTextMaker new];
        [self _setCommonValuesForUTAttributesRecorderIfNeeded:maker.recorder];
        [self _setSubtextCommonValuesToRecorder:maker.recorder inRange:range result:result];
        handler(maker);
        [result replaceCharactersInRange:range withAttributedString:maker.install];
    }
}

- (void)_executeUpdateHandlersIfNeeded:(NSMutableAttributedString *)result {
    if ( _updates ) {
        NSRange resultRange = NSMakeRange(0, result.length);
        for ( SFUTAttributes *ut in _updates ) {
            SFUTRecorder *recorder = ut.recorder;
            NSRange range = recorder->range;
            if ( _rangeContains(resultRange, range) ) {
                [self _setCommonValuesForUTAttributesRecorderIfNeeded:recorder];
                id attributes = [self _convertToUIKitTextAttributesForUTAttributesRecorder:recorder];
                [result addAttributes:attributes range:range];
            }
        }
        _updates = nil;
    }
}

- (void)_appendUpdateHandlerToUpdates:(void(^)(id<SFUTAttributesProtocol>))handler inRange:(NSRange)range {
    SFUTAttributes *ut = [SFUTAttributes new];
    ut.recorder->range = range;
    handler(ut);
    [self.updates addObject:ut];
}

- (void)_setSubtextCommonValuesToRecorder:(SFUTRecorder *)recorder inRange:(NSRange)range result:(NSAttributedString *)result {
    if ( _rangeContains(_textRange(result), range) ) {
        NSAttributedString *subtext = [result attributedSubstringFromRange:range];
        NSDictionary<NSAttributedStringKey, id> *dict = [subtext attributesAtIndex:0 effectiveRange:NULL];
        recorder->font = dict[NSFontAttributeName];
        recorder->textColor = dict[NSForegroundColorAttributeName];
    }
}

- (void)_setCommonValuesForUTAttributesRecorderIfNeeded:(SFUTRecorder *)recorder {
    SFUTRecorder *common = self.recorder;
#define SFUTSetRecorderCommonValueIfNeeded(__var__) if ( recorder->__var__ == nil ) recorder->__var__ = common->__var__;
    SFUTSetRecorderCommonValueIfNeeded(font);
    SFUTSetRecorderCommonValueIfNeeded(textColor);
    SFUTSetRecorderCommonValueIfNeeded(backgroundColor);
    
    SFUTSetRecorderCommonValueIfNeeded(alignment);
    SFUTSetRecorderCommonValueIfNeeded(lineSpacing);
    SFUTSetRecorderCommonValueIfNeeded(lineBreakMode);
    SFUTSetRecorderCommonValueIfNeeded(style);
    
    SFUTSetRecorderCommonValueIfNeeded(kern);
    SFUTSetRecorderCommonValueIfNeeded(stroke);
    SFUTSetRecorderCommonValueIfNeeded(shadow);
    SFUTSetRecorderCommonValueIfNeeded(underLine);
    SFUTSetRecorderCommonValueIfNeeded(strikethrough);
    SFUTSetRecorderCommonValueIfNeeded(baseLineOffset);
}

- (NSDictionary *)_convertToUIKitTextAttributesForUTAttributesRecorder:(SFUTRecorder *)recorder {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = recorder->font;
    attrs[NSForegroundColorAttributeName] = recorder->textColor;
    if ( recorder->backgroundColor != nil ) attrs[NSBackgroundColorAttributeName] = recorder->backgroundColor;
    attrs[NSParagraphStyleAttributeName] = [recorder paragraphStyle];
    if ( recorder->kern != nil ) attrs[NSKernAttributeName] = recorder->kern;
    SFUTStroke *_Nullable stroke = recorder->stroke;
    if ( stroke != nil ) {
        attrs[NSStrokeColorAttributeName] = stroke.color;
        attrs[NSStrokeWidthAttributeName] = @(stroke.width);
    }
    if ( recorder->shadow != nil ) attrs[NSShadowAttributeName] = recorder->shadow;
    SFUTDecoration *_Nullable underLine = recorder->underLine;
    if ( underLine != nil ) {
        attrs[NSUnderlineStyleAttributeName] = @(underLine.style);
        attrs[NSUnderlineColorAttributeName] = underLine.color;
    }
    SFUTDecoration *_Nullable strikethrough = recorder->strikethrough;
    if ( strikethrough != nil ) {
        attrs[NSStrikethroughStyleAttributeName] = @(strikethrough.style);
        attrs[NSStrikethroughColorAttributeName] = strikethrough.color;
    }
    if ( recorder->baseLineOffset != nil ) attrs[NSBaselineOffsetAttributeName] = recorder->baseLineOffset;
    return attrs;
}

- (CGRect)_adjustVerticalOffsetOfImageAttachmentForBounds:(CGRect)bounds imageSize:(CGSize)imageSize alignment:(SFUTVerticalAlignment)alignment commonFont:(UIFont *)font {
    switch ( alignment ) {
        case SFUTVerticalAlignmentTop: {
            if ( CGSizeEqualToSize(CGSizeZero, bounds.size) ) {
                bounds.size = imageSize;
            }
            CGFloat offset = -(bounds.size.height - ABS(font.capHeight));
            bounds.origin.y = offset;
        }
            break;
        case SFUTVerticalAlignmentCenter: {
            if ( CGSizeEqualToSize(CGSizeZero, bounds.size) ) {
                bounds.size = imageSize;
            }
            CGFloat offset = -(bounds.size.height * 0.5 - ABS(font.descender));
            bounds.origin.y = offset;
        }
            break;
        case SFUTVerticalAlignmentBottom: { }
            break;
    }
    return bounds;
}
@end
NS_ASSUME_NONNULL_END
