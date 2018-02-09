//
//  CollectionHeaderView.h
//  formDemo
//
//  Created by qinyulun on 16/4/15.
//  Copyright © 2016年 leTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellGroupModel;

@interface CollectionHeaderView : UICollectionReusableView

- (void)headerViewDataWithModel:(CellGroupModel*)model indexPath:(NSIndexPath*)indexPath;

@end
