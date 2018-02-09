//
//  LSYAssetPreviewItem.h
//  AlbumPicker
//
//  Created by okwei on 15/7/31.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSYAssetPreviewItemDelegate <NSObject>
-(void)hiddenBarControl;
@end
@interface LSYAssetPreviewItem : UIView
@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,weak) id<LSYAssetPreviewItemDelegate>delegate;
@end
