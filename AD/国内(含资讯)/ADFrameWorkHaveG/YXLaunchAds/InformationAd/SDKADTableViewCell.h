//
//  SDKADTableViewCell.h
//  TestAdA
//
//  Created by lurich on 2019/6/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXFeedAdData;

NS_ASSUME_NONNULL_BEGIN

@interface SDKADTableViewCell : UITableViewCell

- (void)cellDataWithFeedAdModel:(YXFeedAdData *)model;

@end

NS_ASSUME_NONNULL_END
