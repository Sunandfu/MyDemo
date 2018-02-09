//
//  ViewController.h
//  CXPlayerTableviewcell
//
//  Created by artifeng on 16/1/5.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *myTableView;

-(void)show;
@end

