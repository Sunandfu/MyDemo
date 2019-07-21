//
//  HXPhotoEditViewController.h
//  照片选择器
//
//  Created by 洪欣 on 2017/10/27.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"

@class HXPhotoEditViewController;
@protocol HXPhotoEditViewControllerDelegate <NSObject>
@optional
- (void)photoEditViewControllerDidClipClick:(HXPhotoEditViewController *)photoEditViewController beforeModel:(HXPhotoModel *)beforeModel afterModel:(HXPhotoModel *)afterModel;
@end

@interface HXPhotoEditViewController : UIViewController<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) id<HXPhotoEditViewControllerDelegate> delegate;
@property (strong, nonatomic) HXPhotoModel *model;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (assign, nonatomic) BOOL outside;
@property (assign, nonatomic) BOOL imageRequestComplete;
@property (assign, nonatomic) BOOL transitionCompletion;
@property (assign, nonatomic) BOOL isInside;
@property (assign, nonatomic) BOOL isCancel;
@property (strong, nonatomic, readonly) UIImage *originalImage;
- (void)completeTransition:(UIImage *)image; 
- (void)showBottomView;
- (void)hideImageView;
- (UIImage *)getCurrentImage;
- (CGRect)getImageFrame;
@end

@class HXEditRatio;
@protocol HXPhotoEditBottomViewDelegate <NSObject>
@optional
- (void)bottomViewDidCancelClick;
- (void)bottomViewDidRestoreClick;
- (void)bottomViewDidRotateClick;
- (void)bottomViewDidClipClick;
- (void)bottomViewDidSelectRatioClick:(HXEditRatio *)ratio;
@end

@interface HXPhotoEditBottomView : UIView
@property (weak, nonatomic) id<HXPhotoEditBottomViewDelegate> delegate;
@property (assign, nonatomic) BOOL enabled;
- (instancetype)initWithManager:(HXPhotoManager *)manager;
@end

@interface HXEditGridLayer : UIView
@property (nonatomic, assign) CGRect clippingRect;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *gridColor; 
@end

@interface HXEditCornerView : UIView
@property (nonatomic, strong) UIColor *bgColor;
@end

@interface HXEditRatio : NSObject
@property (nonatomic, assign) BOOL isLandscape;
@property (nonatomic, readonly) CGFloat ratio;
@property (nonatomic, strong) NSString *titleFormat; 
- (id)initWithValue1:(CGFloat)value1 value2:(CGFloat)value2;
@end
