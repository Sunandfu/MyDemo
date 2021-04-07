//
//  CartoonDetailViewController.h
//  ReadBook
//
//  Created by lurich on 2020/6/17.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartoonDetailViewController : SFBaseViewController

@property (nonatomic, strong) BookModel *bookModel;
@property (nonatomic, strong) NSArray<BookDetailModel *> *cellArray;

@end

NS_ASSUME_NONNULL_END
