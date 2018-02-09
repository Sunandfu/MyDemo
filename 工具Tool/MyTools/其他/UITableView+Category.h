//
//  UITableView+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Category)
/**
 *  滚动到指定的row
 */
- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
@end
