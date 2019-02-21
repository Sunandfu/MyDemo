//
//  PGIndexNormalBanner.h
//  NJPalmBus
//
//  Created by Min Lin on 2018/10/16.
//  Copyright © 2018 Jsbc. All rights reserved.
//

#import "PGIndexBannerSubiew.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGIndexNormalBanner : PGIndexBannerSubiew

@property (nonatomic, strong, readonly) UILabel *pageIndicatorLabel;

+ (NSAttributedString *)attributedTextWithCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage;

@end

NS_ASSUME_NONNULL_END
