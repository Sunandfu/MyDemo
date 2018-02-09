//
//  LSYAlbumCatalog.h
//  AlbumPicker
//
//  Created by okwei on 15/7/24.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSYAlbumCatalogDelegate<NSObject>
-(void)AlbumDidFinishPick:(NSArray *)assets;
@end
@interface LSYAlbumCatalog : UIViewController
//可以选择照片的最多数量，不显示视频资源
@property (nonatomic) NSInteger maximumNumberOfSelectionPhoto;
//可以选择媒体的最多数量，显示所有的资源
@property (nonatomic) NSInteger maximumNumberOfSelectionMedia;
@property (nonatomic,weak) id<LSYAlbumCatalogDelegate>delegate;
@end
