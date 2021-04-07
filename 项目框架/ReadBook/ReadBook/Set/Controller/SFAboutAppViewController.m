//
//  SFAboutAppViewController.m
//  ReadBook
//
//  Created by lurich on 2020/7/2.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFAboutAppViewController.h"
#import "SFBookSetTableViewCell.h"
#import "SFAboutHeaderView.h"
#import "SFNetWork.h"
#import "SFTool.h"
#import <SafariServices/SafariServices.h>
#import "SFTaskWebViewController.h"

@interface SFAboutAppViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFAboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于小鹿读书";
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@{@"title":@"给我写信",@"detail":@"Lurich@163.com"}];
    [self.dataArray addObject:@{@"title":@"给我点赞",@"detail":@"五星鼓励我"}];
    [self.dataArray addObject:@{@"title":@"隐私政策",@"detail":@"查看"}];
    [self.dataArray addObject:@{@"title":@"版本更新",@"detail":@""}];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
- (void)updateFrameWithSize:(CGSize)size{
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height-self.tabBarController.tabBar.bounds.size.height);
    [self.tableView reloadData];
}
- (UIView *)tableViewHeaderView{
    SFAboutHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"SFAboutHeaderView" owner:nil options:nil] firstObject];
    UIFont *font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentJustified;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    paraStyle01.firstLineHeadIndent = 16 * 2;//首行缩进
    paraStyle01.lineBreakMode=NSLineBreakByWordWrapping;
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 2.0f;//行间距
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle01,NSFontAttributeName:font};
    NSString *newStr = @"这个APP，纯属一个爱看小说的程序员的业余爱好。\n本平台将保证一直免费无广告，如果有任何建议或需求，可在APP评论或者给我写信告知，在空余时间将完善APP，谨此为广大爱好小说漫画的同道朋友提供绵薄之力！\n努力打造优质阅读体验，期待你我共同成长进步！";
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:newStr attributes:dic];
    headerView.showLabel.attributedText = attrText;
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@",[SFTool getAppName]];
    CGSize size = [attrText boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, size.height+170);
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [SFTool colorWithHexString:@"cccccc"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    tableView.tableHeaderView = [self tableViewHeaderView];
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFBookSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFBookSetTableViewCellIDlastObject0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SFBookSetTableViewCell" owner:nil options:nil][0];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.nameLabel.text = dict[@"title"];
    cell.chooseLabel.text = dict[@"detail"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // https://apps.apple.com/cn/app/lurich/id1514732986
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *title = dict[@"title"];
    if ([title isEqualToString:@"给我点赞"]) {
        NSString *appUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1514732986"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl] options:@{} completionHandler:nil];
    } else if ([title isEqualToString:@"隐私政策"]) {
        SFTaskWebViewController *taskVC = [[SFTaskWebViewController alloc] init];
        taskVC.URLString = @"https://shimo.im/docs/QT9QkDQthcTHPtG8/read";
        [self.navigationController pushViewController:taskVC animated:YES];
    } else if ([title isEqualToString:@"给我写信"]) {
        UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
        pBoard.string = dict[@"detail"];
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@已复制",dict[@"detail"]]];
    }
    else if ([title isEqualToString:@"版本更新"]) {
        NSString *AppStoreUrl = @"https://itunes.apple.com/cn/app/id1514732986?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreUrl] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"跳转成功");
            }
        }];
   }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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

@end
