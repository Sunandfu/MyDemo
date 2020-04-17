//
//  YXLoading.m
//  fitness
//
//  Created by 帅 on 2017/1/4.
//  Copyright © 2017年 YunXiang. All rights reserved.
//

#import "YXLoading.h"
#import "YXLaunchAdConst.h"
#define showtime 2.0
@interface YXLoading ()

@property (nonatomic,strong) UILabel * tipLab;

@property (nonatomic,strong) NSTimer * timer;

@property (nonatomic,assign) NSInteger count;

@end

@implementation YXLoading

+ (YXLoading *)defaultLoading
{
    static YXLoading * loading = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loading = [[YXLoading alloc]initWithFrame:[UIScreen mainScreen].bounds];
    });
    return loading;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self addSubview:self.tipLab];
    [self.timer setFireDate:[NSDate distantFuture]];
    _count = 0;
    
    return self;
}

- (UILabel *)tipLab
{
    if (!_tipLab) {
        _tipLab = ({
            UILabel * label = [UILabel new];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 4;
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
    }
    return _tipLab;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

+ (void)showStatus:(NSString *)str
{
    [self showStatus:str delay:showtime];
}

+ (void)showStatus:(NSString *)str delay:(CGFloat)delay
{
    [self dissmissProgress];
    
    [self defaultLoading].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    [[self defaultLoading] fitLabelSizeWithStr:str bottom:YES];
    
    [self show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dissmissProgress];
    });
}

+ (void)showMiddleStatus:(NSString *)str
{
    [self dissmissProgress];
    
    [self defaultLoading].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    [[self defaultLoading] fitLabelSizeWithStr:str bottom:NO];
    
    [self show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(showtime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dissmissProgress];
    });
}

+ (void)showProgress
{
    [self showWithStatus:@"加载中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dissmissProgress];
    });
}
/**
 有加载框 需手动消失
 */
+ (void)showWithStatus:(NSString *)str
{
    [self dissmissProgress];
    
    [self defaultLoading].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [[self defaultLoading] fitLabelSizeWithStr:[str stringByAppendingString:@"..."] bottom:NO];
    
    [self show];
    [[self defaultLoading].timer setFireDate:[NSDate distantPast]];
}

- (void)fitLabelSizeWithStr:(NSString *)str bottom:(BOOL)bottom
{
    _tipLab.text = str;
    _tipLab.frame = ({
        CGRect frame;
        CGSize maximumLabelSize = CGSizeMake(260, 9999);
        CGSize expectSize = [_tipLab sizeThatFits:maximumLabelSize];
        CGFloat labW = expectSize.width + 60;
        labW = labW > 120 ? labW : 120;
        CGFloat labH = expectSize.height + 30;
        labH = labH > 50 ? labH : 50;
        frame = CGRectMake(0, 0, labW, labH);
        frame;
    });
    _tipLab.center = CGPointMake(SF_ScreenW/2.0, bottom ? SF_ScreenH*4.0/5.0 : SF_ScreenH/2.0);
}

+ (void)dissmissProgress
{
    [[self defaultLoading] removeFromSuperview];
    [[self defaultLoading].timer setFireDate:[NSDate distantFuture]];
}

+ (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:[self defaultLoading]];
}

- (void)refresh
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:self.tipLab.text];
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(self.tipLab.text.length-3+_count%3,1)];
    [self.tipLab setAttributedText:attrString];
    _count ++;
}

@end
