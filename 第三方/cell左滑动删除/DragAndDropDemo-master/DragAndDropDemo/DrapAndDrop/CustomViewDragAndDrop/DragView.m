//
//  DragView.m
//  CardScrlDemo
//
//  Created by lotus on 2019/12/28.
//  Copyright © 2019 lotus. All rights reserved.
//

#import "DragView.h"

@interface DragView ()
@property (nonatomic, strong) UILabel *textLb;
@end

@implementation DragView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLb.frame = self.bounds;
}

- (void)setupSubviews
{
    [self addSubview:self.textLb];
}

#pragma mark - public
- (void)configText:(NSString *)text
{
    self.textLb.text = text;
}

- (NSString *)dragText{
    return self.textLb.text;
}

#pragma mark - getter
- (UILabel *)textLb
{
    if (!_textLb) {
        UILabel *textLb = [[UILabel alloc] init];
        textLb.text = @"text from drap view";
        textLb.userInteractionEnabled = YES;
        _textLb = textLb;
    }
    return _textLb;
}

@end
