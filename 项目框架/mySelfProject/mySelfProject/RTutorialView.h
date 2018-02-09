//
//  RTutorialView.h
//  JDLife
//
//  Created by AkiXie on 15-2-2.
//  Copyright (c) 2015年. All rights reserved.
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
