//
//  CocoaImageViewController.m
//  CocoaPicker
//
//  Created by 薛泽军 on 15/11/25.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//

#import "CocoaImageViewController.h"
#import "CocoaCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface CocoaImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong,nonatomic)UIButton *addBtu;

@end

@implementation CocoaImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //设置横向还是竖向
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-49-64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CocoaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    UIToolbar *footBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-49-64,self.view.bounds.size.width,49)];
    [self.view addSubview:footBar];
    
    self.addBtu=[UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtu.frame=CGRectMake(self.view.bounds.size.width-100,10,90,30);
    self.addBtu.backgroundColor=COLORSELECT;
    [self.addBtu addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addbtuTitle];
    [footBar addSubview:self.addBtu];
    
    
    UIBarButtonItem *rightBii=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBiiClick:)];
    self.navigationItem.rightBarButtonItem=rightBii;
}
- (void)addClick:(UIButton *)btu
{
    if (_sendBackArray.count==0) {
        return;
    }
    self.selectBlock(YES);
}
- (void)addbtuTitle
{
    if (_sendBackArray.count==0) {
    [self.addBtu setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
        [self.addBtu setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }else
    {
    [self.addBtu setTitle:[NSString stringWithFormat:@"发送(%lu)",(unsigned long)_sendBackArray.count] forState:UIControlStateNormal];
        self.addBtu.backgroundColor=COLORSELECT;
    }
}
- (void)rightBiiClick:(UIBarButtonItem *)bii
{
    self.selectBlock(NO);
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
    cell.selected=[self containsImage:dict];
    cell.headImageView.contentMode =  UIViewContentModeScaleAspectFill;
    cell.headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.headImageView.clipsToBounds  = YES;
    return cell;
}
- (BOOL)containsImage:(id)obj
{
    for (NSDictionary *dict in _sendBackArray) {
        if (dict[@"image"]==obj[@"image"]) {
            return YES;
        }
    }
    return NO;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float imageView_W =_collectionView.bounds.size.width/4-6;
    return CGSizeMake(imageView_W,imageView_W);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _newimageArray[indexPath.row];
    if (![_sendBackArray containsObject:dict]) {
        [_sendBackArray addObject:dict];
    }
    else{
        [_sendBackArray removeObject:dict];
    }
    NSLog(@"lllll~~%@~~~%@",_sendBackArray,dict);

    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self addbtuTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
