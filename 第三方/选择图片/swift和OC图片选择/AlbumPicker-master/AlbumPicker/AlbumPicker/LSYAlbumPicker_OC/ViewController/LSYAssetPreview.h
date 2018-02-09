//
//  LSYAssetPreview.h
//  AlbumPicker
//
//  Created by okwei on 15/7/31.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSYAssetPreviewDelegate <NSObject>
-(void)AssetPreviewDidFinishPick:(NSArray *)assets;
@end
@interface LSYAssetPreview : UIViewController
@property (nonatomic,strong) NSArray *assets;
@property (nonatomic,strong) UICollectionView *AlbumCollection;
@property (nonatomic,weak) id <LSYAssetPreviewDelegate> delegate;
@end
