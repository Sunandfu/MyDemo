//
//  SFReadViewController.h
//  ReadBook
//
//  Created by lurich on 2020/6/1.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFNetWork.h"
#import "SFTool.h"
#import "MJRefresh.h"
#import "BookTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFReadViewController : UIViewController

@property (nonatomic, copy  ) NSString *xpath;
@property (nonatomic, strong) BookModel *bookModel;
@property (nonatomic, strong) NSArray<BookDetailModel *> *cellArray;

@end

NS_ASSUME_NONNULL_END
