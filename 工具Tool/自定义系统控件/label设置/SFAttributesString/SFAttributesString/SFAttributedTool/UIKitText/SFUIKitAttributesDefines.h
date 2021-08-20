//
//  SFUIKitAttributesDefines.h
//  AttributesFactory
//
//  Created by 畅三江 on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#ifndef SFUIKitAttributesDefines_h
#define SFUIKitAttributesDefines_h
#import <UIKit/UIKit.h>
@protocol   SFUIKitTextMakerProtocol,
            SFUTAttributesProtocol,
            SFUTImageAttributesProtocol,
            SFUTRegexHandlerProtocol,
            SFUTRangeHandlerProtocol,
            SFUTStroke,
            SFUTDecoration,
            SFUTImageAttachment;

NS_ASSUME_NONNULL_BEGIN
@protocol SFUIKitTextMakerProtocol <SFUTAttributesProtocol>
/**
 * - Append a `string` to the text.
 *
 * \code
 *    NSAttributedString *text = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *       make.append(@"String 1").font([UIFont boldSystemFontOfSize:14]);
 *   }];
 *
 *   // It's equivalent to below code.
 *
 *   NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
 *   NSAttributedString *text1 = [[NSAttributedString alloc] initWithString:@"String 1" attributes:attributes];
 *
 * \endcode
 */
@property (nonatomic, copy, readonly) id<SFUTAttributesProtocol>(^append)(NSString *str);

typedef void(^SFUTAppendImageHandler)(id<SFUTImageAttachment> make);
/**
 * - Append an `image attachment` to the text.
 *
 * \code
 *    NSAttributedString *text = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *       make.appendImage(^(id<SFUTImageAttachment>  _Nonnull make) {
 *           make.image = [UIImage imageNamed:@"image"];
 *           make.bounds = CGRectMake(0, 0, 50, 50);
 *       });
 *   }];
 *
 *   // It's equivalent to below code.
 *
 *   NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
 *   attachment.image = [UIImage imageNamed:@"image"];
 *   attachment.bounds = CGRectMake(0, 0, 50, 50);
 *   NSAttributedString *text1 = [NSAttributedString attributedStringWithAttachment:attachment];
 *
 * \endcode
 */
@property (nonatomic, copy, readonly) id<SFUTAttributesProtocol>(^appendImage)(SFUTAppendImageHandler block);

/**
 * - Append a `subtext` to the text.
 *
 * \code
 *   NSAttributedString *subtext = _label.attributedText;
 *
 *   NSAttributedString *text = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *       make.appendText(subtext);
 *   }];
 *
 * \endcode
 */
@property (nonatomic, copy, readonly) id<SFUTAttributesProtocol>(^appendText)(NSAttributedString *subtext);

/**
 * - Update the attributes for the specified range of `text`.
 *
 * \code
 *    NSAttributedString *text = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *       make.append(@"String 1");
 *       make.update(NSMakeRange(0, 1)).font([UIFont boldSystemFontOfSize:20]);
 *   }];
 * \endcode
 */
@property (nonatomic, copy, readonly) id<SFUTAttributesProtocol>(^update)(NSRange range);

/**
 * - Use regular to process `text`.
 *
 * \code
 *    NSAttributedString *text1 = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *       make.append(@"123 123 4 123 123");
 *       // Replace `123` with `oOo`.
 *       make.regex(@"123").replaceWithString(@"oOo").font([UIFont boldSystemFontOfSize:20]);
 *   }];
 *
 *    NSAttributedString *text2 = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *       make.append(@"123 123 4 123 123");
 *       // Replace `123` with `oOo`.
 *       make.regex(@"123").replaceWithText(^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *           make.append(@"oOo").font([UIFont boldSystemFontOfSize:20]);
 *       });
 *   }];
 *
 *    NSAttributedString *text3 = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *       make.append(@"123 123 4 123 123");
 *       // Update the attributes of the matched text.
 *       make.regex(@"123").update(^(id<SFUTAttributesProtocol>  _Nonnull make) {
 *           make.font([UIFont boldSystemFontOfSize:20]).textColor([UIColor redColor]);
 *       });
 *   }];
 * \endcode
 */
@property (nonatomic, copy, readonly) id<SFUTRegexHandlerProtocol>(^regex)(NSString *regularExpression);

/**
 * - Edit the subtext for the specified range of `text`.
 *
 * \code
 *    NSAttributedString *text = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *       make.append(@"123 123 M 123 123").font([UIFont boldSystemFontOfSize:20]);
 *       // Update the attributes for the specified range of `text`.
 *       make.range(NSMakeRange(0, 1)).update(^(id<SFUTAttributesProtocol>  _Nonnull make) {
 *           make.font([UIFont boldSystemFontOfSize:20]).textColor([UIColor orangeColor]);
 *       });
 *
 *       // Replace the subtext for the specified range of `text`.
 *       make.range(NSMakeRange(1, 1)).replaceWithString(@"O").textColor([UIColor purpleColor]);
 *
 *       // Replace the subtext for the specified range of `text`.
 *       make.range(NSMakeRange(2, 1)).replaceWithText(^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
 *           make.append(@"S").font([UIFont boldSystemFontOfSize:24]).textColor([UIColor greenColor]);
 *       });
 *   }];
 * \endcode
 */
@property (nonatomic, copy, readonly) id<SFUTRangeHandlerProtocol>(^range)(NSRange range);
@end

typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTFontAttribute)(UIFont *font);
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTColorAttribute)(UIColor *color);
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTAlignmentAttribute)(NSTextAlignment alignment);
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTLineSpacingAttribute)(CGFloat lineSpacing);
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTKernAttribute)(CGFloat kern);
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTShadowAttribute)(void(^)(NSShadow *make));
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTStrokeAttribute)(void(^block)(id<SFUTStroke> make));
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTParagraphStyleAttribute)(void(^block)(NSMutableParagraphStyle *make));
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTLineBreakModeAttribute)(NSLineBreakMode lineBreakMode);
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTDecorationAttribute)(void(^)(id<SFUTDecoration> make));
typedef id<SFUTAttributesProtocol>_Nonnull(^SFUTBaseLineOffsetAttribute)(double offset);

@protocol SFUTAttributesProtocol
@property (nonatomic, copy, readonly) SFUTFontAttribute font;
@property (nonatomic, copy, readonly) SFUTColorAttribute textColor;
@property (nonatomic, copy, readonly) SFUTColorAttribute backgroundColor;
@property (nonatomic, copy, readonly) SFUTAlignmentAttribute alignment;
@property (nonatomic, copy, readonly) SFUTLineSpacingAttribute lineSpacing;
@property (nonatomic, copy, readonly) SFUTKernAttribute kern;
@property (nonatomic, copy, readonly) SFUTShadowAttribute shadow;
@property (nonatomic, copy, readonly) SFUTStrokeAttribute stroke;
@property (nonatomic, copy, readonly) SFUTParagraphStyleAttribute paragraphStyle;
@property (nonatomic, copy, readonly) SFUTLineBreakModeAttribute lineBreakMode;
@property (nonatomic, copy, readonly) SFUTDecorationAttribute underLine;
@property (nonatomic, copy, readonly) SFUTDecorationAttribute strikethrough;
@property (nonatomic, copy, readonly) SFUTBaseLineOffsetAttribute baseLineOffset;
@end

@protocol SFUTRangeHandlerProtocol
@property (nonatomic, copy, readonly) void(^update)(void(^)(id<SFUTAttributesProtocol> make));
@property (nonatomic, copy, readonly) void(^replaceWithText)(void(^)(id<SFUIKitTextMakerProtocol> make));
@property (nonatomic, copy, readonly) id<SFUTAttributesProtocol>(^replaceWithString)(NSString *string);
@end

@protocol SFUTRegexHandlerProtocol <SFUTRangeHandlerProtocol>
@property (nonatomic, copy, readonly) void(^handler)(void(^)(NSMutableAttributedString *attrStr, NSTextCheckingResult *result));

@property (nonatomic, copy, readonly) id<SFUTRegexHandlerProtocol>(^regularExpressionOptions)(NSRegularExpressionOptions ops);
@property (nonatomic, copy, readonly) id<SFUTRegexHandlerProtocol>(^matchingOptions)(NSMatchingOptions ops);
@end

@protocol SFUTStroke
@property (nonatomic, strong, nullable) UIColor *color;
@property (nonatomic) float width;
@end

@protocol SFUTDecoration
@property (nonatomic, strong, nullable) UIColor *color;
@property (nonatomic) NSUnderlineStyle style;
@end

typedef enum : NSUInteger {
    SFUTVerticalAlignmentBottom = 0,
    SFUTVerticalAlignmentCenter = 1,
    SFUTVerticalAlignmentTop = 2,
} SFUTVerticalAlignment;

@protocol SFUTImageAttachment <NSObject>
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic) SFUTVerticalAlignment alignment; ///< Text为统一的字体时生效
@property (nonatomic) CGRect bounds;
@end
NS_ASSUME_NONNULL_END
#endif /* SFUIKitAttributesDefines_h */
