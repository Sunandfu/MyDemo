//
//  SFUTRecorder.h
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFUIKitAttributesDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SFUTStroke : NSObject<SFUTStroke>
@property (nonatomic, strong, nullable) UIColor *color;
@property (nonatomic) float width;
@end

@interface SFUTDecoration : NSObject<SFUTDecoration>
@property (nonatomic, strong, nullable) UIColor *color;
/**
 // NSUnderlineStyleNone 不设置下划线／删除线

 // NSUnderlineStyleSingle 设置下划线／删除线为细的单线

 // NSUnderlineStyleThick 设置下划线／删除线为粗的单线

 // NSUnderlineStyleDouble 设置下划线／删除线为细的双线



 // NSUnderlinePatternSolid 设置下划线／删除线样式为连续的实线
 
 // NSUnderlinePatternDot 设置下划线／删除线样式为点，也就是虚线，比如这样：..........

 // NSUnderlinePatterDash 设置下划线／删除线样式为破折号，比如这样：_ _ _ _ _ _

 // NSUnderlinePatternDashDot 设置下划线／删除线样式为连续的破折号和点，比如这样：_._._._.

 // NSUnderlinePatternDashDotDot 设置下划线／删除线样式为连续的破折号、点、点，比如：_.._.._.._..



 // NSUnderlineByWord 在有空格的地方不设置下划线／删除线
 */
@property (nonatomic) NSUnderlineStyle style;
@end

@interface SFUTImageAttachment : NSObject<SFUTImageAttachment>
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic) CGRect bounds;
@property (nonatomic) SFUTVerticalAlignment alignment;
@end

@interface SFUTReplace : NSObject
@property (nonatomic, strong, nullable) NSString *fromString;
@property (nonatomic, copy, nullable) void(^block)(id<SFUIKitTextMakerProtocol> make);
@end

@interface SFUTRecorder : NSObject {
    @package
    UIFont *_Nullable font;
    UIColor *_Nullable textColor;
    UIColor *_Nullable backgroundColor;
    NSNumber *_Nullable alignment;
    NSNumber *_Nullable lineSpacing;
    NSNumber *_Nullable kern;
    NSShadow *_Nullable shadow;
    SFUTStroke *_Nullable stroke;
    NSMutableParagraphStyle *_Nullable style;
    NSNumber *_Nullable lineBreakMode;
    SFUTDecoration *_Nullable underLine;
    SFUTDecoration *_Nullable strikethrough;
    NSNumber *_Nullable baseLineOffset;
    
    // - sources
    NSString *_Nullable string;
    NSRange range;
    SFUTImageAttachment *_Nullable attachment;
    NSMutableAttributedString *_Nullable attrStr;
}

- (NSParagraphStyle *)paragraphStyle;
@end
NS_ASSUME_NONNULL_END
