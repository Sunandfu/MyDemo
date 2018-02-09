//
//
//
//  url:http://www.xiongcaichang.com
//  Created by bear on 16/3/31.
//  Copyright © 2016年 bear. All rights reserved.
//
#import <UIKit/UIKit.h>


static const CGFloat MaxHeight = 200;



@interface ScalableCover : UIImageView

@property (nonatomic, strong) UIScrollView *scrollView;

@end

/*
 //tableView 有头视图
 self.tableView.tableHeaderView=[[UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
 [self.tableView addScalableCoverWithImage:[UIImage imageNamed:@"mebg"]];
 */


@interface UIScrollView (ScalableCover)

@property (nonatomic, weak) ScalableCover *scalableCover;

- (void)addScalableCoverWithImage:(UIImage *)image;
- (void)removeScalableCover;

@end

