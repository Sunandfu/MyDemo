//
//  SFMovieHeaderView.h
//  ReadBook
//
//  Created by lurich on 2020/10/14.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFMovieHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconViewImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

NS_ASSUME_NONNULL_END
