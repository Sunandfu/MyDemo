//
//  UITextField+JCTextField.m
//  JCKeyBoard
//
//  Created by QB on 16/4/27.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "UITextField+JCTextField.h"
/*
 *  1.UITextPosition和UITextRange类是符合UITextInput文档，
 *  2.UITextPosition代表一个文本容器中的位置
 *  3.UITextRange对象封装了开始和结束UITextPosition的对象
 */

@implementation UITextField (JCTextField)

///变换输入框的 输入的字符串
- (void)changTextWithNSString:(NSString *)text {
    //UITextPosition对象
    //文本开始
    UITextPosition *begining = self.beginningOfDocument;
    //标记和选定文本
    UITextPosition *start = self.selectedTextRange.start;
    UITextPosition *end = self.selectedTextRange.end;
    //计算文本的范围和位置
    NSInteger startIndex = [self offsetFromPosition:begining toPosition:start];
    NSInteger endIndex = [self offsetFromPosition:begining toPosition:end];
    //获取输入的字符串
    NSString *originText = self.text;
    //截取字符串---从字符串的开头一直截取到指定的位置，但不包括该位置的字符
    NSString *firstPart = [originText substringToIndex:startIndex];
    //截取字符串---从指定位置开始（包括指定位置的字符），并包括之后的全部字符
    NSString *secondPart = [originText substringFromIndex:endIndex];
    // 设置变量
    NSInteger offset;
    if (![text isEqualToString:@""]) {
        offset = text.length;
    } else {
        if (startIndex == endIndex) {
            if (startIndex == 0) {
                return;
            }
            offset = -1;
            firstPart = [firstPart substringToIndex:(firstPart.length - 1)];
        } else {
            offset = 0;
        }
    }
    NSString *newText = [NSString stringWithFormat:@"%@%@%@", firstPart, secondPart, text];
    self.text = newText;
    UITextPosition *now = [self positionFromPosition:start offset:offset];
    UITextRange *range = [self textRangeFromPosition:now toPosition:now];
    self.selectedTextRange = range;

}


@end
