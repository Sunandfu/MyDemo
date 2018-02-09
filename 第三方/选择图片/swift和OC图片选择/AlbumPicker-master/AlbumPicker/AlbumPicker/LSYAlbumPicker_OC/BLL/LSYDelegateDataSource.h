//
//  LSYDelegateDataSource.h
//  AlbumPicker
//
//  Created by okwei on 15/7/24.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYAlbumCell.h"
#import "LSYAlbumCatalogCell.h"
@interface LSYDelegateDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *albumDataArray;
@property (nonatomic,strong) NSArray *albumCatalogDataArray;
@end
