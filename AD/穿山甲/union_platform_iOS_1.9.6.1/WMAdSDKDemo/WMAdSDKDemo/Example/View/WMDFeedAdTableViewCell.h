//
//  WMDFeedAdCell.h
//  WMDemo
//
//  Created by carlliu on 2017/7/27.
//  Copyright © 2017年 bytedance. All rights reserved.
//


#import "WMDActionAreaView.h"
#import <Foundation/Foundation.h>
#import <WMAdSDK/WMNativeAd.h>
#import <WMAdSDK/WMNativeAdRelatedView.h>


@protocol WMDFeedCellProtocol <NSObject>

@property (nonatomic, strong) UIButton *customBtn; // 自定义按钮
@property (nonatomic, strong) WMNativeAd *nativeAd; // 自定义按钮
@property (nonatomic, strong) WMNativeAdRelatedView *nativeAdRelatedView; // 添加相关的展示控件

- (void)refreshUIWithModel:(WMNativeAd *_Nonnull)model;
+ (CGFloat)cellHeightWithModel:(WMNativeAd *_Nonnull)model width:(CGFloat)width;
@end


@interface WMDFeedAdBaseTableViewCell : UITableViewCell <WMDFeedCellProtocol>
@property (nonatomic, strong, nullable) UIImageView *iv1;
@property (nonatomic, strong, nullable) UILabel *adTitleLabel;
@property (nonatomic, strong, nullable) UILabel *adDescriptionLabel;
@property (nonatomic, strong) WMNativeAd *nativeAd;
@property (nonatomic, strong) UIButton *customBtn; // 自定义按钮
@property (nonatomic, strong) WMNativeAdRelatedView *nativeAdRelatedView;

- (void)buildupView;
@end

@interface WMDFeedAdLeftTableViewCell : WMDFeedAdBaseTableViewCell
@end

@interface WMDFeedAdLargeTableViewCell : WMDFeedAdBaseTableViewCell
@end

@interface WMDFeedVideoAdTableViewCell : WMDFeedAdBaseTableViewCell
/**
 创意按钮，视频广告使用，需要主动添加到 View，并注册该 view 用于响应用户点击
 */
@property (nonatomic, strong, nullable) UIButton *creativeButton;
@end

@interface WMDFeedAdGroupTableViewCell : WMDFeedAdBaseTableViewCell
@property (nonatomic, strong, nullable) UIImageView *iv2;
@property (nonatomic, strong, nullable) UIImageView *iv3;
@property (nonatomic, strong, nullable) WMDActionAreaView *actionView;@end
