//
//  SFGestureTableView.m
//  TestAdA
//
//  Created by lurich on 2021/4/2.
//  Copyright © 2021 . All rights reserved.
//

#import "SFGestureTableView.h"

@implementation SFGestureTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
