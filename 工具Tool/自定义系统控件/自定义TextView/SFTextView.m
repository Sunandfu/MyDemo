//
//  SFTextView.m
//  TestAdA
//
//  Created by lurich on 2020/11/27.
//  Copyright © 2020 YX. All rights reserved.
//

#import "SFTextView.h"
#import "SFNetTool.h"

@interface SFTextView ()<UITextViewDelegate>

@property UIPasteboard *pBoard;

@end

@implementation SFTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllViews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self createAllViews];
    }
    return self;
}

- (void)createAllViews{
    self.delegate = self;
    self.pBoard = [UIPasteboard generalPasteboard];
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.bounds.size.width, self.bounds.size.height)];
    label.font = [UIFont systemFontOfSize:HFont(14) weight:UIFontWeightRegular];
    label.textColor = [SFNetTool colorWithHexString:@"#A7A7A7"];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    self.placeholderLabel = label;
    
    //设置菜单
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuItem *pasteMenueItem = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(pasteAction:)];
    UIMenuItem *cutMenuItem = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(cutAction:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem,pasteMenueItem,cutMenuItem, nil]];
    [menuController setTargetRect:self.frame inView:self.superview];
    [menuController setMenuVisible:YES animated: YES];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyAction:) ||
    action == @selector(pasteAction:) ||
    action == @selector(cutAction:)) {
        return YES;
    } else {
//        BOOL isAppear = [super canPerformAction:action withSender:sender];
//        return isAppear;
        return NO;
    }
}
- (void)copyAction:(id)sender {
    NSRange textRange = [self selectedRange];//self 是UITextView的子类
    if (textRange.length > 0) {
        NSString *string = [self.text substringWithRange:textRange];
        if (string != nil) {
            self.pBoard.string = string;
            SFLog(@"粘贴的内容为%@", self.pBoard.string);
        }
    }
    [self resignFirstResponder];
}

- (void)pasteAction:(id)sender {
    NSRange textRange = [self selectedRange];//self 是UITextView的子类
    if (textRange.length > 0) {
        NSString *leftStr = [self.text substringToIndex:textRange.location];
        NSString *right = [self.text substringFromIndex:(textRange.location+textRange.length)];
        self.text = [NSString stringWithFormat:@"%@%@%@",leftStr,self.pBoard.string,right];
    }
    [self resignFirstResponder];
}

- (void)cutAction:(id)sender {
    NSRange textRange = [self selectedRange];//self 是UITextView的子类
    if (textRange.length > 0) {
        NSString *string = [self.text substringWithRange:textRange];
        NSString *leftStr = [self.text substringToIndex:textRange.location];
        NSString *right = [self.text substringFromIndex:(textRange.location+textRange.length)];
        self.text = [NSString stringWithFormat:@"%@%@",leftStr,right];
        if (string != nil) {
            self.pBoard.string = string;
        }
    }
    [self resignFirstResponder];
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}
- (void)setPlaceholderHeight:(CGFloat)placeholderHeight{
    _placeholderHeight = placeholderHeight;
    self.placeholderLabel.frame = CGRectMake(0, 0, self.bounds.size.width, placeholderHeight);
}
//创建子类重写UITextView方法
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = _placeholderHeight;
    return originalRect;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
    if (self.sf_delegate) {
        [self.sf_delegate sf_textViewDidChange:textView];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.sf_delegate) {
        return [self.sf_delegate sf_textViewShouldBeginEditing:textView];
    } else {
        return YES;
    }
}

@end
