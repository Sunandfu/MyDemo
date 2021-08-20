//
//  NSAttributedString+SFMake.h
//  AttributesFactory
//
//  Created by BlueDancer on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//
//  Project: https://github.com/changsanjiang/SFAttributesFactory
//  Email:  changsanjiang@gmail.com
//

#import <Foundation/Foundation.h>
#import "SFUIKitAttributesDefines.h"
#import "UILabel+SFAttributeText.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSAttributedString (SFMake)
/**
 * - make attributed string:
 *
 * \code
    NSAttributedString *attr = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
        make.font([UIFont boldSystemFontOfSize:16]).textColor(UIColor.blackColor).lineSpacing(5);

        make.append(@":Image -");
        make.appendImage(^(id<SFUTImageAttachment>  _Nonnull make) {
            make.image = [UIImage imageNamed:@"sample2"];
            make.bounds = CGRectMake(0, 0, 30, 30);
            make.alignment = SFUTVerticalAlignmentCenter;
        });

        make.append(@"\n");
        make.append(@":UnderLine   test").underLine(^(id<SFUTDecoration>  _Nonnull make) {
            make.style = NSUnderlineStyleSingle | NSUnderlineStylePatternDot | NSUnderlineByWord;
            make.color = UIColor.greenColor;
        });

        make.append(@"\n");
        make.append(@":Strikethrough").strikethrough(^(id<SFUTDecoration>  _Nonnull make) {
            make.style = NSUnderlineStyleThick;
            make.color = UIColor.redColor;
        });

        make.append(@"\n");
        make.append(@":BackgroundColor").backgroundColor(UIColor.greenColor);

        make.append(@"\n");
        make.append(@":Kern").kern(6);

        make.append(@"\n");
        make.append(@":Shadow").shadow(^(NSShadow * _Nonnull make) {
            make.shadowColor = [UIColor redColor];
            make.shadowOffset = CGSizeMake(0, 1);
            make.shadowBlurRadius = 5;
        });

        make.append(@"\n");
        make.append(@":Stroke").stroke(^(id<SFUTStroke>  _Nonnull make) {
            make.color = [UIColor greenColor];
            make.width = 1;
        });

        make.append(@"\n");
        make.append(@"oOo").font([UIFont boldSystemFontOfSize:25]).alignment(NSTextAlignmentCenter);

        make.append(@"\n");
        make.append(@"点击https://baidu.com网站获取详情").font([UIFont boldSystemFontOfSize:15]).alignment(NSTextAlignmentCenter).textColor(UIColor.redColor);
        make.regex(@"https://baidu.com").update(^(id<SFUTAttributesProtocol>  _Nonnull make) {
            make.font([UIFont boldSystemFontOfSize:18]).textColor(UIColor.blueColor);
        });

        make.append(@"\n");
        make.append(@"Regular Expression").backgroundColor([UIColor greenColor]);
        make.regex(@"Regular").update(^(id<SFUTAttributesProtocol>  _Nonnull make) {
            make.font([UIFont boldSystemFontOfSize:25]).textColor(UIColor.purpleColor);
        });

        make.regex(@"ss").replaceWithString(@"SS").backgroundColor([UIColor redColor]);
        make.regex(@"on").replaceWithText(^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
            make.append(@"ON😆").textColor([UIColor yellowColor]).backgroundColor([UIColor blueColor]).font([UIFont boldSystemFontOfSize:30]);
        });

        make.append(@"\n");
        make.append(@"@迷你世界联机 :@江叔 用小淘气耍赖野人#迷你世界#");
        make.regex(@"[@#][^\\s]+[\\s#]").update(^(id<SFUTAttributesProtocol>  _Nonnull make) {
            make.textColor([UIColor purpleColor]);
        });
    }];
    self.testLabel.attributedText = attr;
    [self.testLabel sf_addAttributeTapActionWithStrings:@[@"https://baidu.com"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        NSLog(@"string=%@ range=%@ index=%ld",string,NSStringFromRange(range),index);
    }];
 * \endcode
 */
+ (instancetype)sf_UIKitText:(void(^)(id<SFUIKitTextMakerProtocol> make))block;

- (CGSize)sf_textSize;
- (CGSize)sf_textSizeForRange:(NSRange)range;
- (CGSize)sf_textSizeForPreferredMaxLayoutWidth:(CGFloat)width;
- (CGSize)sf_textSizeForPreferredMaxLayoutHeight:(CGFloat)height;
@end
NS_ASSUME_NONNULL_END
