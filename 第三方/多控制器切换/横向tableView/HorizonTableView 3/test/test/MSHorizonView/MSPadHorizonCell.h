//
//  MSPadHorizonCell.h
//  mushuIpad
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import <UIKit/UIView.h>
#import "MSPadHorizonSupport.h"

@interface MSPadHorizonCell : UIView
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) BOOL highlighted;

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL selectedHighlighted;
// 用这个生成，identifier为空则提供默认值
- (id)initWithReuseIdentifier:(NSString*)identifier;
- (void)prepareForReuse;
@end
