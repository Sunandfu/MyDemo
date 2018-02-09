//
//  ATLabel.h
//  LHALoadingView
//
//  Created by LiuHao on 16/4/26.
//  Copyright © 2016年 littleye. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ATLabel : UILabel

@property(nonatomic,retain) NSArray *wordList;
@property(nonatomic,assign) double duration;

- (void)animateWithWords:(NSArray *)words forDuration:(double)time;

@end
