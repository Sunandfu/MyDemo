//
//  SFRecommendBookView.h
//  ReadBook
//
//  Created by lurich on 2020/7/27.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXTagsCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFRecommendBookView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HXTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) void(^selectedTagsBlock)(NSString *selectedTag);

@end

NS_ASSUME_NONNULL_END
