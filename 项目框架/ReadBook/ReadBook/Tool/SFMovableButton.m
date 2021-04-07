//
//  SFMovableButton.m
//  SFMovableButton
//
//  Created by 王少帅 on 2017/9/21.
//  Copyright © 2017年 王少帅. All rights reserved.
//

#import "SFMovableButton.h"
#import <objc/runtime.h>
#import "SFSafeAreaInsets.h"
#define PADDING 10
static void *SFDragEnableKey = &SFDragEnableKey;
static void *SFAdsorbEnableKey = &SFAdsorbEnableKey;

@implementation SFMovableButton

-(void)setDragEnable:(BOOL)dragEnable
{
    objc_setAssociatedObject(self, SFDragEnableKey,@(dragEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isDragEnable
{
    return [objc_getAssociatedObject(self, SFDragEnableKey) boolValue];
}

-(void)setAdsorbEnable:(BOOL)adsorbEnable
{
    objc_setAssociatedObject(self, SFAdsorbEnableKey,@(adsorbEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isAdsorbEnable
{
    return [objc_getAssociatedObject(self, SFAdsorbEnableKey) boolValue];
}

CGPoint SFbeginPoint;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if (![objc_getAssociatedObject(self, SFDragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    SFbeginPoint = [touch locationInView:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    if (![objc_getAssociatedObject(self, SFDragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - SFbeginPoint.x;
    float offsetY = nowPoint.y - SFbeginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.highlighted) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.highlighted = NO;
    }
    
    if (self.superview && [objc_getAssociatedObject(self,SFAdsorbEnableKey) boolValue] ) {
        float marginLeft = self.frame.origin.x;
        float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
        float marginTop = self.frame.origin.y;
        float marginBottom = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
        [UIView animateWithDuration:0.125 animations:^(void){
            if (marginTop<SF_StatusBarAndNavigationBarHeight) {
                self.frame = CGRectMake(marginLeft<marginRight?PADDING:self.superview.frame.size.width - self.frame.size.width-PADDING,
                                        PADDING+SF_StatusBarAndNavigationBarHeight,
                                        self.frame.size.width,
                                        self.frame.size.height);
            }
            else if (marginBottom<60) {
                self.frame = CGRectMake(marginLeft<marginRight?marginLeft<PADDING?PADDING:self.frame.origin.x:marginRight<PADDING?self.superview.frame.size.width -self.frame.size.width-PADDING:self.frame.origin.x,
                                        self.superview.frame.size.height - self.frame.size.height-PADDING,
                                        self.frame.size.width,
                                        self.frame.size.height);
                
            }
            else {
                self.frame = CGRectMake(marginLeft<marginRight?PADDING:self.superview.frame.size.width - self.frame.size.width-PADDING,
                                        self.frame.origin.y,
                                        self.frame.size.width,
                                        self.frame.size.height);
            }
        }];
        
    }
}


@end
