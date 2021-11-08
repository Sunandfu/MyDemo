//
//  RedPackView.m
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/14.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import "RedPackView.h"

@implementation RedPackView {
    NSTextField *fromTxt;
    NSTextField *toTxt;
    NSTextField *timeText;
    NSTextField *lineText;
    NSButton *updateRedTimeBtn;
    
    NSBox *hLine;
    
    NSTextField *filterLable;
    NSTextField *inputFilterTxt;
    NSButton *updateFilterBtn;
    
    NSBox *hLine2;
    
    NSButton *grabPersonRedPacBtn;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        [self subviewInit];
        [self addConstraintInit];
    }
    return self;
}

- (void)subviewInit {
    
    // 第一排红包延迟时间配置
    {
        timeText = [NSTextField labelWithString:@"抢红包延迟时间："];
        [self addSubview:timeText];
    }
    
    {
        fromTxt = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [fromTxt sizeToFit];
        fromTxt.placeholderString = @"最小值";
        NSInteger start = [[QQHelperSetting sharedInstance] startTime];
        [fromTxt setStringValue:[NSString stringWithFormat:@"%d",start]];
        [self addSubview:fromTxt];
    }
    
    {
        lineText = [NSTextField labelWithString:@"至"];
        [self addSubview:lineText];
    }
    
    {
        toTxt = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [toTxt sizeToFit];
        toTxt.placeholderString = @"最大值";
        NSInteger end = [[QQHelperSetting sharedInstance] endTime];
        [toTxt setStringValue:[NSString stringWithFormat:@"%d",end]];
        [self addSubview:toTxt];
    }
    
    {
        updateRedTimeBtn = [NSButton buttonWithTitle:@"更新" target:self action:NSSelectorFromString(@"updateRedTimeConfig:")];
        [updateRedTimeBtn sizeToFit];
        [self addSubview:updateRedTimeBtn];
    }
    
    // 分隔线
    {
        hLine = [[NSBox alloc] init];
        [hLine setTitlePosition:NSNoTitle];
        [hLine setBoxType:NSBoxCustom];
        [hLine setBorderColor:[NSColor grayColor]];
        [self addSubview:hLine];
    }
    
    // 第二排关键字过滤配置
    
    {
        filterLable = [NSTextField labelWithString:@"包含以下关键字不抢："];
        [self addSubview:filterLable];
    }
    
    {
        inputFilterTxt = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [inputFilterTxt sizeToFit];
        inputFilterTxt.font = [NSFont systemFontOfSize:14];
        NSString *keyword = [[QQHelperSetting sharedInstance] filterKeyword];
        inputFilterTxt.stringValue = keyword ? keyword : @"";
        inputFilterTxt.placeholderString = @"关键字之间用逗号分隔";
        [self addSubview:inputFilterTxt];
    }
    
    {
        updateFilterBtn = [NSButton buttonWithTitle:@"更新" target:self action:NSSelectorFromString(@"updateFilterConfig:")];
        [updateFilterBtn sizeToFit];
        [self addSubview:updateFilterBtn];
    }
    
    // 分隔线2
    {
        hLine2 = [[NSBox alloc] init];
        [hLine2 setTitlePosition:NSNoTitle];
        [hLine2 setBoxType:NSBoxCustom];
        [hLine2 setBorderColor:[NSColor grayColor]];
        [self addSubview:hLine2];
    }
    
    // 第三排
    {
        grabPersonRedPacBtn = [NSButton checkboxWithTitle:@"是否抢个人红包" target:self action:NSSelectorFromString(@"updatePersonRedPac:")];
        if ([[QQHelperSetting sharedInstance] isPersonRedPackage]) {
            grabPersonRedPacBtn.state = NSControlStateValueOn;
        } else {
            grabPersonRedPacBtn.state = NSControlStateValueOff;
        }
        [grabPersonRedPacBtn sizeToFit];
        [self addSubview:grabPersonRedPacBtn];
    }
}

- (void)addConstraintInit {
    
    [timeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(20);
        make.top.mas_equalTo(self.mas_top).with.offset(20);
    }];
    
    [fromTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeText.mas_right).with.offset(4);
        make.bottom.mas_equalTo(timeText.mas_bottom);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(20);
    }];
    
    [lineText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fromTxt.mas_right).with.offset(10);
        make.bottom.mas_equalTo(fromTxt.mas_bottom);
    }];

    [toTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineText.mas_right).with.offset(10);
        make.bottom.mas_equalTo(fromTxt.mas_bottom);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(20);
    }];
    
    [updateRedTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-20);
        make.bottom.mas_equalTo(toTxt.mas_bottom);
    }];
    
    // 分隔线
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeText.mas_bottom).with.offset(24);
        make.height.mas_equalTo(2);
        make.left.mas_equalTo(timeText.mas_left);
        make.right.mas_equalTo(self.mas_right).with.offset(-20);
    }];
    
    // 第二排
    [filterLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hLine.mas_bottom).with.offset(20);
        make.left.mas_equalTo(hLine.mas_left);
    }];
    
    [inputFilterTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(filterLable.mas_left);
        make.top.mas_equalTo(filterLable.mas_bottom).with.offset(10);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(24);
    }];
    
    [updateFilterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(inputFilterTxt.mas_centerY);
    }];
    
    [hLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputFilterTxt.mas_bottom).with.offset(24);
        make.height.mas_equalTo(2);
        make.left.mas_equalTo(filterLable.mas_left);
        make.right.mas_equalTo(self.mas_right).with.offset(-20);
    }];
    
    [grabPersonRedPacBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hLine2.mas_bottom).with.offset(24);
        make.left.mas_equalTo(filterLable.mas_left);
    }];

}

- (void)updateRedTimeConfig:(NSButton *)btn {
    if ([fromTxt.stringValue isEqualToString:@""] || [toTxt.stringValue isEqualToString:@""]) {
        return;
    }
    if ([fromTxt.stringValue integerValue] > [toTxt.stringValue integerValue]) {
        [[QQHelperSetting sharedInstance] showWarnMessage:@"错误：设置的延迟时间-最小值不能比最大值还大"];
        return;
    }
    [[QQHelperSetting sharedInstance] setStartTime:[fromTxt.stringValue integerValue]];
    [[QQHelperSetting sharedInstance] setEndTime:[toTxt.stringValue integerValue]];
    [[QQHelperSetting sharedInstance] showMessage:@"红包延迟时间更新成功"];
}

- (void)updateFilterConfig:(NSButton *)btn {
    if ([inputFilterTxt.stringValue isEqualToString:@""]) {
        return;
    }
    [[QQHelperSetting sharedInstance] setFilterKeyword:inputFilterTxt.stringValue];
    [[QQHelperSetting sharedInstance] showMessage:@"过滤关键字更新成功"];
}

- (void)updatePersonRedPac:(NSButton *)btn {
    if (grabPersonRedPacBtn.state == NSControlStateValueOff) {
        [[QQHelperSetting sharedInstance] setIsPersonRedPackage:NO];
    } else {
        [[QQHelperSetting sharedInstance] setIsPersonRedPackage:YES];
    }
}

@end
