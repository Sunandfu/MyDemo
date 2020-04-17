//
//  YXFeedAdRegisterView.m
//  LunchAd
//
//  Created by shuai on 2018/10/15.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXFeedAdRegisterView.h"

@implementation YXFeedAdRegisterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.infoBtn.layer.masksToBounds = YES; 
        self.infoBtn.layer.borderColor =  [UIColor colorWithRed:208/255.0 green:0 blue:0 alpha:1].CGColor;
    self.infoBtn.layer.borderWidth = 1;
    self.infoBtn.layer.cornerRadius = 4;
}


@end
