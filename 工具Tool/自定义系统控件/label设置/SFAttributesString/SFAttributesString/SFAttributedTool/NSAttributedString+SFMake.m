//
//  NSAttributedString+SFMake.m
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "NSAttributedString+SFMake.h"
#import "SFUIKitTextMaker.h"

NS_ASSUME_NONNULL_BEGIN
@implementation NSAttributedString (SFMake)
+ (instancetype)sf_UIKitText:(void(^)(id<SFUIKitTextMakerProtocol> make))block {
    SFUIKitTextMaker *maker = [SFUIKitTextMaker new];
    block(maker);
    return maker.install;
}

- (CGSize)sf_textSize {
    return [self sf_textSizeForPreferredMaxLayoutWidth:CGFLOAT_MAX];
}
- (CGSize)sf_textSizeForRange:(NSRange)range {
    if ( range.length < 1 || range.length > self.length )
        return CGSizeZero;
    return sf_textSize([self attributedSubstringFromRange:range], CGFLOAT_MAX, CGFLOAT_MAX);
}
- (CGSize)sf_textSizeForPreferredMaxLayoutWidth:(CGFloat)width {
    return sf_textSize(self, width, CGFLOAT_MAX);
}
- (CGSize)sf_textSizeForPreferredMaxLayoutHeight:(CGFloat)height {
    return sf_textSize(self, CGFLOAT_MAX, height);
}

static CGSize sf_textSize(NSAttributedString *attrStr, CGFloat width, CGFloat height) {
    if ( attrStr.length < 1 )
        return CGSizeZero;
    CGRect bounds = [attrStr boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    bounds.size.width = ceil(bounds.size.width);
    bounds.size.height = ceil(bounds.size.height);
    return bounds.size;
}
@end
NS_ASSUME_NONNULL_END
