//
//  SFScrollView.h
//  SFScrollPageView
//
//  Created by ZeroJ on 16/10/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCollectionView : UICollectionView

typedef BOOL(^SFScrollViewShouldBeginPanGestureHandler)(SFCollectionView *collectionView, UIPanGestureRecognizer *panGesture);

- (void)setupScrollViewShouldBeginPanGestureHandler:(SFScrollViewShouldBeginPanGestureHandler)gestureBeginHandler;

@end
