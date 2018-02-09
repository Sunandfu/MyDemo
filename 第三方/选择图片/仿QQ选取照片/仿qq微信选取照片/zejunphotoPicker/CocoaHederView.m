//
//  CocoaHederView.m
//  CocoaPicker
//
//  Created by Cocoa Lee on 15/8/25.
//  Copyright (c) 2015年 Cocoa Lee. All rights reserved.
//

#import "CocoaHederView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CocoaGroup.h"
#import "CocoaCollectionViewCell.h"

@implementation CocoaHederView 


- (id)init{
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getPhotoLibName];
        });
    }
    return self;
}


- (void)initHeaderView{
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 190);

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 190)];
    [self addSubview:scrollView];
    _scrollView = scrollView;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //设置横向还是竖向
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 190) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CocoaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _newimageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    CocoaCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    NSDictionary *dict = _newimageArray[indexPath.row];
    cell.cellDict=dict;
//    cell.headImageView.layer.borderWidth = 2;
    cell.selected=[self containsImage:dict];
    return cell;
}
- (BOOL)containsImage:(id)obj
{
    for (NSDictionary *dict in _sendBackArray) {
        if ([dict[@"url"] isEqualToString:obj[@"url"]]) {
            return YES;
        }
    }
    return NO;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _newimageArray[indexPath.row];
    UIImage *image=dict[@"image"];
    float imageView_W;
    if (image) {
       imageView_W = image.size.width/(image.size.height/_scrollView.bounds.size.height);

    }else
    {
        imageView_W=_scrollView.bounds.size.height;
    }
    return CGSizeMake(imageView_W,_scrollView.bounds.size.height);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(0,0,0,0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (BOOL)addWithSendBackArray:(id)obj
{
    for (NSDictionary *dict in _sendBackArray) {
        if (![dict[@"type"] isEqualToString:obj[@"type"]]) {
//            [[NetworkRequest sharedNetworkRequest]alertViewWithTitle:@"提示" andMessage:@"不能同时选择照片和视频"];
            
            return NO;
        }
    }
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _newimageArray[indexPath.row];
    if (![_sendBackArray containsObject:dict]) {
        if ([self addWithSendBackArray:dict]) {
            [_sendBackArray addObject:dict];
        }
    }
    else{
        [_sendBackArray removeObject:dict];
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    _sendImageBlock(_sendBackArray);
}
- (void)getPhotoLibName {
    //    1 获得所有相册
    if ([CocoaGroup CocoaShareInstance].imageArray.count>0) {
        _newimageArray=[CocoaGroup CocoaShareInstance].imageArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initHeaderView];
            [self.collectionView reloadData];
        });
    }
    _sendBackArray = [NSMutableArray array];

        _albumArray=[NSMutableArray array];
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) {
                return ;
            }
            NSString *name = [NSString stringWithFormat:@"%@",[group valueForProperty:ALAssetsGroupPropertyName]];
            NSLog(@"name : %@",name);
            UIImage *image=[UIImage imageWithCGImage:group.posterImage];
            
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            [dict setValue:name forKey:@"name"];
            [dict setValue:image forKey:@"image"];
            [dict setValue:[self getImageWith:group With:name] forKey:@"albumArray"];
            [self.albumArray addObject:dict];
        } failureBlock:^(NSError *error) {
            
            NSLog(@"Group not found!\n");
            
        }];
}

#pragma mark －获取相册图片
- (NSArray *)getImageWith:(ALAssetsGroup*)assetsGroup With:(NSString *)name{
    
    NSMutableArray *imageArray = [NSMutableArray array];
        [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                NSString *type = [result valueForProperty:ALAssetPropertyType] ;
                NSString *location = [result valueForProperty:ALAssetPropertyLocation];
                NSString *duration = [result valueForProperty:ALAssetPropertyDuration];
                ALAssetRepresentation* representation = [result defaultRepresentation];
                NSString* uit = [representation filename];
                NSString *url = [[[result defaultRepresentation]url]description];
                UIImage *image=[UIImage imageWithCGImage:result.aspectRatioThumbnail];
                [dict setValue:image forKey:@"image"];
                [dict setValue:location forKey:@"location"];
                [dict setValue:duration forKey:@"duration"];
                [dict setValue:type forKey:@"type"];
                [dict setValue:url forKey:@"url"];
                [dict setValue:uit forKey:@"uit"];
                [imageArray addObject:dict];
            }
        }];
//    颠倒数组  循环遍历   用临时数组替换
    NSMutableArray *newArray = [NSMutableArray array];
    for (ALAsset * image in [imageArray reverseObjectEnumerator]) {
        [newArray addObject:image];
    }
    if ([name isEqualToString:@"相机胶卷"]||[name isEqualToString:@"Camera Roll"]) {
        if ([CocoaGroup CocoaShareInstance].imageArray.count==0) {
            _newimageArray = newArray;
            [CocoaGroup CocoaShareInstance].imageArray=newArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initHeaderView];
                [self.collectionView reloadData];
            });
        }
        
    }
    return newArray;
}

#pragma makr -添加图片到ScrollView
- (void)addPhotoToScrollViewWithImageArray:(NSArray *)newImageArray{
    

    for (int i = 0;i < newImageArray.count ;i++) {
        UIImage *image = newImageArray[i];
        UIButton *imageBtn = [UIButton new];
        [imageBtn setImage:image forState:normal];
        imageBtn.tag = i;
        [imageBtn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.layer.borderWidth = 2;
        imageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        //   先计算出宽度  然后调整 scrollView 宽度 然后添加到 scrollVIiew上
        //   0 根据高度计算宽度
        float imageView_W = image.size.width/(image.size.height/_scrollView.bounds.size.height);
        //   1 调整 scrollView contentSize
        imageBtn.frame = CGRectMake(_scrollView.contentSize.width, 0, imageView_W, _scrollView.bounds.size.height);
        imageBtn.selected = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width + imageView_W, _scrollView.contentSize.height);
        [_scrollView addSubview:imageBtn];
    }
}



#pragma mark －相册点击事件
- (void)imageClick:(UIButton*)btn
{
    btn.selected = !btn.selected;
    UIImage *image = [CocoaGroup CocoaShareInstance].imageArray[btn.tag];
   
    if (btn.selected) {
        [_sendBackArray addObject:image];
        btn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:28/255.0 blue:109/255.0 alpha:1].CGColor;
    }
    else{
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_sendBackArray removeObject:image];
    }
    _sendImageBlock(_sendBackArray);
}

    
    
    
    
//    _sendImageBlock(image);
    


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end





