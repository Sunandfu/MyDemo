//
//  DragView.h
//  CardScrlDemo
//
//  Created by lotus on 2019/12/28.
//  Copyright © 2019 lotus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DragView : UIView

- (void)configText:(NSString *)text;
- (NSString *)dragText;
@end

NS_ASSUME_NONNULL_END
