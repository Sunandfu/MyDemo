//
//  CocoaHederView.h
//  CocoaPicker
//
//  Created by Cocoa Lee on 15/8/25.
//  Copyright (c) 2015年 Cocoa Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^sendImage)(NSArray *imageArray);
@interface CocoaHederView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property (strong,nonatomic)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *sendBackArray;
@property(nonatomic,strong)NSArray *newimageArray;
@property(nonatomic,strong)NSMutableArray *albumArray;
@property(nonatomic,strong)sendImage  sendImageBlock;
- (void)getPhotoLibName;
@end
