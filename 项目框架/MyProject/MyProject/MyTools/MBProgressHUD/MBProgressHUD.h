//
//  MBProgressHUD.h
//  Version 0.5
//  Created by Matej Bukovinski on 2.4.09.
//

// This code is distributed under the terms and conditions of the MIT license. 

// Copyright (c) 2011 Matej Bukovinski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol MBProgressHUDDelegate;


typedef enum {
	/** Progress is shown using an UIActivityIndicatorView. This is the default. */
	MBProgressHUDModeIndeterminate,
	/** Progress is shown using a round, pie-chart like, progress view. */
	MBProgressHUDModeDeterminate,
	/** Progress is shown using a ring-shaped progress view. */
	MBProgressHUDModeAnnularDeterminate,
	/** Shows a custom view */
	MBProgressHUDModeCustomView,
	/** Shows only labels */
	MBProgressHUDModeText
} MBProgressHUDMode;

typedef enum {
	/** Opacity animation */
	MBProgressHUDAnimationFade,
	/** Opacity + scale animation */
	MBProgressHUDAnimationZoom
} MBProgressHUDAnimation;

typedef enum {

    MBProgressHUDNativeYES,
    MBProgressHUDNativeNO
    
} MBProgressHUDNative;

#ifndef MB_STRONG
#if __has_feature(objc_arc)
	#define MB_STRONG strong
#else
	#define MB_STRONG retain
#endif
#endif

#ifndef MB_WEAK
#if __has_feature(objc_arc_weak)
	#define MB_WEAK weak
#elif __has_feature(objc_arc)
	#define MB_WEAK unsafe_unretained
#else
	#define MB_WEAK assign
#endif
#endif


@interface MBProgressHUD : UIView

+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated andType:(MBProgressHUDNative)type;

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

+ (MBProgressHUD *)HUDForView:(UIView *)view;

+ (NSArray *)allHUDsForView:(UIView *)view;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

- (id)initWithWindow:(UIWindow *)window;

//- (id)initWithView:(UIView *)view;

- (id)initWithView:(UIView *)view andType:(MBProgressHUDNative)type;

- (id)initWithFrame:(CGRect)frame andType:(MBProgressHUDNative)type;

@property (assign) MBProgressHUDMode mode;

@property (assign) MBProgressHUDAnimation animationType;

@property (MB_STRONG) UIView *customView;

@property (MB_WEAK) id<MBProgressHUDDelegate> delegate;

@property (copy) NSString *labelText;

@property (copy) NSString *detailsLabelText;

@property (assign) float opacity;

@property (assign) float xOffset;

@property (assign) float yOffset;

@property (assign) float margin;

@property (assign) BOOL dimBackground;

@property (assign) float graceTime;

@property (assign) float minShowTime;

@property (assign) BOOL taskInProgress;

@property (assign) BOOL removeFromSuperViewOnHide;

@property (MB_STRONG) UIFont* labelFont;

@property (MB_STRONG) UIFont* detailsLabelFont;

@property (assign) float progress;

@property (assign) CGSize minSize;

@property (assign, getter = isSquare) BOOL square;

@end


@protocol MBProgressHUDDelegate <NSObject>

@optional

- (void)hudWasHidden:(MBProgressHUD *)hud;

@end

@interface MBRoundProgressView : UIView 

@property (nonatomic, assign) float progress;

@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end
