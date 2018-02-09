//
//  RaTreeViewCell.h
//  RATreeDemo
//
//  Created by l2cplat on 16/5/25.
//  Copyright © 2016年 zhukaiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaTreeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;//图标

@property (weak, nonatomic) IBOutlet UILabel *titleLable;//标题

//赋值
- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children;
@end
