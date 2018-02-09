//
//  LeafProgressView.h
//  树叶进度效果
//
//  Created by PengXiaodong on 16/1/27.
//  Copyright © 2016年 Tomy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafProgressView : UIView

- (void)startLoading;
- (void)stopLoading;

//0-1
- (void)setProgress:(CGFloat)rate;
@end
