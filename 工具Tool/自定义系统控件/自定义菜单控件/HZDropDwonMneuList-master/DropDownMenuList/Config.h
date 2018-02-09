//
//  Config.h
//  DropDownMenuList
//
//  Created by 王会洲 on 16/5/13.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#ifndef Config_h
#define Config_h
#define DDMWIDTH [UIScreen mainScreen].bounds.size.width

#define DDMHEIGHT [UIScreen mainScreen].bounds.size.height

#define DDMColor(r, g, b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0]

#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

#define HFrame(X,Y,W,H) CGRectMake((X),(Y),(W),(H))

#define IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define ScaleWide (IPhone5 ? 0.8533 : (IPhone6 ? 1.0000 : (IPhone6p ? 1.1040 : 1.0000)))

#define WIDTH(W)   ScaleWide * W

#define ScaleHigh (IPhone5 ? 0.8515 : (IPhone6 ? 1.0000 : (IPhone6p ? 1.1034 : 1.0000)))

#define HEIGHT(H)    ScaleHigh * H

#define HFont(A) (IPhone5 ? 0.8515 : (IPhone6 ? 1.0000 : (IPhone6p ? 1.1034 : 1.0000))) * (A)

#endif /* Config_h */
