//
//  CustomCollectionViewCell.h
//  TestAdA
//
//  Created by lurich on 2019/4/16.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GDTUnifiedNativeAdView;
NS_ASSUME_NONNULL_BEGIN

@interface CustomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *AppName;
@property (weak, nonatomic) IBOutlet UILabel *AppDesc;
@property (weak, nonatomic) IBOutlet UIImageView *currentImageView;
@property (weak, nonatomic) IBOutlet GDTUnifiedNativeAdView *backView;

@end

NS_ASSUME_NONNULL_END
