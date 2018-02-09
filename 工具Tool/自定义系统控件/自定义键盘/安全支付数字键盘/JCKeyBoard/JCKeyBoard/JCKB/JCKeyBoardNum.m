//
//  JCKeyBoardNum.m
//  JCKeyBoard
//
//  Created by QB on 16/4/26.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "JCKeyBoardNum.h"



#define clearColor  [UIColor clearColor]
#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

#define keyHeight  250

@interface JCKeyBoardNum ()
/**
 *  初始化方法
 */

- (instancetype)initWithFrame:(CGRect)frame;


/**
 *
 */

+ (instancetype)ShowWithFrame:(CGRect)frame;

///键盘数组

@property (nonatomic, strong) NSArray *numArray;

@end

@implementation JCKeyBoardNum

//懒加载
- (NSArray *)numArray {
    if (!_numArray) {
        self.numArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    }
    
    return _numArray;
}

//显示

+ (instancetype)allocNew {
    return [self new];
}

+ (instancetype)ShowWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}


// 工厂方法

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = clearColor;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        self.frame = CGRectMake(0, ScreenHeight - keyHeight , ScreenWidth, keyHeight);
    }
    return self;
}
- (void)show{
    //创建数字键盘
    [self setupNumKeyBoard];
}
//创建NumKeyBoard

- (void)setupNumKeyBoard {
    
    NSMutableArray *numArray = [NSMutableArray arrayWithArray:self.numArray];
    int row = 4;
    int coloumn = 3;
    CGFloat keyWidth = self.frame.size.width / coloumn;
    CGFloat keyNewHeight = self.frame.size.height / row;
    
    int normol;
    if (self.isNormolNumber) {
        normol = 1;
    } else {
        normol = 0;
    }
    
    for (int i = 0; i < 12; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i % coloumn *keyWidth, i / coloumn *keyNewHeight, keyWidth, keyNewHeight)];
        button.tag = i;
        //设置背景图
        [button setBackgroundImage:[JCKeyBoardNum imageWithColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1.0]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
        
        if (normol) {
            NSArray *NumberArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
            if (i == 9 || i == 10 || i == 11) {
                button.backgroundColor = [UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1];
                [button setBackgroundImage:[JCKeyBoardNum imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
                button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
                if (i == 9) {
                    [button setTitle:@"完成" forState:UIControlStateNormal];
                } else if (i == 10) {
                    [button setTitle:@"0" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"删除" forState:UIControlStateNormal];
                }
            } else {
                button.backgroundColor = [UIColor whiteColor];
                [button setBackgroundImage:[JCKeyBoardNum imageWithColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1]] forState:UIControlStateHighlighted];
                [button setTitle:[NumberArray objectAtIndex:i]forState:UIControlStateNormal];
            }
        } else {//随机数字键盘
            if (i == 9 || i == 11) {
                button.backgroundColor = [UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1];
                [button setBackgroundImage:[JCKeyBoardNum imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
                button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
                if (i == 9) {
                    [button setTitle:@"完成" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"删除" forState:UIControlStateNormal];
                }
            } else {
                button.backgroundColor = [UIColor whiteColor];
                [button setBackgroundImage:[JCKeyBoardNum imageWithColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1]] forState:UIControlStateHighlighted];
                int loc = arc4random_uniform((int)numArray.count);
                [button setTitle:[numArray objectAtIndex:loc]forState:UIControlStateNormal];
                [numArray removeObjectAtIndex:loc];
            }
        }
        
        
        //创建划线
        CGFloat lineW = self.frame.size.width;
        CGFloat lineH = self.frame.size.height;
        for (int i = 0; i < row - 1; i++) {
            UIView *lineView = [UIView new];
            lineView.frame = CGRectMake(0, keyNewHeight * (i + 1), lineW, 1);
            lineView.backgroundColor = [UIColor grayColor];
            [self addSubview:lineView];
        }
        
        for (int i = 0; i < coloumn - 1; i++) {
            UIView *lineView = [UIView  new];
            lineView.frame = CGRectMake(keyWidth * (i + 1), 0, 1, lineH);
            lineView.backgroundColor = [UIColor grayColor];
            [self addSubview:lineView];
        }
        
    }
    
}

///绘制的图
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 按钮的点击事件

- (void)clickBtn:(UIButton *)sender {
    if (self.completeBlock) {
        self.completeBlock(sender.titleLabel.text,sender.tag);
    }
}

//隐藏键盘

- (void)dismiss {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


@end
