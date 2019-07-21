//
//  SFPageTableViewController.m
//  SFScrollPageView
//
//  Created by ZeroJ on 16/8/31.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "SFPageTableViewController.h"
#import "FeedMessageTableViewCellOne.h"
#import "FeedMessageTableViewCellTwo.h"
#import "FeedMessageTableViewCellThree.h"
#import "FeedMessageTableViewCellFour.h"
#import "FeedMessageTableViewCellFive.h"
#import "FeedMessageTableViewCellSix.h"
#import "SDKADTableViewCell.h"
#import "Network.h"
#import "NetTool.h"
#import "YXReachability.h"
#import "MJRefresh.h"
#import "YXWebViewController.h"
#import "YXFeedAdManager.h"
#import "YXFeedAdData.h"
#import "SFTagBtnView.h"

@interface SFPageTableViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,SFTagBtnViewDelegate>{
    BOOL isVideo;
}

@property (strong, nonatomic) NSMutableArray *zhidingArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) YXFeedAdManager *feedManager;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger isFirst;
@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, copy) NSString *startKeyStr;
@property (nonatomic, strong) UILabel *tmpLabel;
@property (assign, nonatomic) NSInteger videoLastIndex;
@property (nonatomic, strong) NSArray *videoTitleArray;
@property (nonatomic, strong) SFTagBtnView *textBtnView;
@property (nonatomic, strong) UIScrollView *headerView;

@end

@implementation SFPageTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    if (@available(iOS 11.0, *)) {
    //        self.tableView.contentInsetAdjustmentBehavior = NO;
    //    } else {
    //        // Fallback on earlier versions
    //        self.automaticallyAdjustsScrollViewInsets = NO;
    //    }
}
- (void)sf_viewDidLoadForIndex:(NSInteger)index {
    [[NSUserDefaults standardUserDefaults] setObject:self.mediaId forKey:@"mediaId"];
    [[NSUserDefaults standardUserDefaults] setObject:self.mLocationId forKey:@"mLocationId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SF_ScreenW, SF_ScreenH-SF_StatusBarAndNavigationBarHeight-(self.segmentHeight?self.segmentHeight:44.0)) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/FeedMessageTableViewCellOne" bundle:nil] forCellReuseIdentifier:@"FeedMessageCellOneID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/FeedMessageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:@"FeedMessageCellTwoID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/FeedMessageTableViewCellThree" bundle:nil] forCellReuseIdentifier:@"FeedMessageCellThreeID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/FeedMessageTableViewCellFour" bundle:nil] forCellReuseIdentifier:@"FeedMessageCellFourID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/FeedMessageTableViewCellFive" bundle:nil] forCellReuseIdentifier:@"FeedMessageCellFiveID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/FeedMessageTableViewCellSix" bundle:nil] forCellReuseIdentifier:@"FeedMessageCellSixID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/SDKADTableViewCell" bundle:nil] forCellReuseIdentifier:@"SDKADTableViewCellID"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    self.zhidingArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.videoTitleArray = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.startKeyStr = @"";
    self.pageIndex = 1;
    self.isFirst = 1;
    self.videoLastIndex = 0;
    isVideo = NO;
    __weak typeof(self) weakSelf = self;
    /// 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNetWorkDataWithTop:YES];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    /// 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex += 1;
        [weakSelf getNetWorkDataWithTop:NO];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
}
- (void)sf_viewWillAppearForIndex:(NSInteger)index{
    self.index = index;
}
- (void)sf_viewDidAppearForIndex:(NSInteger)index {
    //    NSLog(@"已经出现   标题: --- %@  index: -- %ld", self.title, index);
}
- (void)getNetWorkDataWithTop:(BOOL)isTop{
    NSDictionary *titleDict = self.titleArray[self.index];
    NSString *ydCatIdStr = titleDict[@"ydCatId"];
    if ([ydCatIdStr isEqualToString:@"1098"]) {
        isVideo = YES;
        if (_textBtnView==nil) {
            WEAK(weakSelf);
            [Network getJSONDataWithURL:[NSString stringWithFormat:@"%@/social/getVideoCat?mLocationId=%@",NewsSeverin,self.mLocationId] parameters:nil success:^(id json) {
                if ([json isKindOfClass:[NSArray class]]) {
                    weakSelf.videoTitleArray = [NSArray arrayWithArray:json];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self createHeaderView];
                    });
                    if (weakSelf.videoTitleArray.count>0) {
                        NSDictionary *videoTitleDict = [weakSelf.videoTitleArray firstObject];
                        NSString *videoCatIdStr = videoTitleDict[@"ydCatId"];
                        [self normalWithTop:isTop CatID:videoCatIdStr Url:@"getYdVideoFeed"];
                    }
                } else {
                    [weakSelf.tableView.mj_header endRefreshing];
                    [weakSelf.tableView.mj_footer endRefreshing];
                    NSLog(@"error = %@",json);
                }
            } fail:^(NSError *error) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
                NSLog(@"video catID request error = %@",error);
            }];
        } else {
            if (self.videoTitleArray.count > self.videoLastIndex) {
                NSDictionary *videoTitleDict = [self.videoTitleArray objectAtIndex:self.videoLastIndex];
                NSString *videoCatIdStr = videoTitleDict[@"ydCatId"];
                [self normalWithTop:isTop CatID:videoCatIdStr Url:@"getYdVideoFeed"];
            }
        }
        
    } else {
        isVideo = NO;
        [self normalWithTop:isTop CatID:ydCatIdStr Url:@"getYdFeed"];
    }
}
- (void)normalWithTop:(BOOL)isTop CatID:(NSString *)ydCatIdStr Url:(NSString *)urlShort{
    NSString *url = [NSString stringWithFormat:@"%@/social/%@?userId=%@&mLocationId=%@&catId=%@&pageIndex=%@&startKey=%@&isFirst=%@",NewsSeverin,urlShort,self.mediaId,self.mLocationId,ydCatIdStr,isTop?@(1):@(self.pageIndex),self.startKeyStr,@(self.isFirst)];
    
    NSString *yun = [NetTool getYunYingShang];
    NSInteger operator;
    if ([yun isEqualToString:@"中国电信"]) {
        operator = 2;
    }else if ([yun isEqualToString:@"中国移动"]) {
        operator = 1;
    }else if ([yun isEqualToString:@"中国联通"]) {
        operator = 3;
    }else if ([yun isEqualToString:@"无运营商"]) {
        operator = 0;
    }else{
        operator = 99;
    }
    
    NSMutableDictionary *parametDict = [NSMutableDictionary dictionary];
    [parametDict setValue:@"1"                           forKey:@"deviceType"];
    [parametDict setValue:@"2"                           forKey:@"osType"];
    [parametDict setValue:[NetTool getOS]                forKey:@"osVersion"];
    [parametDict setValue:@"apple"                       forKey:@"vendor"];
    [parametDict setValue:[NetTool gettelModel]          forKey:@"model"];
    [parametDict setValue:@""                            forKey:@"imei"];
    [parametDict setValue:@""                            forKey:@"androidId"];
    [parametDict setValue:[NetTool getIDFA]              forKey:@"idfa"];
    [parametDict setValue:[Network sharedInstance].ipStr forKey:@"ipv4"];
    [parametDict setValue:@([NetTool getNetTyepe])       forKey:@"connectionType"];
    [parametDict setValue:@(operator)                    forKey:@"operateType"];
    [parametDict setValue:@""                            forKey:@"longitude"];
    [parametDict setValue:@""                            forKey:@"latitude"];
    __weak typeof(self) weakSelf = self;
    // 加载数据
    [Network postJSONDataWithURL:url parameters:parametDict success:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (![json isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSDictionary *dataDic = json;
        if (dataDic[@"baseResponse"]) {
            NSDictionary *successDict = dataDic[@"baseResponse"];
            if ([successDict[@"msg"] isEqualToString:@"success"]) {
                if (self.isFirst==1 && self.isInfo==NO) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getDataSuccess" object:nil];
                }
                self.isFirst = 2;
                NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
                if (isTop) {
                    [weakSelf.zhidingArray removeAllObjects];
                }
                NSArray *dataTmpArr = dataDic[@"feeds"];
                for (NSDictionary *dict in dataTmpArr) {
                    [Network newsStatisticsWithType:2 NewsID:dict[@"id"]?dict[@"id"]:@"" CatID:ydCatIdStr lengthOfTime:0];
                    if ([dict[@"isTop"] isEqualToString:@"1"]) {
                        [weakSelf.zhidingArray addObject:dict];
                    } else {
                        if (dict) {
                            [tmpArray addObject:dict];
                        }
                    }
                    
                    NSString *rowKeyStr = [NSString stringWithFormat:@"%@",dict[@"rowKey"]];
                    if (dict[@"rowKey"] && ![dict[@"rowKey"] isKindOfClass:[NSNull class]] && ![rowKeyStr isEqualToString:@"0"]) {
//                        NSLog(@"rowKeyStr = %@",rowKeyStr);
                        weakSelf.startKeyStr = rowKeyStr;
                    }
                    if (dict[@"showReportUrl"]) {
                        if ([dict[@"showReportUrl"] isKindOfClass:[NSArray class]]) {
                            NSArray *showReportUrlArr = dict[@"showReportUrl"];
                            for (NSString *showReportUrl in showReportUrlArr) {
                                if (![showReportUrl isKindOfClass:[NSNull class]] && [showReportUrl hasPrefix:@"http"]) {
                                    [Network postJSONDataWithURL:showReportUrl parameters:nil success:nil fail:nil];
                                }
                            }
                        } else if ([dict[@"showReportUrl"] isKindOfClass:[NSString class]]) {
                            if ([dict[@"showReportUrl"] hasPrefix:@"http"]) {
                                [Network postJSONDataWithURL:dict[@"showReportUrl"] parameters:nil success:nil fail:nil];
                            }
                        }
                    }
                }
                
                if (isTop) {
                    [weakSelf.dataArray insertObjects:tmpArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tmpArray.count)]];
                } else {
                    [weakSelf.dataArray addObjectsFromArray:tmpArray];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.dataArray.count>0) {
                        weakSelf.tableView.tableFooterView = [UIView new];
                    }
                    [weakSelf.tableView reloadData];
                });
            }
        } else {
            NSLog(@"error message = %@",dataDic[@"message"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.dataArray.count<=0) {
                    UIView *footerView = [[UIView alloc] initWithFrame:self.tableView.bounds];
                    footerView.backgroundColor = [UIColor whiteColor];
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 311)];
                    imageView.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_pic"];
                    imageView.center = footerView.center;
                    [footerView addSubview:imageView];
                    self.tableView.tableFooterView = footerView;
                }
                if (self.isFirst==1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getDataFail" object:nil];
                }
            });
        }
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.dataArray.count<=0) {
                UIView *footerView = [[UIView alloc] initWithFrame:self.tableView.bounds];
                footerView.backgroundColor = [UIColor whiteColor];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 311)];
                imageView.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_pic"];
                imageView.center = footerView.center;
                [footerView addSubview:imageView];
                self.tableView.tableFooterView = footerView;
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            if (self.isFirst==1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getDataFail" object:nil];
            }
        });
    }];
}
- (SFTagBtnView *)textBtnView{
    if (_textBtnView==nil) {
        _textBtnView = [[SFTagBtnView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20.0)];
        _textBtnView.backgroundColor = [UIColor whiteColor];
        _textBtnView.isRandomColor = YES;//单选
        _textBtnView.delegate = self;
        _textBtnView.textFontSize = 14.0;
        _textBtnView.btnHeight = 25.0;
    }
    return _textBtnView;
}
- (void)createHeaderView{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.videoTitleArray) {
        [titles addObject:dict[@"ydCatName"]];
    }
    self.textBtnView.textArr = titles;
    self.textBtnView.defultIndexArr = @[[titles firstObject]];
//    NSLog(@"%f", self.textBtnView.maxY);
}

- (void)SFTagBtnViewClickIndex:(NSInteger)index lastClickIndex:(NSInteger)lastClickIndex{
//    NSLog(@"index === %ld , lastClickIndex === %ld", index, lastClickIndex);
    self.videoLastIndex = index;
    [self.zhidingArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self getNetWorkDataWithTop:YES];
}

- (void)SFTagBtnViewSelectIndexes:(NSArray *)indexes{
    
}
- (void)sf_viewDidDisappearForIndex:(NSInteger)index {
    //    NSLog(@"已经消失   标题: --- %@  index: -- %ld", self.title, index);
    
}

#pragma mark- SFScrollPageViewChildVcDelegate

#pragma mark- UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.zhidingArray.count;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict;
    if (indexPath.section==0) {
        dict = self.zhidingArray[indexPath.row];
    } else {
        dict = self.dataArray[indexPath.row];
    }
    NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([type isEqualToString:@"sdkads"]) {//SDK 广告
        if (dict[@"id"]) {
            self.feedManager.mediaId = dict[@"id"];
            [self.feedManager loadsingleFeedAdSuccess:^(YXFeedAdData * _Nonnull model) {
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:@{@"model":model,@"type":@"sdkads"}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } fail:^(NSError * _Nonnull error) {
                //                                NSLog(@"请求SDK广告失败");
            }];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoTmpID"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"demoTmpID"];
            }
            return cell;
        } else {
            YXFeedAdData *model = dict[@"model"];
            if (model) {
                SDKADTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SDKADTableViewCellID" forIndexPath:indexPath];
                [cell cellDataWithFeedAdModel:model];
                [self.feedManager registerAdViewForInCell:cell adData:model];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoTmpID"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"demoTmpID"];
                }
                return cell;
            }
        }
    } else if ([type isEqualToString:@"video"] || [type isEqualToString:@"videoads"]) {//视频内容
        if (isVideo) {
            FeedMessageTableViewCellSix *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMessageCellSixID" forIndexPath:indexPath];
            [cell cellDataWithDictionary:dict];
            return cell;
        } else {
            FeedMessageTableViewCellFive *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMessageCellFiveID" forIndexPath:indexPath];
            [cell cellDataWithDictionary:dict];
            return cell;
        }
    } else {
        NSString *displayStyle = [NSString stringWithFormat:@"%@",dict[@"displayStyle"]];
        if ([displayStyle isEqualToString:@"0"]) {
            FeedMessageTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMessageCellOneID" forIndexPath:indexPath];
            [cell cellDataWithDictionary:dict];
            return cell;
        } else if ([displayStyle isEqualToString:@"1"]) {
            FeedMessageTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMessageCellTwoID" forIndexPath:indexPath];
            [cell cellDataWithDictionary:dict];
            return cell;
        } else if ([displayStyle isEqualToString:@"2"]) {
            FeedMessageTableViewCellThree *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMessageCellThreeID" forIndexPath:indexPath];
            [cell cellDataWithDictionary:dict];
            return cell;
        } else if ([displayStyle isEqualToString:@"3"]) {
            FeedMessageTableViewCellFour *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMessageCellFourID" forIndexPath:indexPath];
            [cell cellDataWithDictionary:dict];
            return cell;
        } else {
            FeedMessageTableViewCellFive *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMessageCellFiveID" forIndexPath:indexPath];
            [cell cellDataWithDictionary:dict];
            return cell;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        if (isVideo) {
            if (_textBtnView==nil) {
                return nil;
            }
            return self.headerView;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}
- (UIScrollView *)headerView{
    if (_headerView==nil) {
        _headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85)];
        _headerView.backgroundColor = [UIColor whiteColor];
        self.textBtnView.frame = CGRectMake(0, 10, SF_ScreenW, self.textBtnView.maxY);
        _headerView.contentSize = CGSizeMake(SF_ScreenW, self.textBtnView.maxY+20);
        [_headerView addSubview:self.textBtnView];
    }
    return _headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        if (isVideo) {
            return self.textBtnView.maxY+20>85?85:self.textBtnView.maxY+20;
        } else {
            return CGFLOAT_MIN;
        }
    } else {
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict;
    if (indexPath.section==0) {
        dict = self.zhidingArray[indexPath.row];
    } else {
        dict = self.dataArray[indexPath.row];
    }
    NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([type isEqualToString:@"sdkads"]) {//SDK 广告
        YXFeedAdData *model = dict[@"model"];
        if (model==nil) {
            return CGFLOAT_MIN;
        } else {
            CGFloat contentHeight = [self cellHeightWithMsg:model.adTitle];
            if (contentHeight>40) {
                contentHeight = 40;
            }
            CGFloat height = (230 + contentHeight) * self.view.bounds.size.width /375;
            return height;
        }
    } else if ([type isEqualToString:@"video"] || [type isEqualToString:@"videoads"]) {//视频内容
        if (isVideo) {
            CGFloat contentHeight = [self cellHeightWithMsg:dict[@"title"]];
            CGFloat height = (260 + contentHeight) * self.view.bounds.size.width /375;
            return height;
        } else {
            CGFloat contentHeight = [self cellHeightWithMsg:dict[@"title"]];
            CGFloat height = (283 + contentHeight) * self.view.bounds.size.width /375;
            return height;
        }
    } else {
        NSString *displayStyle = [NSString stringWithFormat:@"%@",dict[@"displayStyle"]];
        CGFloat contentHeight = [self cellHeightWithMsg:dict[@"title"]];
        if (contentHeight>40) {
            contentHeight = 40;
        }
        if ([displayStyle isEqualToString:@"0"]) {
            CGFloat height = 105 * self.view.bounds.size.width /375;
            return height;
        } else if ([displayStyle isEqualToString:@"1"]) {
            CGFloat height = (140 + contentHeight) * self.view.bounds.size.width /375;
            return height;
        } else if ([displayStyle isEqualToString:@"2"]) {
            CGFloat height = (230 + contentHeight) * self.view.bounds.size.width /375;
            return height;
        } else if ([displayStyle isEqualToString:@"3"]) {
            CGFloat height = (185 + contentHeight) * self.view.bounds.size.width /375;
            return height;
        } else {
            CGFloat height = (283 + contentHeight) * self.view.bounds.size.width /375;
            return height;
        }
    }
}
- (CGFloat)cellHeightWithMsg:(NSString *)msg
{
    self.tmpLabel.text = msg;
    CGSize size = [self.tmpLabel sizeThatFits:CGSizeMake(SF_ScreenW-30, CGFLOAT_MAX)];
    return size.height;
}
- (UILabel *)tmpLabel{
    if (!_tmpLabel) {
        _tmpLabel = [[UILabel alloc] init];
        _tmpLabel.font = [UIFont systemFontOfSize:HFont(18) weight:UIFontWeightRegular];
        _tmpLabel.numberOfLines = 0;
    }
    return _tmpLabel;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict;
    if (indexPath.section==0) {
        dict = self.zhidingArray[indexPath.row];
    } else {
        dict = self.dataArray[indexPath.row];
    }
    NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([type isEqualToString:@"sdkads"]) {//SDK 广告
        return;
    }
    //    NSLog(@"点击了%ld行----", indexPath.row);
    YXWebViewController *webVC = [YXWebViewController new];
    NSString *urlStr = [NSString stringWithFormat:@"%@",dict[@"detailUrl"]];
    NSString *original = [NSString stringWithFormat:@"%@",dict[@"isOriginal"]];
    if (dict[@"isOriginal"] && [original isEqualToString:@"1"]) {
        
    } else {
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    webVC.URLString = urlStr;
    webVC.show = NO;
    NSDictionary *titleDict = self.titleArray[self.index];
    NSString *ydCatIdStr = titleDict[@"ydCatId"];
    webVC.catIdStr = ydCatIdStr;
    webVC.newsIdStr = dict[@"id"];
    webVC.hidesBottomBarWhenPushed = YES;
    if (self.navigationController) {
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        [self presentViewController:webVC animated:YES completion:nil];
    }
    if (dict[@"clickReportUrl"] && [dict[@"clickReportUrl"] isKindOfClass:[NSString class]]) {
        [Network postJSONDataWithURL:dict[@"clickReportUrl"] parameters:nil success:nil fail:nil];
    }
    [Network newsStatisticsWithType:3 NewsID:dict[@"id"]?dict[@"id"]:@"" CatID:ydCatIdStr lengthOfTime:0];
}
- (void)dealloc{
    [NetTool clearNetImageChace];
    //    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.pageDelegate scrollViewIsScrolling:scrollView];
    }
}
- (YXFeedAdManager *)feedManager{
    if (!_feedManager) {
        _feedManager = [YXFeedAdManager new];
        _feedManager.adSize = YXADSize690X388;
        _feedManager.controller = self;
        _feedManager.adCount = 1;
    }
    return _feedManager;
}

@end
