//
//  LNReaderSettingView.h
//  LookNovel
//
//  Created by wangchengshan on 2019/5/21.
//  Copyright © 2019 wcs Co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSetModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LNReaderSettingViewDelegate <NSObject>

- (void)settingViewDidClickSkinAtIndex:(NSInteger)index;

- (void)settingViewDidChangeFontSize:(float)size;

- (void)settingViewDidChangeLineHeight:(float)height;

- (void)settingViewDidChangeParagraphHeight:(float)height;

- (void)settingViewDidChangeBright:(float)bright;

- (void)settingViewDidChangeSwitch:(BOOL)on;

@end

@interface LNReaderSettingView : UIView
/**设置模式*/
@property (nonatomic, strong) ReadSetModel *currentModel;

@property (nonatomic, strong) NSArray<ReadSetModel *> *skinList;

@property (nonatomic, weak) id<LNReaderSettingViewDelegate> delegate;

@property (nonatomic, assign) float fontSize;

@property (nonatomic, assign) float lineHeight;

@property (nonatomic, assign) float paragraphHeight;

- (void)cancelAllSelect;
- (void)setSelectAtIndex:(NSInteger)index;
- (void)setBright:(float)bright;
- (void)setNotLock:(BOOL)lock;
@end

NS_ASSUME_NONNULL_END
