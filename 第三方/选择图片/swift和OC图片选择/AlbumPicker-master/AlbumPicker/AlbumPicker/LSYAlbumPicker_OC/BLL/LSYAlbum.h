//
//  LSYAlbum.h
//  AlbumPicker
//
//  Created by okwei on 15/7/23.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^albumGroupsBlock)(NSMutableArray *groups);
typedef void (^albumAssetsBlock)(NSMutableArray *assets);
@interface LSYAlbum : NSObject
@property (nonatomic,strong) ALAssetsGroup *assetsGroup;
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong) ALAssetsFilter *assstsFilter;
@property (nonatomic,strong) NSMutableArray *groups;
@property (nonatomic,strong) NSMutableArray *assets;
+(LSYAlbum *)sharedAlbum;
-(void)setupAlbumGroups:(albumGroupsBlock)albumGroups;
-(void)setupAlbumAssets:(ALAssetsGroup *)group withAssets:(albumAssetsBlock)albumAssets;
@end
