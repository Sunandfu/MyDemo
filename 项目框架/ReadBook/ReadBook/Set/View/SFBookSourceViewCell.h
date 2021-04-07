//
//  SFBookSourceViewCell.h
//  ReadBook
//
//  Created by lurich on 2020/11/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFBookSourceViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end

NS_ASSUME_NONNULL_END
