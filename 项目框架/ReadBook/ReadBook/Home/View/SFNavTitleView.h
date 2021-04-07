//
//  SFNavTitleView.h
//  ReadBook
//
//  Created by lurich on 2020/11/10.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNavTitleView : UIView

@property(nonatomic, assign) CGSize intrinsicContentSize;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
