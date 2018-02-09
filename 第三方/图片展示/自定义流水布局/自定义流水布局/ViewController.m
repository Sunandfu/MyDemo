//
//  ViewController.m
//  自定义流水布局
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 cz.cn. All rights reserved.
//

#import "ViewController.h"
#import "CZCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  102;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CZCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    
    NSInteger  index  =  indexPath.row % 16;
    
    
    cell.numberLabel.text = [NSString stringWithFormat:@"第%ld个",indexPath.row];

    cell.backgroundColor = [UIColor colorWithRed:index * 15/255.0 green:index /255.0 blue:index /255.0 alpha:1.0];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"我是第%ld个",indexPath.row);
}


@end
