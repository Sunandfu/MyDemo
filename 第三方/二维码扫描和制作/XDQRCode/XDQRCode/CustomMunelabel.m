//
//  CustomMunelabel.m
//  XDQRCode
//
//  Created by 小富 on 2017/5/24.
//  Copyright © 2017年 DINGYONGGANG. All rights reserved.
//

#import "CustomMunelabel.h"

@interface CustomMunelabel ()

@property UIPasteboard *pBoard;

@end

@implementation CustomMunelabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0;
        [self attachTapGesture];
        self.pBoard = [UIPasteboard generalPasteboard];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.numberOfLines = 0;
        [self attachTapGesture];
        self.pBoard = [UIPasteboard generalPasteboard];
    }
    return self;
}

- (void)attachTapGesture{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapAction:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)handleTapAction:(UITapGestureRecognizer *)sender {
    [self becomeFirstResponder];
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuItem *pasteMenueItem = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(pasteAction:)];
    UIMenuItem *cutMenuItem = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(cutAction:)];
    UIMenuItem *queryMenuItem = [[UIMenuItem alloc]initWithTitle:@"查询" action:@selector(queryAction:)];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, pasteMenueItem,cutMenuItem,queryMenuItem, nil]];
    [menuController setTargetRect:self.frame inView:self.superview];
    [menuController setMenuVisible:YES animated: YES];
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
    if (action == @selector(pasteAction:)) {
        return YES;
    }
    if (action == @selector(cutAction:)) {
        return YES;
    }
    if (action == @selector(queryAction:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

#pragma mark 实现方法

- (void)copyAction:(id)sender {
    self.pBoard.string = self.text;
    NSLog(@"粘贴的内容为%@", self.pBoard.string);
}

- (void)pasteAction:(id)sender {
    self.text = self.pBoard.string;
}

- (void)cutAction:(id)sender {
    self.pBoard.string = self.text;
    self.text = nil;
}

- (void)queryAction:(id)sender {
    UIReferenceLibraryViewController *referenceLibraryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:self.text];
    [[self viewController] presentViewController:referenceLibraryViewController animated:YES completion:nil];
}
- (UIViewController *)viewController
{
    UIResponder *responder = self;
    do {
        responder = [responder nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    } while (responder != nil);
    return nil;
}


@end
