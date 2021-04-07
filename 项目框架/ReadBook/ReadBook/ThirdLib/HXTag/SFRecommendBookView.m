//
//  SFRecommendBookView.m
//  ReadBook
//
//  Created by lurich on 2020/7/27.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFRecommendBookView.h"
#import "SFNetWork.h"

@implementation SFRecommendBookView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nameArray = @[
        @{
            @"name":@"露露读书会",
            @"value":@[@"如何让你爱的人爱上你",@"羊皮卷",@"狼道",@"人性的弱点",@"所谓情商高，就是会说话",@"养育女孩",@"养育男孩",@"修心三不",@"口才三绝",@"为人三会",@"职场宝典",@"硅谷创业课",@"社交礼仪全书",@"鬼谷子",@"别让不好意思害了你",@"亲密关系"]},
        @{
            @"name":@"古典名著推荐",
            @"value":@[@"西游记",@"水浒传",@"三国演义",@"红楼梦",@"唐诗三百首",@"宋词",@"元曲",@"格林童话",@"安徒生童话",@"金庸",@"古龙",@"梁羽生"]}
        ];
        self.dataArray = [NSMutableArray arrayWithArray:nameArray];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [UIView new];
//        [self.tableView registerClass:HXTagsCell.class forCellReuseIdentifier:@"cellId"];
        [self addSubview:self.tableView];
        [self getNetWorkData];
    }
    return self;
}
- (void)getNetWorkData{
    NSTimeInterval lastTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LastRunTimeKey"];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if (nowTime - lastTime < 3600*12) {
        NSData *data = [NSData dataWithContentsOfFile:[self arrayDataFilePath]];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
    } else{
    [SFNetWork getJsonDataWithURL:@"https://druid.if.qidian.com/Atom.axd/Api/Tops/GetTopGroupList?siteId=0" parameters:nil success:^(id json) {
        NSString *code = [NSString stringWithFormat:@"%@",json[@"Result"]];
        if ([code isEqualToString:@"0"]) {
            if (json[@"Data"] && [json[@"Data"] isKindOfClass:[NSArray class]]) {
                NSArray *dataArray = json[@"Data"];
//                NSMutableArray *tmpTopIdArray = [NSMutableArray array];
                for (NSDictionary *dict in dataArray) {
                    NSString *Name = [NSString stringWithFormat:@"%@",dict[@"Name"]];
                    if (dict[@"SubItems"] && [dict[@"SubItems"] isKindOfClass:[NSArray class]]) {
                        NSArray *subItems = dict[@"SubItems"];
                        for (NSDictionary *subDict in subItems) {
                            NSString *name = [NSString stringWithFormat:@"%@-%@",Name,subDict[@"Name"]];
                            NSString *topId = [NSString stringWithFormat:@"%@",subDict[@"TopId"]];
                            NSString *urlStr = [NSString stringWithFormat:@"https://druid.if.qidian.com/Atom.axd/Api/Tops/GetTopBooks?pageIndex=1&topId=%@",topId];
                            
                            [SFNetWork getJsonDataWithURL:urlStr parameters:nil success:^(id json) {
                                NSString *code = [NSString stringWithFormat:@"%@",json[@"Result"]];
                                if ([code isEqualToString:@"0"]) {
                                    if (json[@"Data"] && [json[@"Data"] isKindOfClass:[NSArray class]]) {
                                        NSArray *dataArray = json[@"Data"];
                                        NSMutableArray *tmpArray = [NSMutableArray array];
                                        for (NSDictionary *dict in dataArray) {
                                            NSString *bookName = [NSString stringWithFormat:@"%@",dict[@"BookName"]];
                                            [tmpArray addObject:bookName];
                                        }
                                        NSDictionary *valueDict = @{@"name":name,@"value":tmpArray};
                                        [self.dataArray addObject:valueDict];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.tableView reloadData];
                                            [self saveData:self.dataArray];
                                        });
                                    }
                                } else {
                                    NSLog(@"获取排行榜接口返回失败：error = %@",json[@"Message"]);
                                }
                            } fail:^(NSError *error) {
                                NSLog(@"接口请求失败：error = %@",error);
                            }];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setDouble:nowTime forKey:@"LastRunTimeKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                });
            }
        } else {
            NSLog(@"获取排行榜接口返回失败：error = %@",json[@"Message"]);
        }
    } fail:^(NSError *error) {
        NSLog(@"接口请求失败：error = %@",error);
    }];
    }
}
- (void)saveData:(id)json{
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    [json_data writeToFile:[self arrayDataFilePath] atomically:YES];
}
- (NSString *)arrayDataFilePath
{
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Run"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:paths]){
        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath=[NSString stringWithFormat:@"%@/%@.json",paths,KeyRunLocaCache];
    return filePath;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[HXTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSDictionary *tagsDict = self.dataArray[indexPath.section];
    NSArray *tagsArray = tagsDict[@"value"];
    cell.tags = tagsArray;
    cell.layout = self.layout;
    __weak typeof(self) weakSelf = self;
    cell.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
        if (weakSelf.selectedTagsBlock) {
            weakSelf.selectedTagsBlock([selectTags firstObject]);
        }
    };
    [cell reloadData];
    return cell;
}
- (HXTagCollectionViewFlowLayout *)layout {
    _layout = [HXTagCollectionViewFlowLayout new];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return _layout;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tagsDict = self.dataArray[indexPath.section];
    NSArray *tagsArray = tagsDict[@"value"];
    float height = [HXTagsCell getCellHeightWithTags:tagsArray layout:self.layout tagAttribute:nil width:tableView.frame.size.width];
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *tagsDict = self.dataArray[section];
    NSString *title = tagsDict[@"name"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width-40, 35)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [headerView addSubview:titleLabel];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


@end
