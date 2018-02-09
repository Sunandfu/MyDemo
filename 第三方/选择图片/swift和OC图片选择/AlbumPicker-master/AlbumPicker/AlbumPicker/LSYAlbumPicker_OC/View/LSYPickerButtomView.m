//
//  LSYPickerButtomView.m
//  AlbumPicker
//
//  Created by okwei on 15/7/27.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYPickerButtomView.h"
@interface LSYPickerButtomView ()
@property (nonatomic,strong) UIButton *previewButton;
@property (nonatomic,strong) LSYSendButton *sendButton;
@end
@implementation LSYPickerButtomView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initPickerButtomView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPickerButtomView];
    }
    return self;
}
-(void)initPickerButtomView
{
    [self setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]];
    [self addSubview:self.previewButton];
    [self addSubview:self.sendButton];
}
-(UIButton *)previewButton
{
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forState:UIControlStateDisabled];
        [_previewButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewButton;
}
-(LSYSendButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[LSYSendButton alloc] init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
-(void)buttonClick:(UIButton *)sender
{
    if (sender == self.previewButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(previewButtonClick)]) {
            [self.delegate previewButtonClick];
        }
    } else if (sender == self.sendButton){
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendButtonClick)]) {
            [self.delegate sendButtonClick];
        }
    }
}
-(void)setSendNumber:(int)number
{
    [self.sendButton setSendNumber:number];
    if (number == 0) {
        [self.previewButton setEnabled:NO];
    }
    else
    {
        [self.previewButton setEnabled:YES];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.previewButton setFrame:CGRectMake(0, 0, 60, ViewSize(self).height)];
    [self.sendButton setFrame:CGRectMake(ViewSize(self).width-80, 0, 80, ViewSize(self).height)];
}
@end

/**
 LSYSendButton
 */
@interface LSYSendButton ()
@property (nonatomic,strong) UILabel *numbersLabel;
@property (nonatomic,strong) UIView *numbersView;
@end
@implementation LSYSendButton
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSendButton];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSendButton];
    }
    return self;
}
-(void)initSendButton
{
    [self setTitleColor:[UIColor colorWithRed:9/255.0 green:187/255.0 blue:7/255.0 alpha:1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:182/255.0 green:225/255.0 blue:187/255.0 alpha:1] forState:UIControlStateDisabled];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:self.numbersView];
    [self addSubview:self.numbersLabel];
}
-(UIView *)numbersView
{
    if (!_numbersView) {
        _numbersView = [[UIView alloc] init];
        [_numbersView setFrame:CGRectMake(0, 12, 20, 20)];
        [_numbersView setBackgroundColor:[UIColor colorWithRed:9/255.0 green:187/255.0 blue:7/255.0 alpha:1]];
        [_numbersView.layer setCornerRadius:10];
        [_numbersView setClipsToBounds:YES];
    }
    return _numbersView;
}
-(UILabel *)numbersLabel
{
    if (!_numbersLabel) {
        _numbersLabel = [[UILabel alloc] init];
        [_numbersLabel setTextColor:[UIColor whiteColor]];
        [_numbersLabel setTextAlignment:NSTextAlignmentCenter];
        [_numbersLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    return _numbersLabel;
}
-(void)setSendNumber:(int)number
{
    if (number == 0) {
        [self setEnabled:NO];
        [self isHiddenNumber:YES];
    }
    else{
        [self setEnabled:YES];
        [self isHiddenNumber:NO];
    }
    self.numbersLabel.text = [NSString stringWithFormat:@"%d",number];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.numbersView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.numbersView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.numbersView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}
-(void)isHiddenNumber:(BOOL)hidden
{
    [self.numbersView setHidden:hidden];
    [self.numbersLabel setHidden:hidden];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.numbersLabel setFrame:CGRectMake(0,12, 20, 20)];
    
}
@end