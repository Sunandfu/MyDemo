//
//  ViewController.h
//  ZFBluetooth
//
//  Created by renzifeng on 15/9/6.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralViewContriller.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@end

