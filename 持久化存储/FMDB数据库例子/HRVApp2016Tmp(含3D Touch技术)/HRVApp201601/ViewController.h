//
//  ViewController.h
//  HRVApp201601
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 betterlife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;
@protocol ViewControllerDelegate <NSObject>

@required
// 删除按钮点击
- (void)detailViewController:(ViewController *)detailVC DidSelectedDeleteItem:(NSString *)navTitle;
// 返回按钮点击
- (void)detailViewControllerDidSelectedBackItem:(ViewController *)detailVC;

@end

@interface ViewController : UIViewController

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic,weak)id<ViewControllerDelegate> delegate;

@end

