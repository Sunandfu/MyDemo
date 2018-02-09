//
//  LSYAlbumModel.h
//  AlbumPicker
//
//  Created by Labanotation on 15/8/1.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSYAlbumModel : NSObject
@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong,readonly) NSString *assetType;
@property (nonatomic) BOOL isSelect;
+(instancetype)AlbumModel:(ALAsset *)asset;
-(instancetype)initAlbumModel:(ALAsset *)asset;
@end
