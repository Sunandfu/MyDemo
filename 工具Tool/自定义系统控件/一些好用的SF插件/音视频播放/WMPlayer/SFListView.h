//
//  SFListView.h
//  SFVideoPlayer
//
//  Created by lurich on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFListView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) double rate;
@property (nonatomic, copy) NSString *prefixStr;
@property (nonatomic, copy) NSString *suffixStr;

@property (nonatomic, copy) void(^clickBlock)(NSInteger index);

- (void)reloadData;

@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, strong) NSArray *videoUrlArray;
@property (nonatomic, copy) NSString *showType;

@end

NS_ASSUME_NONNULL_END
