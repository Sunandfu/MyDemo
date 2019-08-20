//
//  SFNewsConfiguration.h
//  TestAdA
//
//  Created by lurich on 2019/7/22.
//  Copyright © 2019 YX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



#pragma mark - 公共属性
@interface SFNewsConfiguration : NSObject

+(SFNewsConfiguration *)defaultConfiguration;

/** 标题字体大小 */
@property(nonatomic,strong) UIFont *titleFont;
/** 标题字体颜色 */
@property(nonatomic,strong) UIColor *titleColor;

/** 来源、时间字体大小 */
@property(nonatomic,strong) UIFont *fromFont;
/** 来源、时间字体颜色 */
@property(nonatomic,strong) UIColor *fromColor;

/** 图片圆角设置 */
@property CGFloat cornerRadius;


@end

NS_ASSUME_NONNULL_END
