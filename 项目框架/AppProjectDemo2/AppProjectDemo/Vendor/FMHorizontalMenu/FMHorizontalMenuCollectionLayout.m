//
//  FMHorizontalMenuCollectionLayout.m
//  YFMHorizontalMenu
//
//  Created by FM on 2018/11/26.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FMHorizontalMenuCollectionLayout.h"

@interface FMHorizontalMenuCollectionLayout ()

/**
 预计算 contentSize 大小
 */
@property (nonatomic,assign) CGSize contentSize;
/**
 预计算所有的 cell 布局属性
 */
@property (strong,nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes;

@end

@implementation FMHorizontalMenuCollectionLayout

-(NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributes{
    if (_layoutAttributes == nil) {
        _layoutAttributes = [NSMutableArray array];
    }
    return _layoutAttributes;
}

/**
 获取每页最多有多少个选项
 
 @return 返回选项数
 */
-(NSInteger)maxNumberOfItemsPerPage{
    return self.rowCount * self.columCount;
}

-(NSInteger)currentPageCount{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSInteger maxCountPerPage = [self maxNumberOfItemsPerPage];
    if (maxCountPerPage == 0) {
        return 0;
    }
    return ((count % maxCountPerPage) == 0) ? (count / maxCountPerPage) : (int)(count * 1.0 / maxCountPerPage) + 1;
}

/**
 准备layout
 */
-(void)prepareLayout{
    // 清理数据源
    [self.layoutAttributes removeAllObjects];
    self.contentSize = CGSizeZero;
    // 预先计算好所有的 layout 属性
    // 预计算 contentSize
    // 先要拿到 到底有多少个 item
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSInteger maxCountPerPage = [self maxNumberOfItemsPerPage];
    
    // 计算一共多少页
    NSInteger pageCount = [self currentPageCount];
    
    //预计算了contengSize
    self.contentSize = CGSizeMake(pageCount * self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    
    //计算每个cell的属性大小
    for (NSInteger i = 0; i < count; i ++) {
        //创建索引
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //通过索引创建cell 布局属性
        // UICollectionViewLayoutAttributes 这个内部应该保存 cell 布局以及一些位置信息等等
        UICollectionViewLayoutAttributes *layoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        [self.layoutAttributes addObject:layoutAttribute];
    }
    
    NSInteger index = 0;
    NSInteger itemWidth = self.collectionView.frame.size.width /  self.columCount;
    NSInteger itemHeight = self.collectionView.frame.size.height / self.rowCount;
    
   //具体计算每个布局属性到底是多少
    for (NSInteger i = 0; i < pageCount; i ++) {
        for (NSInteger j = 0; j < self.rowCount; j ++) {
            for (NSInteger k = 0; k < self.columCount; k ++) {
                index = i * maxCountPerPage + j * self.columCount + k;
                
                if (index >= count) {break;}
                
                //当前获取的布局属性
                UICollectionViewLayoutAttributes *currentLayoutAttribute = self.layoutAttributes[i * maxCountPerPage + j * self.columCount + k];
                
                CGFloat x = i * self.collectionView.frame.size.width + k * itemWidth;
                CGFloat y = j * itemHeight;
                
                currentLayoutAttribute.frame = CGRectMake(x, y, itemWidth, itemHeight);
            }
            if (index >= count) {break;}
        }
        if (index >= count) {break;}
    }
}

-(CGSize)collectionViewContentSize{
    return self.contentSize;
}

/**
 在指定区域范围内需要提供cell信息

 @param rect 执行区域
 @return 属性列表
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray<UICollectionViewLayoutAttributes *> *visibledAttributes = [NSMutableArray array];
    [self.layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(obj.frame, rect)) {
            [visibledAttributes addObject:obj];
        }
    }];
    return visibledAttributes;
}
@end
