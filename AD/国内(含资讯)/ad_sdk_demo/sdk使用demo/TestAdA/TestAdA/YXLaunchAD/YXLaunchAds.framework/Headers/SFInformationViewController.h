//
//  SFInformationViewController.h
//  TestAdA
//
//  Created by lurich on 2019/4/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFInformationViewController : UIViewController
/** 必传参数 **/
@property (nonatomic, copy) NSString *mediaId;
@property (nonatomic, copy) NSString *mLocationId;
/** 可选参数  设置颜色相关属性时 请务必使用RGBA空间的颜色值   **/
///自定义设置
/** 是否显示分割线条 默认为YES*/
@property (assign, nonatomic) BOOL showDemarcationLine;
/** 分割线条的颜色 */
@property (strong, nonatomic) UIColor *scrollDemarcationLineColor;
/** 是否显示滚动条 默认为NO*/
@property (assign, nonatomic) BOOL showLine;
/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat scrollLineHeight;
/** 滚动条的颜色 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** 标题之间的间隙 */
@property (assign, nonatomic) CGFloat titleMargin;
/** 标题的字体 */
@property (strong, nonatomic) UIFont *titleFont;
/** 标题缩放倍数, 默认1.2 */
@property (assign, nonatomic) CGFloat titleBigScale;
/** 标题一般状态的颜色 */
@property (strong, nonatomic) UIColor *normalTitleColor;
/** 标题选中状态的颜色 */
@property (strong, nonatomic) UIColor *selectedTitleColor;
/** 滚动View的背景颜色 */
@property (strong, nonatomic) UIColor *backGroundColor;
//返回图片
@property (nonatomic, strong) UIImage *backImage;

@end

NS_ASSUME_NONNULL_END
