//
//  DragAndDropTableViewController.h
//  CardScrlDemo
//
//  Created by lotus on 2019/12/31.
//  Copyright © 2019 lotus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragAndDropTableViewDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DragAndDropTableViewController : UITableViewController
@property (nonatomic, strong) DragAndDropTableViewDataManager *dataManager;
@end

NS_ASSUME_NONNULL_END
