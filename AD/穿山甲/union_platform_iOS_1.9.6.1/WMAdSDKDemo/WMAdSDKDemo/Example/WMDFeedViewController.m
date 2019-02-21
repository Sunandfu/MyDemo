//
//  WMDFeedViewController.m
//  WMDemo
//
//  Created by chenren on 25/05/2017.
//  Copyright © 2017 chenren. All rights reserved.
//

#import "WMDFeedViewController.h"

#import <WMAdSDK/WMNativeAdsManager.h>
#import "WMDFeedAdTableViewCell.h"

@interface WMDFeedViewController () <UITableViewDataSource, UITableViewDelegate, WMNativeAdsManagerDelegate, WMVideoAdViewDelegate,WMNativeAdDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) WMNativeAdsManager *adManager;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation WMDFeedViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _adManager.delegate = nil;
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[WMDFeedAdLeftTableViewCell class] forCellReuseIdentifier:@"WMDFeedAdLeftTableViewCell"];
    [self.tableView registerClass:[WMDFeedAdLargeTableViewCell class] forCellReuseIdentifier:@"WMDFeedAdLargeTableViewCell"];
    [self.tableView registerClass:[WMDFeedAdGroupTableViewCell class] forCellReuseIdentifier:@"WMDFeedAdGroupTableViewCell"];
    [self.tableView registerClass:[WMDFeedVideoAdTableViewCell class] forCellReuseIdentifier:@"WMDFeedVideoAdTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self loadNativeAds];
    
    NSMutableArray *datas = [NSMutableArray array];
    for (NSInteger i =0 ; i <= 37; i++) {
        [datas addObject:@"App的tableViewcell"];
    }
    self.dataSource = [datas copy];
    
    [self.tableView reloadData];
}

- (void)loadNativeAds {
    WMNativeAdsManager *nad = [WMNativeAdsManager new];
    WMAdSlot *slot1 = [[WMAdSlot alloc] init];
    slot1.ID = self.viewModel.slotID;
    slot1.AdType = WMAdSlotAdTypeFeed;
    slot1.position = WMAdSlotPositionTop;
    slot1.imgSize = [WMSize sizeBy:WMProposalSize_Feed690_388];
    slot1.isSupportDeepLink = YES;
    nad.adslot = slot1;
    nad.delegate = self;
    self.adManager = nad;
    
    [nad loadAdDataWithCount:3];
}

- (void)nativeAdsManagerSuccessToLoad:(WMNativeAdsManager *)adsManager nativeAds:(NSArray<WMNativeAd *> *_Nullable)nativeAdDataArray {
    NSString *info = [NSString stringWithFormat:@"获取了%tu条广告", nativeAdDataArray.count];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"广告" message:info delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    for (WMNativeAd *model in nativeAdDataArray) {
        NSUInteger index = rand() % dataSources.count;
        [dataSources insertObject:model atIndex:index];
    }
    self.dataSource = [dataSources copy];
    
    [self.tableView reloadData];
}

- (void)nativeAdsManager:(WMNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // For ad cells just as the ad cell provider, for normal cells do whatever you would do.
    BOOL isVideoCell = NO;
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[WMNativeAd class]]) {
        WMNativeAd *nativeAd = (WMNativeAd *)model;
        nativeAd.rootViewController = self;
        nativeAd.delegate = self;
        UITableViewCell<WMDFeedCellProtocol> *cell = nil;
        if (nativeAd.data.imageMode == WMFeedADModeSmallImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMDFeedAdLeftTableViewCell" forIndexPath:indexPath];
        } else if (nativeAd.data.imageMode == WMFeedADModeLargeImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMDFeedAdLargeTableViewCell" forIndexPath:indexPath];
        } else if (nativeAd.data.imageMode == WMFeedADModeGroupImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMDFeedAdGroupTableViewCell" forIndexPath:indexPath];
        } else if (nativeAd.data.imageMode == WMFeedVideoAdModeImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"WMDFeedVideoAdTableViewCell" forIndexPath:indexPath];
            // 设置代理，用于监听播放状态
            isVideoCell = YES;
        }
        
        WMInteractionType type = nativeAd.data.interactionType;
        if (cell) {
            [cell refreshUIWithModel:nativeAd];
            if (isVideoCell) {
                WMDFeedVideoAdTableViewCell *videoCell = (WMDFeedVideoAdTableViewCell *)cell;
                videoCell.nativeAdRelatedView.videoAdView.delegate = self;
                [nativeAd registerContainer:videoCell withClickableViews:@[videoCell.creativeButton]];
            } else {
                if (type == WMInteractionTypeDownload) {
                    [cell.customBtn setTitle:@"点击下载" forState:UIControlStateNormal];
                    [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
                } else if (type == WMInteractionTypePhone) {
                    [cell.customBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
                    [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
                } else if (type == WMInteractionTypeURL) {
                    [cell.customBtn setTitle:@"外部拉起" forState:UIControlStateNormal];
                    [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
                } else if (type == WMInteractionTypePage) {
                    [cell.customBtn setTitle:@"内部拉起" forState:UIControlStateNormal];
                    [nativeAd registerContainer:cell withClickableViews:@[cell.customBtn]];
                } else {
                    [cell.customBtn setTitle:@"无点击" forState:UIControlStateNormal];
                }
            }
            return cell;
        }
    }
    NSString *text = [NSString stringWithFormat:@"%@", model];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // The ad cell provider knows the height of ad cells based on its configuration
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[WMNativeAd class]]) {
        WMNativeAd *nativeAd = (WMNativeAd *)model;
        CGFloat width = CGRectGetWidth(self.tableView.bounds);
        if (nativeAd.data.imageMode == WMFeedADModeSmallImage) {
            return [WMDFeedAdLeftTableViewCell cellHeightWithModel:nativeAd width:width];
        } else if (nativeAd.data.imageMode == WMFeedADModeLargeImage) {
            return [WMDFeedAdLargeTableViewCell cellHeightWithModel:nativeAd width:width];
        } else if (nativeAd.data.imageMode == WMFeedADModeGroupImage) {
            return [WMDFeedAdGroupTableViewCell cellHeightWithModel:nativeAd width:width];
        } else if (nativeAd.data.imageMode == WMFeedVideoAdModeImage) {
            return [WMDFeedVideoAdTableViewCell cellHeightWithModel:nativeAd width:width];
        }
    }
    return 80;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[WMNativeAd class]]) {
        WMNativeAd *nativeAd = (WMNativeAd *)model;
        CGFloat width = CGRectGetWidth(self.tableView.bounds);
        if (nativeAd.data.imageMode == WMFeedADModeSmallImage) {
            return [WMDFeedAdLeftTableViewCell cellHeightWithModel:nativeAd width:width];
        } else if (nativeAd.data.imageMode == WMFeedADModeLargeImage) {
            return [WMDFeedAdLargeTableViewCell cellHeightWithModel:nativeAd width:width];
        } else if (nativeAd.data.imageMode == WMFeedADModeGroupImage) {
            return [WMDFeedAdGroupTableViewCell cellHeightWithModel:nativeAd width:width];
        } else if (nativeAd.data.imageMode == WMFeedVideoAdModeImage) {
            return [WMDFeedVideoAdTableViewCell cellHeightWithModel:nativeAd width:width];
        }
    }
    return 80;
}

#pragma mark
- (void)nativeAd:(WMNativeAd *)nativeAd dislikeWithReason:(NSArray<WMDislikeWords *> *)filterWords {
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    [dataSources removeObject:nativeAd];
    self.dataSource = [dataSources copy];
    [self.tableView reloadData];
}

- (void)videoAdView:(WMVideoAdView *)videoAdView stateDidChanged:(WMPlayerPlayState)playerState {
    NSLog(@"videoAdView state change to %ld", (long)playerState);
}

- (void)videoAdView:(WMVideoAdView *)videoAdView didLoadFailWithError:(NSError *)error {
    NSLog(@"videoAdView didLoadFailWithError");
}

- (void)playerDidPlayFinish:(WMVideoAdView *)videoAdView {
    NSLog(@"videoAdView didPlayFinish");
}

@end
