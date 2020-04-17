//
//  PGIndexNormalBanner.m
//  NJPalmBus
//
//  Created by Min Lin on 2018/10/16.
//  Copyright © 2018 Jsbc. All rights reserved.
//

#import "PGIndexNormalBanner.h"
#import "SJAttributeWorker.h"

@interface PGIndexNormalBanner ()
@property (nonatomic, strong, readwrite) UILabel *pageIndicatorLabel;
@end

@implementation PGIndexNormalBanner

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pageIndicatorLabel];
    }
    return self;
}

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
    self.pageIndicatorLabel.right = superViewBounds.size.width - 10.0;
    self.pageIndicatorLabel.bottom = superViewBounds.size.height - 9.0;
}

- (UILabel *)pageIndicatorLabel {
    if (!_pageIndicatorLabel) {
        _pageIndicatorLabel = [UILabel new];
        _pageIndicatorLabel.size = CGSizeMake(60.0, 20.0);
        _pageIndicatorLabel.textAlignment = NSTextAlignmentRight;
    }
    return _pageIndicatorLabel;
}

+ (NSAttributedString *)attributedTextWithCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage {
    NSAttributedString *attributedText = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
        NSString *currentPageText = [NSString stringWithFormat:@"%d", (int)currentPage];
        NSString *totalPageText = [NSString stringWithFormat:@"/%d", (int)totalPage];
        make.append(currentPageText).font([UIFont boldSystemFontOfSize:16.0]).textColor([UIColor whiteColor]);
        make.append(totalPageText).font([UIFont systemFontOfSize:13.0]).textColor([UIColor colorWithWhite:1.0 alpha:0.8]);
    });
    return attributedText;
}

@end
