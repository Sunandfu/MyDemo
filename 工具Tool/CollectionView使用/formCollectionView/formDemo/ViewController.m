//
//  ViewController.m
//  formDemo
//
//  Created by qinyulun on 16/4/15.
//  Copyright © 2016年 leTian. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "CollectionHeaderView.h"
#import "CellGroupModel.h"
#import "CellModel.h"

#define CellHeight  35
#define CellIdentifier  @"cell"
#define CellHeaderIdentifier @"cellHeader"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray   *cellGroupData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellGroupData = [NSMutableArray array];
    [self initWithData];
    [self initWithCollectionView];
    
}

- (void)initWithData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.plist" ofType:nil];
    NSArray *cellData = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in cellData) {
        CellGroupModel *model = [CellGroupModel cellDataWithDic:dic];
        [_cellGroupData addObject:model];
    }
}

- (UICollectionViewFlowLayout*)layout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (SCREEN_WIDTH_BOUNDS - space*2)/4;
    layout.itemSize = CGSizeMake(width, 30);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH_BOUNDS, space*5);
    layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
    return layout;
}

- (void)initWithCollectionView
{
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_BOUNDS, SCREEN_HEIGHT_BOUNDS) collectionViewLayout:[self layout]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    //注册头部
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellHeaderIdentifier];
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark  uicollectionDdataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _cellGroupData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CellGroupModel *model  = _cellGroupData[section];
    return model.titleList.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    CellGroupModel *model  = _cellGroupData[indexPath.section];
    [cell cellDataWithModle:model.titleList[indexPath.row]];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellHeaderIdentifier forIndexPath:indexPath];
    if (!headerView) {
        headerView = [[CollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_BOUNDS, 30)];
    }
    CellGroupModel *model  = _cellGroupData[indexPath.section];
    [headerView headerViewDataWithModel:model indexPath:indexPath];
    return headerView;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了第%ld组的第%ld个itm",(long)indexPath.section,(long)indexPath.row);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
