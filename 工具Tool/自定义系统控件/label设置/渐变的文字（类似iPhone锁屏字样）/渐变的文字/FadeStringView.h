//
//  FadeStringView.h
//  渐变的文字
//
//  Created by 周少文 on 15/10/26.
//  Copyright © 2015年 ZheJiangWangHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeStringView : UIView

@property (nonatomic,strong) NSString *text;
@property (nonatomic,assign) NSTextAlignment alignment;
@property (nonatomic,strong) UIColor *backColor;
@property (nonatomic,strong) UIColor *foreColor;
@property (nonatomic,strong) UIFont *font;

- (void)fadeRightWithDuration:(NSTimeInterval)duration;


@end
