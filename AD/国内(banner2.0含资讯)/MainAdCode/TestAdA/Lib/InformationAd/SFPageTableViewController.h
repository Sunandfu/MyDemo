//
//  SFPageTableViewController.h
//  SFScrollPageView
//
//  Created by ZeroJ on 16/8/31.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFScrollPageViewDelegate.h"

@protocol SFPageTableControllerDelegate <NSObject>

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView;

@end

@interface SFPageTableViewController : UIViewController<SFScrollPageViewChildVcDelegate>

@property(strong, nonatomic)NSArray *titleArray;
@property (nonatomic, copy) NSString *mediaId;
@property (nonatomic, copy) NSString *mLocationId;
@property (assign, nonatomic) CGFloat segmentHeight;

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, assign) BOOL isInfo;
@property(weak, nonatomic)id<SFPageTableControllerDelegate> pageDelegate;
- (void)getNetWorkDataWithTop:(BOOL)isTop;

@end
