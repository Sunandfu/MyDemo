//
//  DropDownMenuList.h
//  DropDownMenuList
//
//  Created by 王会洲 on 16/5/13.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface HZIndexPath : NSObject
@property (nonatomic, assign) NSInteger  row; // 行
@property (nonatomic, assign) NSInteger  column; //列
// 构造HZIndexPath
+(instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;

@end

@class DropDownMenuList;

@protocol DropDownMenuListDataSouce <NSObject>
@required
// 设置显示列的内容
-(NSMutableArray *)menuNumberOfRowInColumn;
// 设置多少行显示
-(NSInteger)menu:(DropDownMenuList *)menu numberOfRowsInColum:(NSInteger)column;
// 设置显示没行的内容
-(NSString *)menu:(DropDownMenuList *)menu titleForRowAtIndexPath:(HZIndexPath *)indexPath;


@optional
// 每行图片
-(NSString *)menu:(DropDownMenuList *)menu imageNameForRowAtIndexPath:(HZIndexPath *)indexPath;

@end


@protocol DropDownMenuListDelegate <NSObject>
@optional
// 点击每一行的效果
- (void)menu:(DropDownMenuList *)segment didSelectRowAtIndexPath:(HZIndexPath *)indexPath;
// 点击没一列的效果
- (void)menu:(DropDownMenuList *)segment didSelectTitleAtColumn:(NSInteger)column;

@end


@interface DropDownMenuList : UIView<UITableViewDataSource,UITableViewDelegate>


// 显示
+(instancetype)show:(CGPoint)orgin andHeight:(CGFloat)height;


// 代理
@property (nonatomic, weak) id<DropDownMenuListDelegate>  delegate;
@property (nonatomic, weak) id<DropDownMenuListDataSouce>  dataSource;

//##################################


// 获取Title
-(NSString *)titleForRowAtIndexPath:(HZIndexPath *)indexPath;

-(instancetype)initWithOrgin:(CGPoint)origin andHeight:(CGFloat)height;

/*！
 *  页面即可消失没有动画
 *  解决在退出界面时，当前window上继续保留原有界面的bug
 * 看官只需要在你调用的VC上得viewWillDisappear里调用该方法
 */
-(void)rightNowDismis;

@end
