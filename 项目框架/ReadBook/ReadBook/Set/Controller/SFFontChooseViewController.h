//
//  SFFontChooseViewController.h
//  ReadBook
//
//  Created by lurich on 2020/7/5.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFFontChooseViewController : SFBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy  ) NSString *fontShow;
@property (strong, nonatomic) NSArray *fontNames;
@property (weak, nonatomic) IBOutlet UITableView *fTableView;
@property (weak, nonatomic) IBOutlet UITextView *fTextView;
@property (weak, nonatomic) IBOutlet UIProgressView *fProgressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fActivityIndicatorView;

@end

NS_ASSUME_NONNULL_END
