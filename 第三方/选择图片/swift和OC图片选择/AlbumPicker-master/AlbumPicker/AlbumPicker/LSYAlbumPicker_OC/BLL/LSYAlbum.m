//
//  LSYAlbum.m
//  AlbumPicker
//
//  Created by okwei on 15/7/23.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYAlbum.h"
#import "LSYAlbumModel.h"
@interface LSYAlbum ()

@end
@implementation LSYAlbum
+(LSYAlbum *)sharedAlbum{
    static LSYAlbum *_album = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _album = [[LSYAlbum alloc] init];
        _album.assetsLibrary = [[ALAssetsLibrary alloc] init];
        _album.assstsFilter = [ALAssetsFilter allAssets];
    });
    return _album;
}
-(void)setupAlbumGroups:(albumGroupsBlock)albumGroups
{
    NSMutableArray *groups = @[].mutableCopy;
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [group setAssetsFilter:self.assstsFilter];
            NSInteger groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
            if (groupType == ALAssetsGroupSavedPhotos) {
                [groups insertObject:group atIndex:0];
                
            } else {
                if (group.numberOfAssets>0) {
                    [groups addObject:group];
                }
            }
           
        } else {
            _groups = groups;
            if (albumGroups) {
                albumGroups(groups);
            }
            
        }
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        _groups = groups;
        if (albumGroups) {
            albumGroups(groups);
        }
    };
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:resultBlock failureBlock:failureBlock];
    
    
}
-(void)setupAlbumAssets:(ALAssetsGroup *)group withAssets:(albumAssetsBlock)albumAssets
{
    NSMutableArray *assets = @[].mutableCopy;
    [group setAssetsFilter:self.assstsFilter];
    //相册内资源总数
    NSInteger assetCount = [group numberOfAssets];
    ALAssetsGroupEnumerationResultsBlock resultBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            LSYAlbumModel *model = [[LSYAlbumModel alloc] initAlbumModel:asset];
            [assets addObject:model];
            NSString *assetType = [model.asset valueForProperty:ALAssetPropertyType];
            if ([assetType isEqualToString:ALAssetTypePhoto]) {
                
            }
            else if ([assetType isEqualToString:ALAssetTypeVideo]) {
                
            }
        }
        else if (assets.count >= assetCount)
        {
            _assets = assets;
            if (albumAssets) {
                albumAssets(assets);
            }
            
        };
    };
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:resultBlock];
}
@end
