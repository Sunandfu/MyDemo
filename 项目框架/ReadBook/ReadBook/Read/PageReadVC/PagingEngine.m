
#import "PagingEngine.h"
#import <CoreText/CoreText.h>

@interface PagingEngine (){
}

@end

@implementation PagingEngine
+ (NSArray *)pagingwithContentString:(NSString *)contentString contentSize:(CGSize)contentSize textAttribute:(NSDictionary *)textAttribute {
    NSMutableArray *pagingArray = [NSMutableArray array];
    NSMutableAttributedString *orginAttString = [[NSMutableAttributedString alloc] initWithString:contentString attributes:textAttribute];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:orginAttString];
    
    NSLayoutManager* layoutManager = [[NSLayoutManager alloc] init];
    
    [textStorage addLayoutManager:layoutManager];
    
    while (YES) {
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:contentSize];
        [layoutManager addTextContainer:textContainer];

        NSRange rang = [layoutManager glyphRangeForTextContainer:textContainer];
        if (rang.length <= 0) {
            break;
        }
        
        
        NSAttributedString *attStr =[textStorage attributedSubstringFromRange:rang];
        
        [pagingArray addObject:attStr];
    }
    return pagingArray;
}


+ (NSArray *)coreTextPaging:(NSAttributedString *)str textFrame:(CGRect)textFrame{
    NSMutableArray *pagingResult = [NSMutableArray array];
    CFAttributedStringRef cfAttStr = (__bridge CFAttributedStringRef)str;
    //直接桥接，引用计数不变
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(cfAttStr);
    CGPathRef path = CGPathCreateWithRect(textFrame, NULL);
    
    int textPos = 0;
    
    NSUInteger strLength = [str length];
    while (textPos < strLength) {
        //设置路径
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        //生成frame
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        NSRange ra = NSMakeRange(frameRange.location, frameRange.length);
        
        [pagingResult addObject:[str attributedSubstringFromRange:ra]];
        
        //获取范围并转换为NSRange，然后以NSString形式保存
        textPos += frameRange.length;
        //移动当前文本位置
        CFRelease(frame);
    }
    CGPathRelease(path);
    CFRelease(framesetter);
    //释放frameSetter
    return pagingResult;

}


/*
 误差问题
 这个问题的在普通文本上并没有发现，会出现在使用富文本排版时，具体表现是当TextContainer和TextView的Size完全相同时，最终展示的结果并不完美，不仅几乎所有页尾不规整，严重的时候还会出现最后行被截掉一半的情况。
 这个问题参看官方文档，苹果给出的解释是：排版时会出现一个行高（Height向问题，行高包括字高和行距）或者字长（Width向问题，字长包括单个字占据的宽度+字距）的误差。这个误差一定不会超过一个字长或者一个行高。
 出现这种情况会很影响排版效果。目前个人的解决方法是：
 1.保证TextContainer的Size.Height比TextView少一个行高。
 2.控制TextView的Frame使其上下空出的位置尽可能相等。
 
 
 // 获取当前TextContainer中的字符串Range
 - (NSRange)glyphRangeForTextContainer:(NSTextContainer *)container;
 
 // 获取当前TextContainer中某个矩形内文本的Range
 - (NSRange)glyphRangeForBoundingRect:(CGRect)bounds inTextContainer:(NSTextContainer *)container;
 
 // 获取当前TextContainer内文本占据的Rect
 - (CGRect)usedRectForTextContainer:(NSTextContainer *)container;
 */
@end
