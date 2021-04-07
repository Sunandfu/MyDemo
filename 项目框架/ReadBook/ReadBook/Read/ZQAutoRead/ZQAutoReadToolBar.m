//
//  ZQAutoReadToolBar.m
//  ZQAutoReadBook
//
//  Created by zzq on 2018/9/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQAutoReadToolBar.h"
#import "NSObject+FBKVOController.h"
#import "FBKVOController.h"

@interface ZQAutoReadToolBar()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *botView;

@property (weak, nonatomic) IBOutlet UIButton *speedSlowBtn;
@property (weak, nonatomic) IBOutlet UIButton *speedUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *endAutoReadBtn;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@end

@implementation ZQAutoReadToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.KVOController observe:self keyPath:@"speed" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, ZQAutoReadToolBar *object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (object.speed <= 1) {
            self.speedSlowBtn.enabled = NO;
            self.speedUpBtn.enabled = YES;
        }
        else if(object.speed >= 10) {
            self.speedSlowBtn.enabled = YES;
            self.speedUpBtn.enabled = NO;
        }
        else {
            self.speedSlowBtn.enabled = YES;
            self.speedUpBtn.enabled = YES;
        }
    }];
}

- (IBAction)slowBtnClicked:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(speedLow:)]) {
        self.speed --;
        self.speedLabel.text = [NSString stringWithFormat:@"%d",(int)_speed];
        [_delegate speedLow:_speed];
    }
}

- (IBAction)upBtnClicked:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(speedUp:)]) {
        self.speed ++;
        self.speedLabel.text = [NSString stringWithFormat:@"%d",(int)_speed];
        [_delegate speedUp:_speed];
    }
}

- (IBAction)endAutoBtnClicked:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(endAutoRead)]) {
        [_delegate endAutoRead];
    }
}

- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
    self.speedLabel.text = [NSString stringWithFormat:@"%d",(int)_speed];
}

@end
