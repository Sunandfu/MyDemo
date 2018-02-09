//
//  Header.h
//  formDemo
//
//  Created by qinyulun on 16/4/15.
//  Copyright © 2016年 leTian. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//屏幕尺寸适配
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SIZE   [[UIScreen mainScreen] bounds].size

#define SCREEN_WIDTH_BOUNDS  CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT_BOUNDS CGRectGetHeight([UIScreen mainScreen].bounds)
#define NavStateBarHight (20)
#define NavBarHight (44)
#define NavBarAndStateBarHight (NavStateBarHight + NavBarHight)
//end

//视图尺寸
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define IMGWIDTH(image) image.size.width
#define IMGHEIGHT(image) image.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y

#define MaxX(view) CGRectGetMaxX(view.frame)
#define MaxY(view) CGRectGetMaxY(view.frame)

#define MaxScreenX CGRectGetWidth([UIScreen mainScreen].bounds)
#define MaxScreenY CGRectGetHeight([UIScreen mainScreen].bounds)

#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)


#endif /* Constants_h */
