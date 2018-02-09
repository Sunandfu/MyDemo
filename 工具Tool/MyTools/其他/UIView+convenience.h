//
//  UIView+convenience.h
//  daShu
//
//  Created by 史岁富 on 15/11/3.
//  Copyright © 2015年 史岁富. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (convenience)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

-(BOOL) containsSubView:(UIView *)subView;
-(BOOL) containsSubViewOfClassType:(Class)aclass;
@end
