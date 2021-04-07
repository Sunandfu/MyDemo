//
//  SFMoreListViewController.h
//  ReadBook
//
//  Created by lurich on 2020/6/30.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFMoreListViewController : SFBaseViewController<SFScrollPageViewChildVcDelegate>

@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, strong) NSArray *cellArray;
@property (nonatomic, strong) UIViewController *currentVC;

@end

NS_ASSUME_NONNULL_END
