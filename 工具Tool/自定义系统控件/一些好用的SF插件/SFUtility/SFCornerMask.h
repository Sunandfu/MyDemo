//
//  SFRoundCornerMask.h
//  Pods
//
//  Created by 畅三江 on 2018/7/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 UIRectCornerAllCorners  = ~0UL
 */

/// rect corner & border
UIKIT_EXTERN void
SFCornerMaskSetRectCorner(__kindof UIView *view, UIRectCorner corners, CGFloat radius, CGFloat borderWidth, UIColor *_Nullable borderColor);

/// rect corner
UIKIT_EXTERN void __attribute__((overloadable))
SFCornerMaskSetRectCorner(__kindof UIView *view, UIRectCorner corners, CGFloat radius);

/// round & border
UIKIT_EXTERN void
SFCornerMaskSetRound(__kindof UIView *view, CGFloat borderWidth, UIColor *_Nullable borderColor);

/// round
UIKIT_EXTERN void __attribute__((overloadable))
SFCornerMaskSetRound(__kindof UIView *view);
NS_ASSUME_NONNULL_END
