//
//  SFLookImageView.h
//  SFVideoPlayer
//
//  Created by Lurich on 2022/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFLookImageView : UIView

- (instancetype)initWithOldImageFrame:(CGRect)frame ShowImage:(UIImage *)image;

- (void)show;

@end

NS_ASSUME_NONNULL_END
