
/**********************************************************
 *     _              _  _  _  ____          __   _       *
 *    / \   _ __   __| || |(_)/ ___|  ___ __/ /__| |_     *
 *   / _ \ | '_  \/ _  || || |\___ \ / _ \_   _|_   _|    *
 *  / ___ \| | | | (_) || || | ___) | (_) || |   | |_     *
 * /_/   \_|_| |_|\____)|_||_||____/ \___/ /_/   \___|    *
 *                                                        *
 **********************************************************
 * Copyright 2015, AndliSoft.com.                         *
 * All rights, including trade secret rights, reserved.   *
 **********************************************************/

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;

@end
