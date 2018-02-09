//
//  MenuContentViewController.h
//  SHMenu
//
//  Created by 宋浩文的pro on 16/4/15.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuContentViewController;
@protocol MenuContentViewController <NSObject>


- (void)menuController:(MenuContentViewController *)menuController clickAtRow:(NSUInteger)index;

@end

@interface MenuContentViewController : UITableViewController

@property (nonatomic, assign) id<MenuContentViewController> delegate;

@end
