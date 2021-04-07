//
//  DetailViewController.h
//  ReadBook
//
//  Created by lurich on 2020/5/13.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, copy  ) NSString *xpath;
@property (nonatomic, strong) BookModel *bookModel;
@property (nonatomic, strong) NSArray<BookDetailModel *> *cellArray;

@end

NS_ASSUME_NONNULL_END
