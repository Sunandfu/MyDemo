//
//  DetailTableViewCell.h
//  ReadBook
//
//  Created by lurich on 2020/5/15.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SFTextView *textView;

@end

NS_ASSUME_NONNULL_END
