//
//  LSYAlbumCell.h
//  AlbumPicker
//
//  Created by okwei on 15/7/24.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYAlbumModel.h"
@interface LSYAlbumCell : UICollectionViewCell
@property (nonatomic,strong) LSYAlbumModel *model;
@end

@interface LSYAlbumCellBottomView : UIView
@property (nonatomic) double interval;
@end