//
//  DWMenusViewController.h
//  DWMenus
//
//  Created by Dwang on 16/4/27.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^wodeblock)(NSString *colorName);

@interface DWMenusViewController : UIViewController

@property (nonatomic,copy) wodeblock selfblock;

- (void)wodeyanse:(wodeblock)block;

@end
