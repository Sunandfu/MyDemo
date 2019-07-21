//
//  SFChannelCell.h
//  SFChannelTag
//
//  Created by Shin on 2017/11/26.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFChannel.h"

@protocol SFChannelCellDeleteDelegate

- (void)deleteCell:(UIButton *)sender;

@end


@interface SFChannelCell : UICollectionViewCell

/**
 样式
 */
@property (nonatomic, assign) SFChannelType style ;

/**
 标题
 */
@property (nonatomic, strong) UILabel *title ;
/** 右上角的删除按钮 */
@property (nonatomic, strong) UIButton * delBtn ;


@property (nonatomic, assign) id <SFChannelCellDeleteDelegate> delegate ;

@property (nonatomic, strong) SFChannel *model ;

@end
