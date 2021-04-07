//
//  SFTextView.m
//  ReadBook
//
//  Created by lurich on 2020/5/23.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFTextView.h"
#import "SFSoundPlayer.h"
#import "SFConstant.h"

@interface SFTextView ()

@property UIPasteboard *pBoard;

@end

@implementation SFTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.pBoard = [UIPasteboard generalPasteboard];
        //设置菜单
        [self createMenuItem];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.pBoard = [UIPasteboard generalPasteboard];
        //设置菜单
        [self createMenuItem];
    }
    return self;
}
- (void)createMenuItem{
    self.editable = NO;
    UITapGestureRecognizer *tapGes =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tapGes];
    BOOL readBookStudy = [[NSUserDefaults standardUserDefaults] boolForKey:KeyReadBookStudy];
    self.selectable = readBookStudy;
    //设置菜单
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuItem *pasteMenueItem = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(pasteAction:)];
    UIMenuItem *cutMenuItem = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(cutAction:)];
    UIMenuItem *queryMenuItem = [[UIMenuItem alloc]initWithTitle:@"字典" action:@selector(queryAction:)];
    UIMenuItem *speakMenuItem = [[UIMenuItem alloc]initWithTitle:@"发音" action:@selector(speakMenu:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem,pasteMenueItem,cutMenuItem,queryMenuItem,speakMenuItem, nil]];
    [menuController setTargetRect:self.frame inView:self.superview];
    [menuController setMenuVisible:YES animated: YES];
    
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:recognizerRight];
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:recognizerLeft];
    UISwipeGestureRecognizer *recognizertop = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizertop setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:recognizertop];
    UISwipeGestureRecognizer *recognizerbottom = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerbottom setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:recognizerbottom];
    //捏合手势
//    UIPinchGestureRecognizer *pinchGes= [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
//    [self addGestureRecognizer:pinchGes];
        
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SFTextViewSwipeGesture" object:nil userInfo:@{@"direction":@"right"}];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SFTextViewSwipeGesture" object:nil userInfo:@{@"direction":@"left"}];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SFTextViewSwipeGesture" object:nil userInfo:@{@"direction":@"up"}];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SFTextViewSwipeGesture" object:nil userInfo:@{@"direction":@"down"}];
    }
}
-(void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    NSLog(@"pinch.scale = %f",pinch.scale);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SFTextViewPinchGesture" object:nil userInfo:@{@"scale":@(pinch.scale)}];
    pinch.scale = 1;
}

/**
 (action ==@selector(cut:) ||
 action ==@selector(copy:) ||
 action ==@selector(select:) ||
 action ==@selector(selectAll:) ||
 action ==@selector(paste:) ||
 action ==@selector(delete:))
 */
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyAction:) ||
    action == @selector(pasteAction:) ||
    action == @selector(cutAction:) ||
    action == @selector(queryAction:) ||
    action == @selector(speakMenu:)) {
        return YES;
    } else {
//        BOOL isAppear = [super canPerformAction:action withSender:sender];
//        return isAppear;
        return NO;
    }
}
//是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
- (BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*) otherGestureRecognizer{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [NSStringFromClass([otherGestureRecognizer class])isEqualToString:@"UITextTapRecognizer"]){
        return NO;
    }
    return YES;
}

- (void)copyAction:(id)sender {
    NSRange textRange = [self selectedRange];//self 是UITextView的子类
    if (textRange.length > 0) {
        NSString *string = [self.text substringWithRange:textRange];
        if (string != nil) {
            self.pBoard.string = string;
            NSLog(@"粘贴的内容为%@", self.pBoard.string);
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

- (void)queryAction:(id)sender {
    NSRange textRange = [self selectedRange];//self 是UITextView的子类
    if (textRange.length > 0) {
        NSString *string = [self.text substringWithRange:textRange];
        if (string != nil) {
            [self resignFirstResponder];
            UIReferenceLibraryViewController *referenceLibraryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:string];
            [[self viewController] presentViewController:referenceLibraryViewController animated:YES completion:nil];
        }
    }
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
- (void)speakMenu:(id)sender{
    NSRange textRange = [self selectedRange];//self 是UITextView的子类
    if (textRange.length > 0) {
        NSString *string = [self.text substringWithRange:textRange];
        if (string != nil) {
            SFSoundPlayer *speechAv = [SFSoundPlayer SharedSoundPlayer];
            CGFloat bookRate = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookRate];
            CGFloat bookPitchMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookPitch];
            [speechAv setDefaultWithVolume:1.0 rate:bookRate pitchMultiplier:bookPitchMultiplier];
            [speechAv play:string];
        }
    }
    [self resignFirstResponder];
}
- (void)tapClick:(UITapGestureRecognizer *)tapGes{
    [self resignFirstResponder];
    CGPoint point = [tapGes locationInView:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SFTextViewClick" object:nil userInfo:@{@"clickX":@(point.x),@"clickY":@(point.y)}];
}

@end
