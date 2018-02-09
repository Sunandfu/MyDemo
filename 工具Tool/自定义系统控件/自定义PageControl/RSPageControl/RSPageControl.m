//
//  RSPageControl.h
//
//
//  Created by hehai on 2016/5/28.
//  Copyright (c) 2016年 hehai. All rights reserved.
//  GitHub:https://github.com/riversea2015
//

#import "RSPageControl.h"

@interface RSPageControl ()

@property (nonatomic , strong)UIImage *normalDotImage;
@property (nonatomic , strong)UIImage *highlightedDotImage;
@property (nonatomic , assign)CGFloat dotLength;  // dot图片长度
@property (nonatomic , assign)CGFloat dotHeight;  // dot图片高度
@property (nonatomic , assign)CGFloat dotGap;     // dot图片间距

@end


@implementation RSPageControl {
    CGFloat tmpX; // 第一个点在self中的x坐标
    CGFloat tmpY; // 第一个点在self中的Y坐标
    NSInteger currentIndex; // 当前选中的下标
    CGRect tmpFrame; // pageControl的frame
}

- (id)initWithFrame:(CGRect)frame
        normalImage:(UIImage *)nImage
   highlightedImage:(UIImage *)hImage
         dotsNumber:(NSInteger)pageNum
          dotLength:(CGFloat)length
          dotHeight:(CGFloat)height
             dotGap:(CGFloat)gap {
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.dotGap = gap;
        self.dotLength = length;
        self.dotHeight = height;
        self.normalDotImage = nImage;
        self.highlightedDotImage = hImage;
        tmpFrame = frame;
        
        if (pageNum) {
            self.pageNumbers = pageNum;
        }
    }
    return self;
}

- (void)dotDidTouched:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(rs_pageControlDidStopAtIndex:)]) {
        
        [self setCurrentPage:[[sender view] tag] - 100];
        
        [_delegate rs_pageControlDidStopAtIndex:[[sender view] tag] - 100];
    }
}

- (void)setCurrentPage:(NSInteger)page {
    
    NSLog(@"%ld", (long)page);
    
    if (_normalDotImage || _highlightedDotImage) {
        for (int i = 0 ; i < _pageNumbers; i++) {
            
            UIImageView *dot = self.subviews[i];
            
            if (i == page) {
                
                dot.image = _highlightedDotImage;
            } else {
                
                dot.image = _normalDotImage;
            }
        }
        currentIndex = page;
    }
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (_normalDotImage || _highlightedDotImage) {
        for (int i = 0 ; i < _pageNumbers; i++) {
            
            UIImageView *dot = self.subviews[i];
            
            if (i == currentIndex) {
                
                dot.frame = CGRectMake(tmpX + (_dotGap + _dotHeight) * i, tmpY, _dotLength, _dotHeight);
            } else if(i < currentIndex) {
                
                dot.frame = CGRectMake(tmpX + (_dotGap + _dotHeight) * i, tmpY, _dotHeight, _dotHeight);
            } else {
                
                dot.frame = CGRectMake(tmpX + (_dotGap + _dotHeight) * (i - 1) + (_dotGap + _dotLength), tmpY, _dotHeight, _dotHeight);
            }
        }
    }
}

/**
 *  调用时机：
 *  ①在创建方法中为pageNumbers赋值；
 *  ②创建完成后，单独为PageNummbers赋值。
 *
 *  @param pageNumbers 总页数
 */
- (void)setPageNumbers:(NSInteger)pageNumbers {
    _pageNumbers = pageNumbers;
    
    CGFloat tmpWidth = (_pageNumbers - 1) * (_dotHeight + _dotGap) + _dotLength;
    tmpX = (tmpFrame.size.width - tmpWidth)/2;
    tmpY = (tmpFrame.size.height - _dotHeight)/2;
    
    for (int i = 0; i < _pageNumbers; i++) {
        UIImageView *dotView = [[UIImageView alloc] init];
        dotView.userInteractionEnabled = YES;
        
        dotView.frame = CGRectMake(tmpX + (_dotLength + _dotGap) * i, tmpY, _dotHeight, _dotHeight);
        
        if (i == 0) {
            dotView.frame = CGRectMake(tmpX, tmpY, _dotLength, _dotHeight);
        }
        
        dotView.tag = 100 + i;
        if (i == 0) {
            dotView.image = _highlightedDotImage;
        } else {
            dotView.image = _normalDotImage;
        }
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotDidTouched:)];
        [dotView addGestureRecognizer:gestureRecognizer];
        [self addSubview:dotView];
    }
    
    currentIndex = 0;
}

@end
