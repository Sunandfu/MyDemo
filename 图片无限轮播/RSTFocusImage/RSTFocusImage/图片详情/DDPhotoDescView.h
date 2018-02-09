//
//  DDPhotoDescView.h
//  DDNews
//
//  Created by Dvel on 16/4/20.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScrW [UIScreen mainScreen].bounds.size.width
#define ScrH [UIScreen mainScreen].bounds.size.height
@interface DDPhotoDescView : UIView

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc index:(NSInteger)index totalCount:(NSInteger)totalCount;

@end
