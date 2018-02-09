//
//  TYCircleCollectionView.h
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCircleProtocol.h"

@protocol TYCircleMenuDelegate <NSObject>

- (void)selectMenuAtIndex:(NSInteger)index;

@end

@class TYCircleCollectionViewLayout;
@interface TYCircleCollectionView : UICollectionView<TYCircleProtocol>

@property (nonatomic,weak)   id<TYCircleMenuDelegate> menuDelegate;

/**
 *  选择item之后的回调隐藏menu的block
 */
@property (nonatomic, copy)  dispatch_block_t selecteBlock;

/**
 *  菜单的图片数组
 */
@property (nonatomic,copy)   NSArray *menuImages;

/**
 *  菜单的标题数组
 */
@property (nonatomic,copy)   NSArray *menuTitles;

@property (nonatomic,strong) TYCircleCollectionViewLayout *circleLayout;

- (instancetype)initWithFrame:(CGRect)frame itemOffset:(CGFloat)itemOffset imageArray:(NSArray *)images titleArray:(NSArray *)titles;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com