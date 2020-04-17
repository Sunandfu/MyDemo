//
//  SFTagBtnView.m
//  文字按钮
//
//  Created by XD on 2019/6/10.
//  Copyright © 2019 SFTagBtnView. All rights reserved.
//

#import "SFTagBtnView.h"

@interface SFTagBtnView ()

@property (nonatomic, assign) CGFloat maxX;

@property (nonatomic, readwrite, assign) CGFloat maxY;

@property (nonatomic, assign) NSInteger lastIndex;

@property (nonatomic, strong) NSMutableArray <NSString *> *selectArr;

@property (nonatomic, strong) NSArray <UIColor *> *btnColorArr;
@property (nonatomic, strong) UIColor *randomColor;

@end

@implementation SFTagBtnView

#define kAllBtnMaxWidth (self.bounds.size.width - self.marginX * 2)

static NSInteger const kSFTagBtnViewBtnTagPlus = 90000000;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.btnHeight = 30.0;
        self.marginX = 15.0;
        self.btnMarginX = 10.0;
        self.marginY = 15.0;
        self.textFontSize = 15.0;
        
        self.lastIndex = -1;
        self.isSingle = YES;
        self.isRandomColor = NO;
        
        self.borderColor = [UIColor colorWithRed:19.0f/255.0f green:181.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
        self.borderWidth = 1.0;
        self.btnTextColor = [UIColor colorWithRed:19.0f/255.0f green:181.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
        self.selectTextColor = [UIColor whiteColor];
        self.btnBackgroundColor = [UIColor whiteColor];
        self.selectBackgroundColor = [UIColor colorWithRed:19.0f/255.0f green:181.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
        
        self.selectArr = [NSMutableArray array];
        self.btnColorArr = @[
                                [UIColor colorWithRed:232.0f/255.0f green:77.0f/255.0f blue:22.0f/255.0f alpha:1.0f],
                                [UIColor colorWithRed:232.0f/255.0f green:158.0f/255.0f blue:0.0f/255.0f alpha:1.0f],
                                [UIColor colorWithRed:19.0f/255.0f green:181.0f/255.0f blue:177.0f/255.0f alpha:1.0f],
                                [UIColor colorWithRed:86.0f/255.0f green:84.0f/255.0f blue:182.0f/255.0f alpha:1.0f],
                                [UIColor colorWithRed:0.0f/255.0f green:146.0f/255.0f blue:92.0f/255.0f alpha:1.0f],
                                ];
    }
    return self;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
}

- (void)setBtnHeight:(CGFloat)btnHeight
{
    _btnHeight = btnHeight;
}

- (void)setMarginX:(CGFloat)marginX
{
    _marginX = marginX;
}

- (void)setTextArr:(NSArray<NSString *> *)textArr
{
    _textArr = textArr;
    
    for (int i = 0; i < textArr.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:0];
        
        NSString *text = textArr[i];
        
        CGFloat textWidth = [text boundingRectWithSize:CGSizeMake(kAllBtnMaxWidth, self.btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.textFontSize + 0.5]} context:nil].size.width;
        
        CGFloat btnWidth = textWidth + self.btnMarginX * 2;
        
        CGFloat btnX = self.maxX + self.marginX;
        CGFloat btnY = self.maxY;
        
        if (btnX > kAllBtnMaxWidth - btnWidth) {
            btnX = self.marginX;
            btnY = btnY + self.marginY + self.btnHeight;
        }
        
        btn.frame = CGRectMake(btnX, btnY, btnWidth, self.btnHeight);
        
        [btn setTitle:text forState:UIControlStateNormal];
        
        int randomIndex = arc4random_uniform((int)self.btnColorArr.count);
        UIColor *randomColor = self.btnColorArr[randomIndex];
        if (self.isRandomColor) {
            [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [btn setTitleColor:randomColor forState:UIControlStateNormal];
            [btn setBackgroundImage:[self imageWithColor:randomColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            if (self.borderWidth > 0 && randomColor) {
                btn.layer.borderWidth = self.borderWidth;
                btn.layer.borderColor = randomColor.CGColor;
            }
        } else {
            if (self.btnBackgroundColor) {
                [btn setBackgroundImage:[self imageWithColor:self.btnBackgroundColor] forState:UIControlStateNormal];
            }
            if (self.btnTextColor) {
                [btn setTitleColor:self.btnTextColor forState:UIControlStateNormal];
            }
            if (self.selectBackgroundColor) {
                [btn setBackgroundImage:[self imageWithColor:self.selectBackgroundColor] forState:UIControlStateSelected];
            }
            if (self.selectTextColor) {
                [btn setTitleColor:self.selectTextColor forState:UIControlStateSelected];
            }
            if (self.borderWidth > 0 && self.borderColor) {
                btn.layer.borderWidth = self.borderWidth;
                btn.layer.borderColor = self.borderColor.CGColor;
            }
        }
        
        if (self.cornerRadius > 0) {
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = self.cornerRadius;
        } else {
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = self.btnHeight/2.0;
        }
        
        [self unSelectBtn:btn];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:self.textFontSize];
        
        [self addSubview:btn];
        
        self.maxX = CGRectGetMaxX(btn.frame);
        self.maxY = CGRectGetMinY(btn.frame);
        
        btn.tag = kSFTagBtnViewBtnTagPlus + i;
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (textArr.count > 0) {
        self.maxY = self.maxY + self.btnHeight;
    }

}

- (void)setDefultIndexArr:(NSArray<NSString *> *)defultIndexArr
{
    _defultIndexArr = defultIndexArr;
    
    for (int i = 0; i < defultIndexArr.count; i ++) {
        
        if (i > defultIndexArr.count - 1) {
            break;
        }
        
        NSString *index = defultIndexArr[i];
        UIButton *btn = [self viewWithTag:index.integerValue + kSFTagBtnViewBtnTagPlus];
        [self btnAction:btn];
    }
}

- (void)btnAction:(UIButton *)btn
{
    NSInteger index = btn.tag - kSFTagBtnViewBtnTagPlus;
    
    if (self.isSingle) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(SFTagBtnViewClickIndex:lastClickIndex:)]) {
            [self.delegate SFTagBtnViewClickIndex:index lastClickIndex:self.lastIndex];
        }
        
        UIButton *lastBtn = [self viewWithTag:self.lastIndex + kSFTagBtnViewBtnTagPlus];
        [self unSelectBtn:lastBtn];
        
        [self selectBtn:btn];
        
        self.lastIndex = index;
    } else {
        
        NSString *indexStr = [NSString stringWithFormat:@"%ld", (long)index];
        
        if (self.selectArr.count == 0) {
            [self.selectArr addObject:indexStr];
            [self selectBtn:btn];
        } else if ([self.selectArr containsObject:indexStr]) {
            //包含 移除
            [self.selectArr removeObject:indexStr];
            [self unSelectBtn:btn];
        } else {
            //不包含 添加
            [self.selectArr addObject:indexStr];
            [self selectBtn:btn];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(SFTagBtnViewSelectIndexes:)]) {
            [self.delegate SFTagBtnViewSelectIndexes:self.selectArr];
        }
        
    }
    
}

- (void)selectBtn:(UIButton *)btn
{
    btn.selected = YES;
}

- (void)unSelectBtn:(UIButton *)btn
{
    btn.selected = NO;
}
//根据颜色返回图片
- (UIImage *)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
