//
//  SFListView.m
//  SFVideoPlayer
//
//  Created by lurich on 2022/5/12.
//

#import "SFListView.h"
#import "SFTool.h"

@interface SFListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SFListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [SFTool createCAGradientLayerWithColors:@[[UIColor clearColor],[UIColor blackColor]] View:self EndPoint:CGPointMake(1, 0)];
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, CGFLOAT_MIN)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableViewFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, CGFLOAT_MIN)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [self tableViewFooterView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0;
        } else {
            // Fallback on earlier versions
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isVideo) {
        return self.videoUrlArray.count;
    } else {
        return self.dataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%@%zd%zd",self.sf_className,indexPath.row,indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightHeavy];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.isVideo) {
        NSDictionary *videoDict = self.videoUrlArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",videoDict[@"type"]];
        if ([cell.textLabel.text isEqualToString:self.showType]) {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"229FC3"];
        } else {
            cell.textLabel.textColor = [UIColor whiteColor];
        }
    } else {
        NSString *cellStr = self.dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",self.prefixStr,cellStr,self.suffixStr];
        if (cellStr.doubleValue == self.rate) {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"229FC3"];
        } else {
            cell.textLabel.textColor = [UIColor whiteColor];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickBlock) {
        self.clickBlock(indexPath.row);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isVideo) {
        return MIN(80, self.bounds.size.height / self.videoUrlArray.count);
    } else {
        return MIN(50, self.bounds.size.height / self.dataArray.count);
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

- (void)reloadData{
    [self.tableView reloadData];
}

@end
