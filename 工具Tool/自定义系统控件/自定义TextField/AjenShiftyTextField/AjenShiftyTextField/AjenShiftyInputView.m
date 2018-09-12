//
//  AjenShiftyInputView.m
//  AjenShiftyTextField
//
//  Created by Ajen on 2018/8/13.
//  Copyright © 2018年 Ajen. All rights reserved.
//

#import "AjenShiftyInputView.h"

@implementation AjenShiftyInputView{
    CAShapeLayer * animLayer;
    CAShapeLayer * animLayer_wordNumber;
    UILabel * wordNumberLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat referenceHeight = frame.size.height - 10;
        CGFloat goldHeight = frame.size.height * 0.6180339887;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,(frame.size.height - goldHeight) / 2, goldHeight, goldHeight)];
        [self addSubview:self.iconImageView];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 5, 5, frame.size.width - (self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 5) - 5, referenceHeight)];
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeyDone;
        [self.textField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:self.textField];
        
        wordNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, self.frame.size.height - 10, 55, 10)];
        wordNumberLabel.text = @"Min/Max";
        wordNumberLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightThin];
        wordNumberLabel.textAlignment = 2;
        wordNumberLabel.alpha = 0;
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(self.finishDoneBlock){
        self.finishDoneBlock(self, self.textField.text);
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(self.beginEditBlock){
        self.beginEditBlock(self, self.textField.text);
    }
    [animLayer removeFromSuperlayer];
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(0, 0);
    [path moveToPoint:startPoint];


    CGPoint endPoint = CGPointMake(self.frame.size.width, 0);
    CGPoint controlPoint1 = CGPointMake(0, 0);
    CGPoint controlPoint2 = CGPointMake(0, 0);
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    [path moveToPoint:endPoint];


    CGPoint endPoint2 = CGPointMake(self.frame.size.width, self.frame.size.height);
    CGPoint controlPoint3 = CGPointMake(self.frame.size.width, self.frame.size.height);
    CGPoint controlPoint4 = CGPointMake(self.frame.size.width, self.frame.size.height);
    [path addCurveToPoint:endPoint2 controlPoint1:controlPoint3 controlPoint2:controlPoint4];
    [path moveToPoint:endPoint2];


    CGPoint endPoint3 = CGPointMake(0, self.frame.size.height);
    CGPoint controlPoint5 = CGPointMake(0, self.frame.size.height);
    CGPoint controlPoint6 = CGPointMake(0, self.frame.size.height);
    [path addCurveToPoint:endPoint3 controlPoint1:controlPoint5 controlPoint2:controlPoint6];
    [path moveToPoint:endPoint3];


    CGPoint endPoint4 = CGPointMake(0, 0);
    CGPoint controlPoint9 = CGPointMake(0, 0);
    CGPoint controlPoint10 = CGPointMake(0, 0);
    [path addCurveToPoint:endPoint4 controlPoint1:controlPoint9 controlPoint2:controlPoint10];
    [path moveToPoint:endPoint4];

    // 设置线断面类型
    path.lineCapStyle = kCGLineCapRound;
    // 设置连接类型
    path.lineJoinStyle = kCGLineJoinRound;

    animLayer = [CAShapeLayer layer];
    animLayer.path = path.CGPath;
    animLayer.lineWidth = 1.f;
    if(_borderLineColor){
        animLayer.strokeColor = _borderLineColor.CGColor;
    }else{
        animLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    }

    animLayer.fillColor = [UIColor clearColor].CGColor;
    animLayer.strokeStart = 0;
    animLayer.strokeEnd = 1.;
    [self.layer addSublayer:animLayer];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1.f);
    animation.duration = 1.5f;
    animation.removedOnCompletion = NO;
    animation.fillMode  = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.0 :0.0 :0.0 :0];

    [animLayer addAnimation:animation forKey:@"strokeEnd"];
    
    if(_isShowWordCount){
        [animLayer_wordNumber removeFromSuperlayer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIBezierPath * path_wordNumber = [UIBezierPath bezierPath];
            CGPoint startPoint_wordNumber = CGPointMake(self.frame.size.width - 70, self.frame.size.height);
            [path_wordNumber moveToPoint:startPoint_wordNumber];
            
            CGPoint endPoint_wordNumber = CGPointMake(self.frame.size.width - 60, self.frame.size.height - 10);
            CGPoint controlPoint1_wordNumber = CGPointMake(self.frame.size.width - 70, self.frame.size.height);
            CGPoint controlPoint2_wordNumber = CGPointMake(self.frame.size.width - 60, self.frame.size.height - 10);
            [path_wordNumber addCurveToPoint:endPoint_wordNumber controlPoint1:controlPoint1_wordNumber controlPoint2:controlPoint2_wordNumber];
            [path_wordNumber moveToPoint:endPoint_wordNumber];
            
            
            CGPoint endPoint2_wordNumber = CGPointMake(self.frame.size.width, self.frame.size.height - 10);
            CGPoint controlPoint3_wordNumber = CGPointMake(self.frame.size.width - 60, self.frame.size.height- 10);
            CGPoint controlPoint4_wordNumber = CGPointMake(self.frame.size.width, self.frame.size.height - 10);
            [path_wordNumber addCurveToPoint:endPoint2_wordNumber controlPoint1:controlPoint3_wordNumber controlPoint2:controlPoint4_wordNumber];
            [path_wordNumber moveToPoint:endPoint2_wordNumber];
            
            
            // 设置线断面类型
            path_wordNumber.lineCapStyle = kCGLineCapRound;
            // 设置连接类型
            path_wordNumber.lineJoinStyle = kCGLineJoinRound;
            
            self->animLayer_wordNumber = [CAShapeLayer layer];
            self->animLayer_wordNumber.path = path_wordNumber.CGPath;
            self->animLayer_wordNumber.lineWidth = 1.f;
            if(self->_borderLineColor){
                self->animLayer_wordNumber.strokeColor = self->_borderLineColor.CGColor;
            }else{
                self->animLayer_wordNumber.strokeColor = [UIColor lightGrayColor].CGColor;
            }
            
            self->animLayer_wordNumber.fillColor = [UIColor clearColor].CGColor;
            self->animLayer_wordNumber.strokeStart = 0;
            self->animLayer_wordNumber.strokeEnd = 1.;
            [self.layer addSublayer:self->animLayer_wordNumber];
            
            CABasicAnimation *animation_wordNumber = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation_wordNumber.fromValue = @(0);
            animation_wordNumber.toValue = @(1.f);
            animation_wordNumber.duration = 1.f;
            animation_wordNumber.removedOnCompletion = NO;
            animation_wordNumber.fillMode  = kCAFillModeForwards;
            animation_wordNumber.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.0 :0.0 :0.0 :0];
            
            [self->animLayer_wordNumber addAnimation:animation_wordNumber forKey:@"strokeEnd"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->wordNumberLabel.alpha = 1;
            });
        });
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.endEditBlock){
        self.endEditBlock(self, self.textField.text);
    }
    [animLayer removeFromSuperlayer];
    [animLayer_wordNumber removeFromSuperlayer];
    wordNumberLabel.alpha = 0;
}
-(void)textFieldChange{
    if(self.changeBlock){
        self.changeBlock(self, self.textField.text);
    }
    if(_maxWordNumber){
        if(self.textField.text.length <= _maxWordNumber){
            [self clearWarning];
            wordNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.textField.text.length,_maxWordNumber];
        }else{
            self.textField.text = [self.textField.text substringToIndex:_maxWordNumber];
            [self showWarning];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clearWarning];
            });
        }
    }
}

//设置icon图
-(void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    self.iconImageView.image = _iconImage;
}

//设置占位文本
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textField.placeholder = _placeholder;
}

//设置光标颜色
-(void)setCursorColor:(UIColor *)cursorColor{
    _cursorColor = cursorColor;
    self.textField.tintColor = _cursorColor;
}

-(void)setBorderLineColor:(UIColor *)borderLineColor{
    _borderLineColor = borderLineColor;
}

//设置是否显示清除按钮
-(void)setIsShowClearButton:(BOOL)isShowClearButton{
    _isShowClearButton = isShowClearButton;
    if(_isShowClearButton){
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.textField.clearButtonMode = UITextFieldViewModeNever;
    }
}

///设置最大数的文本是否显示
-(void)setIsShowWordCount:(BOOL)isShowWordCount{
    _isShowWordCount = isShowWordCount;
    if(isShowWordCount){
        if(![self.subviews containsObject:wordNumberLabel]){
            [self addSubview:wordNumberLabel];
        }
    }else{
        [wordNumberLabel removeFromSuperview];
    }
}

///设置文字最大数
-(void)setMaxWordNumber:(NSInteger)maxWordNumber{
    if(maxWordNumber < 1){
        NSString * str = [NSString stringWithFormat:@"%s %d 文字最大数要大于或等于1",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__];
        NSAssert(maxWordNumber > 0, str);
        return;
    }
    _maxWordNumber = maxWordNumber;
    wordNumberLabel.text = [NSString stringWithFormat:@"0/%ld",_maxWordNumber];
}



///显示警告
-(void)showWarning{
    //红色
    animLayer.strokeColor = [UIColor redColor].CGColor;
    if(_isShowWordCount){
        animLayer_wordNumber.strokeColor = [UIColor redColor].CGColor;
    }
    
    //原色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.textField.text.length < self->_maxWordNumber){
            return ;
        }
        if(self->_borderLineColor){
            self->animLayer.strokeColor = self->_borderLineColor.CGColor;
            if(self->_isShowWordCount){
                self->animLayer_wordNumber.strokeColor = self->_borderLineColor.CGColor;
            }
        }else{
            self->animLayer.strokeColor = [UIColor lightGrayColor].CGColor;
            if(self->_isShowWordCount){
                self->animLayer_wordNumber.strokeColor = [UIColor lightGrayColor].CGColor;
            }
        }
        
        //红色
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.textField.text.length < self->_maxWordNumber){
                return ;
            }
            self->animLayer.strokeColor = [UIColor redColor].CGColor;
            if(self->_isShowWordCount){
                self->animLayer_wordNumber.strokeColor = [UIColor redColor].CGColor;
            }
            
            //原色
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(self.textField.text.length < self->_maxWordNumber){
                    return ;
                }
                if(self->_borderLineColor){
                    self->animLayer.strokeColor = self->_borderLineColor.CGColor;
                    if(self->_isShowWordCount){
                        self->animLayer_wordNumber.strokeColor = self->_borderLineColor.CGColor;
                    }
                }else{
                    self->animLayer.strokeColor = [UIColor lightGrayColor].CGColor;
                    if(self->_isShowWordCount){
                        self->animLayer_wordNumber.strokeColor = [UIColor lightGrayColor].CGColor;
                    }
                }
                
                //红色
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(self.textField.text.length < self->_maxWordNumber){
                        return ;
                    }
                    self->animLayer.strokeColor = [UIColor redColor].CGColor;
                    if(self->_isShowWordCount){
                        self->animLayer_wordNumber.strokeColor = [UIColor redColor].CGColor;
                    }
                });
            });
        });
    });
}

///消除警告
-(void)clearWarning{
    if(self->animLayer.strokeColor == [UIColor redColor].CGColor){
        if(_borderLineColor){
            animLayer.strokeColor = _borderLineColor.CGColor;
            if(_isShowWordCount){
                animLayer_wordNumber.strokeColor = _borderLineColor.CGColor;
            }
        }else{
            animLayer.strokeColor = [UIColor lightGrayColor].CGColor;
            if(_isShowWordCount){
                animLayer_wordNumber.strokeColor = [UIColor lightGrayColor].CGColor;
            }
        }
    }
}

@end
