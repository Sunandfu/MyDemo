//
//  YXNativeExpressAdController.m
//  TestAdA
//
//  Created by lurich on 2019/8/26.
//  Copyright © 2019 YX. All rights reserved.
//

#import "YXNativeExpressAdController.h"
#import "SFNativeExpressAdManager.h"
#import "YXFeedAdTableViewCell.h"

@interface YXNativeExpressAdController ()<UITableViewDelegate,UITableViewDataSource,YXImageTextAdManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YXNativeExpressAdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    SFNativeExpressAdManager *manager = [[SFNativeExpressAdManager alloc] init];
    manager.adSize = YXADSize228X150;
    manager.mediaId = @"dev_ios_templet";
    manager.adCount = 4;
    manager.controller = self;
    manager.delegate = self;
    [manager loadNativeExpressFeedAd];
    self.dataArray = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        [self.dataArray addObject:@"测试数据"];
    }
}

- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableHeaderView = [self tableViewHeaderView];
        [_tableView registerNib:[UINib nibWithNibName:@"YXFeedAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFeedAdTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    if ([model isKindOfClass:[YXFeedAdData class]]) {
        YXFeedAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXFeedAdTableViewCell" forIndexPath:indexPath];
        UIView *view = ((YXFeedAdData *)model).data;
        [cell.contentView addSubview:view];
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
        cell.textLabel.text = model;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    if ([model isKindOfClass:[YXFeedAdData class]]) {
        YXFeedAdData *modelData = model;
        UIView *view = modelData.data;
        return view.bounds.size.height;
    }else{
        return 80;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
/**
 加载成功的回调
 
 @param data  回调的广告素材
 */
- (void)didLoadFeedAd:(NSArray<YXFeedAdData*>*_Nullable)data{
    NSMutableArray *dataSources = [self.dataArray mutableCopy];
    if (data.count > 0) {
        for (YXFeedAdData * model in data) {
            uint32_t index = arc4random_uniform((uint32_t)self.dataArray.count);
            [dataSources insertObject:model atIndex:index];
        }
        self.dataArray = [dataSources copy];
        [self.tableView reloadData];
    }
}
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadFeedAd:(NSError* _Nonnull)error{
    NSLog(@"取广告失败调用 error = %@",error);
}
/**
 广告点击后回调
 */
- (void)didClickedFeedAd{
    NSLog(@"广告点击后回调");
}
/**
 广告被关闭
 */
- (void)nativeExpressAdClose{
    NSLog(@"广告被关闭");
}


/**
 广告渲染成功
 */
- (void)didFeedAdRenderSuccess:(NSArray<YXFeedAdData *> *)data{
//    if (data.count>0) {
//        NSMutableArray *dataSources = [self.dataArray mutableCopy];
//        for (int i=0; i<self.dataArray.count; i++) {
//            id dataModel = self.dataArray[i];
//            if ([dataModel isKindOfClass:[YXFeedAdData class]]) {
//                YXFeedAdData *newModel = dataModel;
//                for (YXFeedAdData *model in data) {
//                    if (model.adID == newModel.adID) {
//                        [dataSources replaceObjectAtIndex:i withObject:model];
//                    }
//                }
//            }
//        }
//        self.dataArray = [dataSources mutableCopy];
//        [self.tableView reloadData];
//    }
    NSLog(@"广告渲染成功");
}


@end
