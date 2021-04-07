//
//  SFMovableButton.h
//  SFMovableButton
//
//  Created by 王少帅 on 2017/9/21.
//  Copyright © 2017年 王少帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFMovableButton : UIButton

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end
