//
//  LSYAlbumModel.m
//  AlbumPicker
//
//  Created by Labanotation on 15/8/1.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYAlbumModel.h"

@implementation LSYAlbumModel
-(instancetype)initAlbumModel:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        _asset = asset;
        _isSelect = NO;
        _assetType = [asset valueForProperty:ALAssetPropertyType];
    }
    return self;
}
+(instancetype)AlbumModel:(ALAsset *)asset
{
    return [[LSYAlbumModel alloc] initAlbumModel:asset];
}
@end
