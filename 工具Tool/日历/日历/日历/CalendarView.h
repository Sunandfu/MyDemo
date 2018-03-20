//
//  CalendarView.h
//  日历
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 HEJJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView

@end

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
