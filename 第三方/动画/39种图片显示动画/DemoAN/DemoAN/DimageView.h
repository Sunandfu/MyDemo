//
//  DimageView.h
//  DemoAN
//
//  Created by Dolphin-MC700 on 14-9-17.
//  Copyright (c) 2014年 kid8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DimageViewsDelegate <NSObject>

- (void)stopDraw;

@end

@interface DimageView : UIView{
    UIImage* myImageObj;
    float x ;
    float y ;
    float x1 ;
    float y1 ;
    float x2 ;
    float y2 ;
    float x3 ;
    float y3 ;
    float w ;
    float h ;
    float w1 ;
    float h1 ;
    float scale;
    float scale1;
    double r;
    double R;
    float maxW;
    float maxH;
    CGRect imageFrame;
}

- (id)initWithFrame:(CGRect)frame maxWight:(float) wight maxHight:(float)hight number:(int)number;
@property (assign,nonatomic) id<DimageViewsDelegate>delegate;
@property (nonatomic) int number;

@end
