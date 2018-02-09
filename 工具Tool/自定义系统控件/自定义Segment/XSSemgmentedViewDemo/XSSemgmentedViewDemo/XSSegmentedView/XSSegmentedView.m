//
//  XSSegmentedView.m
//  
//
//  Created by Xaofly Sho on 16/1/25.
//  Copyright © 2016年 Xaofly Sho. All rights reserved.
//

#import "XSSegmentedView.h"

//RGBColor
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/225.0 green:(g)/225.0 blue:(b)/225.0 alpha:(a)]

@interface XSSegmentedView () {
    
    CGFloat labelWidht;
    CGFloat labelHeight;
    NSInteger titleNumber;
    NSInteger lastSelectNumber;
}

@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *topLabelView;
@property (nonatomic, strong) NSMutableArray *botLabelArray;
@property (nonatomic, strong) NSMutableArray *topLabelArray;

@end

@implementation XSSegmentedView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        
        [self baseInit];
        [self setTitles:titles];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    
    if (self = [super initWithFrame:frame]) {
        
        [self baseInit];
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self baseInit];
        
    }
    
    return self;
}

- (void)baseInit {
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [self.tintColor CGColor];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    
    self.botLabelArray = [[NSMutableArray alloc]init];
    self.topLabelArray = [[NSMutableArray alloc]init];
    
    _titles = @[@"First",@"Second"];
    
    [self setSubViewWithTitles:_titles];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)setTitles:(NSArray *)titles {
    
    _titles = titles;
    
    [self setSubViewWithTitles:titles];
    
}

- (void)setSubViewWithTitles:(NSArray *)titles {
    
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    titleNumber = self.titles.count;
    labelWidht = self.frame.size.width / titleNumber;
    labelHeight = self.frame.size.height;
    
    [self.botLabelArray removeAllObjects];
    
    for (int i = 0; i < titleNumber; i ++) {
        
        UILabel *titleLabel = [self labelWithFrame:CGRectMake(i * (labelWidht), 0, labelWidht, labelHeight) text:titles[i] textColor:self.tintColor];
        
        [self.botLabelArray addObject:titleLabel];
        
        [self addSubview:titleLabel];
        
    }
    
        self.shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelWidht, labelHeight)];
        self.shadeView.backgroundColor = self.tintColor;
        self.shadeView.clipsToBounds = YES;
        self.shadeView.layer.cornerRadius = 4;
    
    [self addSubview:self.shadeView];
    
    self.topLabelView = [[UIView alloc]initWithFrame:self.bounds];
    self.topLabelView.backgroundColor = [UIColor clearColor];
    
    [self.shadeView addSubview:self.topLabelView];
    
    [self.topLabelArray removeAllObjects];
    
    for (int i = 0; i < titleNumber; i ++) {
        
        UILabel *titleLabel = [self labelWithFrame:CGRectMake(i * (labelWidht), 0, labelWidht, labelHeight) text:titles[i] textColor:[UIColor whiteColor]];
        
        [self.topLabelArray addObject:titleLabel];
        
        [self.topLabelView addSubview:titleLabel];
    }
    
    for (int i = 0; i < titleNumber; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * (labelWidht), 0, labelWidht, labelHeight);
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
    }
    
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor {
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:frame];
    
    titleLabel.text = text;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = textColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    
    return titleLabel;
}

- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    
    for (UILabel *label in self.botLabelArray) {
        
        label.textColor = textColor;
        
    }
    
    self.shadeView.backgroundColor = textColor;
    self.layer.borderColor = [textColor CGColor];
}

- (void)setViewColor:(UIColor *)viewColor {
    
    _viewColor = viewColor;
    
    self.backgroundColor = viewColor;
    
    for (UILabel *label in self.topLabelArray) {
        
        if (viewColor != [UIColor clearColor]) {
            
            label.textColor = viewColor;
        }
    }
}

- (void)setSelectNumber:(NSInteger)selectNumber {
    
    if (selectNumber >= titleNumber) {
        
        selectNumber = titleNumber - 1;
        
    }
    
    _selectNumber = selectNumber;
    
    
    if ([_delegate respondsToSelector:@selector(xsSegmentedView:didSelectTitleInteger:)]) {
        BOOL isSelect = [_delegate xsSegmentedView:self didSelectTitleInteger:selectNumber];
        
        if (isSelect) {
            
            lastSelectNumber = selectNumber;
            
        }
        
    }else{
        
        lastSelectNumber = selectNumber;
        
    }
    
    [self selectTitleWithInteger:selectNumber];
    
    if ([_delegate respondsToSelector:@selector(xsSegmentedView:selectTitleInteger:)]) {
        [_delegate xsSegmentedView:self selectTitleInteger:self.selectNumber];
    }
    
}

- (void)setSelectNumber:(NSInteger)selectNumber animate:(BOOL)animate {
    
    if (animate) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.selectNumber = selectNumber;
            
        }];
        
    }else{
        
        self.selectNumber = selectNumber;
        
    }
    
}

- (void)buttonClick:(UIButton *)sender {
    
    long select = sender.tag;
    
    if ([_delegate respondsToSelector:@selector(xsSegmentedView:didSelectTitleInteger:)]) {
        BOOL isSelect = [_delegate xsSegmentedView:self didSelectTitleInteger:select];

        if (isSelect) {
            
            lastSelectNumber = select;
            
        }
        
    }else{
        
        lastSelectNumber = select;
    
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self selectTitleWithInteger:select];
        
    }];
    
    if ([_delegate respondsToSelector:@selector(xsSegmentedView:selectTitleInteger:)]) {
        [_delegate xsSegmentedView:self selectTitleInteger:self.selectNumber];
    }
    
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    
    CGPoint pt = [sender translationInView:self];
    
    CGPoint shadeViewCenter = self.shadeView.center;
    CGPoint topLabelViewCenter = self.topLabelView.center;
    
    shadeViewCenter.x += pt.x;
    topLabelViewCenter.x -= pt.x;
    
    if (shadeViewCenter.x < 0)
    {
        shadeViewCenter.x = 0 ;
        topLabelViewCenter.x = labelWidht / 2 + self.frame.size.width / 2;
    }
    
    if (shadeViewCenter.x > self.frame.size.width - 1)
    {
        shadeViewCenter.x = self.frame.size.width - 1;
        topLabelViewCenter.x = - self.frame.size.width / 2 + labelWidht / 2 + 1;
    }
    
    self.shadeView.center = shadeViewCenter;
    self.topLabelView.center = topLabelViewCenter;

    if (sender.state == UIGestureRecognizerStateEnded) {
        
        int select = shadeViewCenter.x / labelWidht;
        
        if ([_delegate respondsToSelector:@selector(xsSegmentedView:didSelectTitleInteger:)]) {
            BOOL isSelect = [_delegate xsSegmentedView:self didSelectTitleInteger:select];

            if (isSelect) {
                
                lastSelectNumber = select;
                
            }
            
        }else{
            
            lastSelectNumber = select;
            
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self selectTitleWithInteger:select];
            
        }];
        
        if ([_delegate respondsToSelector:@selector(xsSegmentedView:selectTitleInteger:)]) {
            [_delegate xsSegmentedView:self selectTitleInteger:self.selectNumber];
        }
        
    }
    
    [sender setTranslation:CGPointZero inView:self];
}

- (void)selectTitleWithInteger:(NSInteger)integer {
    
    _selectNumber = integer;
    
    self.shadeView.frame = CGRectMake(integer * labelWidht, 0, labelWidht, labelHeight);
    self.topLabelView.frame = CGRectMake(- integer * labelWidht, 0, self.frame.size.width, self.frame.size.height);
    
}

@end
