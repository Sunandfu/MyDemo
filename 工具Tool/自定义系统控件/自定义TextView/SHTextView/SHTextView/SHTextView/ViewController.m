//
//  ViewController.m
//  SHTextView
//
//  Created by 宋浩文的pro on 16/4/12.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "ViewController.h"
#import "SHTextView.h"

@interface ViewController ()<SHTextViewDelegate>

@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) SHTextView *textVw;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SHTextView *textView = [[SHTextView alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16];
    textView.placeholder = @"说点啥吧...";
    textView.placeholderLocation = CGPointMake(10, 10);
    /** 是否可以伸缩 */
    textView.isCanExtend = YES;
    /** 伸缩行数 */
    textView.extendLimitRow = 4;
    /** 伸缩方向 */
    textView.extendDirection = ExtendDown;
    textView.layer.borderWidth = 1;
    self.textVw = textView;
    [self.view addSubview:textView];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setTitle:@"*" forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [clearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    clearButton.frame = CGRectMake(textView.bounds.size.width-20, textView.bounds.size.height/2-7.5, 15, 15);
    [clearButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn = clearButton;
    self.clearBtn.hidden = YES;
    [textView addSubview:clearButton];
}
- (void)SHTextView:(SHTextView *)SHTextView textDidChanged:(NSString *)text{
    if (text.length>0) {
        self.clearBtn.hidden = NO;
        self.clearBtn.frame = CGRectMake(SHTextView.bounds.size.width-20, SHTextView.bounds.size.height/2-7.5, 15, 15);
    }
}
- (void)clearText{
    NSLog(@"清空文字");
    self.textVw.text = @"";
}
@end
