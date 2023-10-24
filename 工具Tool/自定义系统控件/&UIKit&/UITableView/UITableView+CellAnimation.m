//
//  UITableView+CellAnimation.m
//  UsefulCategory
//  GitHub地址: https://github.com/LuochuanAD/UsefulCategory
//  Created by care on 2018/4/3.
//  Copyright © 2018年 luochuan. All rights reserved.
//

#import "UITableView+CellAnimation.h"

#define XS_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define XS_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation UITableView (CellAnimation)

- (void) customAnimation:(CustomAnimation)type{
    switch (type) {
        case CustomAnimationTypeMove:
        {
            [self moveAnimation];
        }
            break;
        case CustomAnimationTypeAlpha:
        {
            [self alphaAnimation];
        }
            break;
        case CustomAnimationTypeFall:
        {
            [self fallAnimation];
        }
            break;
        case CustomAnimationTypeShaKe:
        {
            [self shakeAnimation];
        }
            break;
        case CustomAnimationTypeOverTurn:
        {
            [self overTurnAnimation];
        }
            break;
        case CustomAnimationTypeToTop:
        {
            [self toTopAnimation];
        }
            break;
        case CustomAnimationTypeSpringList:
        {
            [self springListAnimation];
        }
            break;
        case CustomAnimationTypeShrinkToTop:
        {
            [self shrinkToTopAnimation];
        }
            break;
        case CustomAnimationTypeLayDown:
        {
            [self layDownAnimation];
        }
            break;
        case CustomAnimationTypeRote:
        {
            [self roteAnimation];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)moveAnimation
{
    NSArray *cells = self.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        CGFloat totalTime = 0.4;
        UITableViewCell *cell = [self.visibleCells objectAtIndex:i];
        cell.transform = CGAffineTransformMakeTranslation(-XS_SCREEN_WIDTH, 0);
        [UIView animateWithDuration:0.4 delay:i*(totalTime/cells.count) usingSpringWithDamping:0.7 initialSpringVelocity:1/0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)alphaAnimation
{
    NSArray *cells = self.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [self.visibleCells objectAtIndex:i];
        cell.alpha = 0.0;
        [UIView animateWithDuration:0.3 delay:i*0.05 options:0 animations:^{
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)fallAnimation
{
    NSArray *cells = self.visibleCells;
    
    NSTimeInterval totalTime = 0.8;
    
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [self.visibleCells objectAtIndex:i];
        cell.transform = CGAffineTransformMakeTranslation(0, - XS_SCREEN_HEIGHT);
        [UIView animateWithDuration:0.3 delay:(cells.count - i)*(totalTime/cells.count) options:0 animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)shakeAnimation
{
    NSArray *cells = self.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        if (i%2 == 0) {
            cell.transform = CGAffineTransformMakeTranslation(-XS_SCREEN_WIDTH,0);
        }else {
            cell.transform = CGAffineTransformMakeTranslation(XS_SCREEN_WIDTH,0);
        }
        [UIView animateWithDuration:0.4 delay:i*0.03 usingSpringWithDamping:0.75 initialSpringVelocity:1/0.75 options:0 animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)overTurnAnimation
{
    NSArray *cells = self.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        cell.layer.opacity = 0.0;
        cell.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        NSTimeInterval totalTime = 0.7;
        [UIView animateWithDuration:0.3 delay:i*(totalTime/cells.count) options:0 animations:^{
            cell.layer.opacity = 1.0;
            cell.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)toTopAnimation
{
    NSArray *cells = self.visibleCells;
    
    NSTimeInterval totalTime = 0.8;
    
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [self.visibleCells objectAtIndex:i];
        cell.transform = CGAffineTransformMakeTranslation(0,  XS_SCREEN_HEIGHT);
        [UIView animateWithDuration:0.35 delay:i*(totalTime/cells.count) options:UIViewAnimationOptionCurveEaseOut animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)springListAnimation
{
    NSArray *cells = self.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        cell.layer.opacity = 0.7;
        cell.layer.transform = CATransform3DMakeTranslation(0, -XS_SCREEN_HEIGHT, 20);
        NSTimeInterval totalTime = 1.0;
        
        [UIView animateWithDuration:0.4 delay:i*(totalTime/cells.count) usingSpringWithDamping:0.65 initialSpringVelocity:1/0.65 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.layer.opacity = 1.0;
            cell.layer.transform = CATransform3DMakeTranslation(0, 0, 20);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)shrinkToTopAnimation
{
    NSArray *cells = self.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        CGRect rect = [cell convertRect:cell.bounds fromView:self];
        cell.transform = CGAffineTransformMakeTranslation(0, -rect.origin.y);
        [UIView animateWithDuration:0.5 animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)layDownAnimation
{
    NSArray *cells = self.visibleCells;
    NSMutableArray *rectArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        CGRect rect = cell.frame;
        [rectArr addObject:[NSValue valueWithCGRect:rect]];
        rect.origin.y = i * 10;
        cell.frame = rect;
        cell.layer.transform = CATransform3DMakeTranslation(0, 0, i*5);
    }
    NSTimeInterval totalTime = 0.8;
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        CGRect rect = [[rectArr objectAtIndex:i] CGRectValue];
        [UIView animateWithDuration:(totalTime/cells.count) * i animations:^{
            cell.frame = rect;
        } completion:^(BOOL finished) {
            cell.layer.transform = CATransform3DIdentity;
        }];
    }

}

- (void)roteAnimation
{
    NSArray *cells = self.visibleCells;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(-M_PI);
    animation.toValue = 0;
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 3;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        
        cell.alpha = 0.0;
        [UIView animateWithDuration:0.1 delay:i*0.25 options:0 animations:^{
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
            [cell.layer addAnimation:animation forKey:@"rotationYkey"];
        }];
    }
}

@end
