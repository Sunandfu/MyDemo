//
//  CocoaCollectionViewCell.h
//  CocoaPicker
//
//  Created by 薛泽军 on 15/11/25.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CocoaCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UILabel *durationLable;
@property (strong, nonatomic) IBOutlet UIImageView *typeIamgeView;
@property (strong,nonatomic)NSDictionary *cellDict;
@end
