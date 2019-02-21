//
//  NativeTableViewController.h
//  DemoNativeAd
//
//  Created by lishan04 on 15-5-11.
//  Copyright (c) 2015年 lishan04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NativeTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString*toBeChangedApid;
@property(nonatomic,copy)NSString*toBeChangedPublisherId;
@end
