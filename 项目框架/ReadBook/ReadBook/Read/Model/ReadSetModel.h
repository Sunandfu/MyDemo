//
//  ReadModel.h
//  ReadBook
//
//  Created by lurich on 2020/5/15.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadSetModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *themeId;
@property (nonatomic, copy) NSString *isCustom;
@property (nonatomic, copy) NSString *normalIcon;
@property (nonatomic, copy) NSString *selectIcon;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *controlViewBgColor;
@property (nonatomic, copy) NSString *textColor;
@property (nonatomic, copy) NSString *settingTextColor;
@property (nonatomic, copy) NSString *sliderThumb;
@property (nonatomic, copy) NSString *settingBtnColor;
@property (nonatomic, copy) NSString *bgImage;
@property (nonatomic, copy) NSString *chapterColor;
@property (nonatomic, copy) NSString *sourceColor;

@end

NS_ASSUME_NONNULL_END
