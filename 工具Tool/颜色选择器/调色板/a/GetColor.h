//
//  GetColor.h
//  a
//
//  Created by Ibokan on 15/9/28.
//  Copyright © 2015年 Crazy凡. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Colorblock)(UIColor *color);

@interface GetColor : UIView
@property (nonatomic,strong) Colorblock block;
//调用时请在ViewDidAppear时使用该句
- (void)runThisMetodWhenViewDidAppear;
@end
