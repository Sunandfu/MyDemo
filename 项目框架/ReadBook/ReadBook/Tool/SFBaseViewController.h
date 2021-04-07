//
//  SFBaseViewController.h
//  ReadBook
//
//  Created by lurich on 2020/5/21.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFNetWork.h"
#import "SFTool.h"
#import "BookTableViewCell.h"
#import "DetailViewController.h"
#import "NSObject+SF_MJParse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFBaseViewController : UIViewController

- (void)updateFrameWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
