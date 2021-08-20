//
//  SFUTAttributes.m
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SFUTAttributes.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SFUTAttributes
@synthesize recorder = _recorder;
- (SFUTRecorder *)recorder {
    if ( !_recorder ) {
        _recorder = [[SFUTRecorder alloc] init];
    }
    return _recorder;
}

- (SFUTFontAttribute)font {
    return ^id<SFUTAttributesProtocol>(UIFont *font) {
        self.recorder->font = font;
        return self;
    };
}

- (SFUTColorAttribute)textColor {
    return ^id<SFUTAttributesProtocol>(UIColor *color) {
        self.recorder->textColor = color;
        return self;
    };
}

- (SFUTAlignmentAttribute)alignment {
    return ^id<SFUTAttributesProtocol>(NSTextAlignment alignment) {
        self.recorder->alignment = @(alignment);
        return self;
    };
}

- (SFUTLineSpacingAttribute)lineSpacing {
    return ^id<SFUTAttributesProtocol>(CGFloat lineSpacing) {
        self.recorder->lineSpacing = @(lineSpacing);
        return self;
    };
}

- (SFUTKernAttribute)kern {
    return ^id<SFUTAttributesProtocol>(CGFloat kern) {
        ///
        /// Thanks @donggelaile
        /// https://github.com/changsanjiang/SFAttributesFactory/issues/9
        ///
        self.recorder->kern = @(kern);
        return self;
    };
}

- (SFUTShadowAttribute)shadow {
    return ^id<SFUTAttributesProtocol>(void(^block)(NSShadow *make)) {
        NSShadow *_Nullable shadow = self.recorder->shadow;
        if ( !shadow ) {
            self.recorder->shadow = shadow = [NSShadow new];
        }
        block(shadow);
        return self;
    };
}

- (SFUTColorAttribute)backgroundColor {
    return ^id<SFUTAttributesProtocol>(UIColor *color) {
        self.recorder->backgroundColor = color;
        return self;
    };
}

- (SFUTStrokeAttribute)stroke {
    return ^id<SFUTAttributesProtocol>(void(^block)(id<SFUTStroke> stroke)) {
        SFUTStroke *_Nullable stroke = self.recorder->stroke;
        if ( !stroke ) {
            self.recorder->stroke = stroke = [SFUTStroke new];
        }
        block(stroke);
        return self;
    };
}

- (SFUTParagraphStyleAttribute)paragraphStyle {
    return ^id<SFUTAttributesProtocol>(void(^block)(NSMutableParagraphStyle *style)) {
        NSMutableParagraphStyle *_Nullable style = self.recorder->style;
        if ( !style ) {
            self.recorder->style = style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        }
        block(style);
        return self;
    };
}

- (SFUTLineBreakModeAttribute)lineBreakMode {
    return ^id<SFUTAttributesProtocol>(NSLineBreakMode lineBreakMode) {
        self.recorder->lineBreakMode = @(lineBreakMode);
        return self;
    };
}

- (SFUTDecorationAttribute)underLine {
    return ^id<SFUTAttributesProtocol>(void(^block)(id<SFUTDecoration> decoration)) {
        SFUTDecoration *_Nullable decoration = self.recorder->underLine;
        if ( !decoration ) {
            self.recorder->underLine = decoration = [SFUTDecoration new];
        }
        block(decoration);
        return self;
    };
}

- (SFUTDecorationAttribute)strikethrough {
    return ^id<SFUTAttributesProtocol>(void(^block)(id<SFUTDecoration> decoration)) {
        SFUTDecoration *_Nullable decoration = self.recorder->strikethrough;
        if ( !decoration ) {
            self.recorder->strikethrough = decoration = [SFUTDecoration new];
        }
        block(decoration);
        return self;
    };
}

- (SFUTBaseLineOffsetAttribute)baseLineOffset {
    return ^id<SFUTAttributesProtocol>(double offset) {
        self.recorder->baseLineOffset = @(offset);
        return self;
    };
}
@end
NS_ASSUME_NONNULL_END
