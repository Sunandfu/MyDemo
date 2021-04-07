//
//  SFReadDetailViewController.h
//  ReadBook
//
//  Created by lurich on 2020/6/1.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFNetWork.h"
#import "SFTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFReadDetailViewController : UIViewController

@property (nonatomic, copy) NSString *bookTitleName;

@property (nonatomic, strong) BookDetailModel *bookModel;

/** 第n章 */
@property (nonatomic, assign) NSUInteger chapter;

/** 第几页 */
@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, strong) NSDictionary *viewSetDict;

@end

NS_ASSUME_NONNULL_END
