//
//  QQHelperSettingWindow.m
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/14.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import "QQHelperSettingWindow.h"

@interface  QQHelperSettingWindow()
@property (strong, nonatomic) QQHelperSegmentedControl *segmentedCr;
@property (strong, nonatomic) RedPackView *redPackSettingView;
@property (strong, nonatomic) OtherView *otherSettingView;
@end

@implementation QQHelperSettingWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    if (self != nil) {
        [self subviewsInit];
        [self addConstraints];
    }
    return self;
}

- (void)subviewsInit {
    self.segmentedCr = [QQHelperSegmentedControl segmentedControlWithLabels:@[@"红包设置",@"其他设置"] trackingMode:NSSegmentSwitchTrackingSelectOne target:self action:NSSelectorFromString(@"selectSegmentCr:")];
    [self.segmentedCr workInit];
    [self.contentView addSubview:self.segmentedCr];

    self.redPackSettingView = [[RedPackView alloc] initWithFrame:NSZeroRect];
    self.redPackSettingView.hidden = NO;

    self.otherSettingView = [[OtherView alloc] initWithFrame:NSZeroRect];
    self.otherSettingView.hidden = YES;

    [self.contentView addSubview:self.redPackSettingView];
    [self.contentView addSubview:self.otherSettingView];

}

- (void)addConstraints {
    [self.segmentedCr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(10);
        make.centerX.mas_equalTo(self.contentView);
    }];
    __weak typeof(self) weakSelf = self;
    [self.redPackSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.segmentedCr.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-10);
    }];
    
    [self.otherSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.redPackSettingView).with.insets(NSEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)selectSegmentCr:(QQHelperSegmentedControl *)Cr {
    if (Cr.selectedSegment == 0) {
        self.redPackSettingView.hidden = NO;
        self.otherSettingView.hidden = YES;
    } else {
        self.redPackSettingView.hidden = YES;
        self.otherSettingView.hidden = NO;
    }
}

@end
