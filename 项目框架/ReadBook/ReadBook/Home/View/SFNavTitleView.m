//
//  SFNavTitleView.m
//  ReadBook
//
//  Created by lurich on 2020/11/10.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFNavTitleView.h"

@implementation SFNavTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        self.autoresizesSubviews = YES;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.text = self.title;
        titleLabel.tag = 3;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:titleLabel];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    UILabel *titleLabel = [self viewWithTag:3];
    titleLabel.text = title;
}

@end
