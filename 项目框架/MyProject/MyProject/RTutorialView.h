//
//  HomeViewController.m
//  MyProject
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RTutorialView;

@protocol RTutorial <NSObject>

@optional
- (void)tutorialView:(RTutorialView *)tutorialView didPageToIndex:(NSUInteger)index;
- (void)tutorialDidFinish:(RTutorialView *)tutorialView;

@end

@interface RTutorialView : UIView

@property (nonatomic, strong) NSArray *learningImageNames;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, weak) id<RTutorial>tutorialDelegate;


@end
