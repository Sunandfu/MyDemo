//
//  VMButtonCircleFun.h
//  VMButtonCircleFun
//
//  Created by Vu Mai on 6/2/15.
//  Copyright (c) 2015 VuMai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VMMakeLocation) {
    VMMakeLocationTop = 1,
    VMMakeLocationBottom
};
typedef void(^clickView)();

@interface VMButtonCircleFun : UIView

@property(nonatomic) UIColor *strokeColor;
@property (nonatomic,copy) clickView clickBlock;

- (void)addCircleLayerWithType:(NSInteger)type;
- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;
-(void)buildButton;
-(void)setIconButton:(UIImage *)icon withType:(NSInteger)type withColor:(UIColor*)color;
-(void)setLineWidthValue:(float)lineWidthTemp;
- (void)viewClick:(clickView)clickBlock;

@end
