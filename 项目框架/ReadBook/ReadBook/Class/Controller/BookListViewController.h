//
//  BookListViewController.h
//  ReadBook
//
//  Created by lurich on 2020/5/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookListViewController : SFBaseViewController<SFScrollPageViewChildVcDelegate>

@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, strong) NSArray *cellArray;
@property (nonatomic, strong) UIViewController *currentVC;

@end

NS_ASSUME_NONNULL_END
