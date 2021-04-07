//
//  SFVoicesChooseViewController.m
//  ReadBook
//
//  Created by lurich on 2020/12/22.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFVoicesChooseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SFVoicesChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation SFVoicesChooseViewController

- (void)viewDidLoad {
    self.title = @"朗读人选择";
    self.dataArray = [NSMutableArray array];
    [super viewDidLoad];
    for (AVSpeechSynthesisVoice *voice in AVSpeechSynthesisVoice.speechVoices) {
        if ([voice.language containsString:@"zh"]) {
            [self.dataArray addObject:voice];
        }
    }
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.001)];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [self tableViewHeaderView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
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
    static NSString *MyIdentifier = @"MyIdentifier";
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    // Set up the cell.
    AVSpeechSynthesisVoice *voice = self.dataArray[indexPath.row];
    cell.textLabel.text = voice.name;
    NSString *voiceName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyVoiceName];
    NSString *identifierVoice = voice.identifier;
    if ([identifierVoice isEqualToString:voiceName]) {
        cell.detailTextLabel.text = @"当前使用";
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AVSpeechSynthesisVoice *voice = self.dataArray[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:voice.identifier forKey:KeyVoiceName];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
