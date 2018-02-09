//
//  MyTextField.m
//  doctor
//
//  Created by 史岁富 on 15/8/14.
//  Copyright (c) 2015年 fupenghua. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
