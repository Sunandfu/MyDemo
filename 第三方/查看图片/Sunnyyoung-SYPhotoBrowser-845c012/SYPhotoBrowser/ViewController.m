//
//  ViewController.m
//  SYPhotoBrowser
//
//  Created by Sunnyyoung on 16/3/30.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "SYPhotoBrowser.h"
#import "SDPhotoBrowserConfig.h"

@interface ViewController () <SDPhotoBrowserDelegate,SYPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *urlArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlArray = @[@"http://iphone.tgbus.com/UploadFiles/201410/20141020134730646.jpg",
                      @"http://a.hiphotos.baidu.com/zhidao/pic/item/2cf5e0fe9925bc314cc6bd685fdf8db1ca1370a2.jpg",
                      @"http://d.3987.com/cgqfj_130528/001.jpg",
                      @"http://news.mydrivers.com/img/20130518/68d97fe443034db3bc3aef4d98ac9188.jpg",
                      @"http://ww4.sinaimg.cn/large/af8c19d2gw1f3hzhbs4kfj20j64e5kej.jpg"];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[indexPath.row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2==0) {
        SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:self.urlArray caption:@"This is caption label" delegate:self];
        photoBrowser.initialPageIndex = indexPath.row;
        photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyleLabel;
        photoBrowser.enableStatusBarHidden = YES;
        [self presentViewController:photoBrowser animated:YES completion:nil];
    } else {
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = indexPath.row;
        photoBrowser.imageCount = self.urlArray.count;
        photoBrowser.sourceImagesContainerView = self.collectionView;
        
        [photoBrowser show];
    }
}

#pragma mark - SYPhotoBrowser Delegate

- (void)photoBrowser:(SYPhotoBrowser *)photoBrowser didLongPressImage:(UIImage *)image {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LongPress" message:@"Do somethings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    CollectionViewCell *cell = (CollectionViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.imageView.image;
    
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.urlArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
