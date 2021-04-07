//
//  SFSetViewController.m
//  ReadBook
//
//  Created by lurich on 2020/5/26.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFSetViewController.h"
#import "SFBookSetTableViewCell.h"
#import "CustomPicker.h"
#import "YZAuthID.h"

@interface SFSetViewController ()<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *pickerDataArray;
@property (nonatomic, copy  ) NSString *selectedCellKey;

@end

@implementation SFSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能配置";
    [self.view addSubview:self.tableView];
    [self createAllData];
}
- (void)updateFrameWithSize:(CGSize)size{
    [[CustomPicker sharedInstance] dismiss];
    [[CustomPicker sharedInstance] updateFrame:size];
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height);
}
- (void)createAllData{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self.dataArray addObject:@{@"title":@"看视频",@"detail":@"",@"value":@"SFMovieListViewController", @"type":@"99",@"key":@"push"}];
    [self.dataArray addObject:@{@"title":@"看小说",@"detail":@"",@"value":@"SearchViewController", @"type":@"99",@"key":@"push"}];
    [self.dataArray addObject:@{@"title":@"看漫画",@"detail":@"",@"value":@"SFMoreSearchViewController", @"type":@"99",@"key":@"push"}];
    BOOL brightSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBrightSwitch];
    [self.dataArray addObject:@{@"title":@"亮度跟随系统",@"detail":@"开启后，阅读小说界面亮度将跟随系统变化，当自定义亮度后，此选项自动关闭",@"value":@(brightSwitch),@"type":@"1",@"key":KeyBrightSwitch}];
    BOOL timerDisabled = [[NSUserDefaults standardUserDefaults] boolForKey:KeyTimerDisabled];
    [self.dataArray addObject:@{@"title":@"屏幕常亮",@"detail":@"开启后，阅读小说界面屏幕将保持常亮状态",@"value":@(timerDisabled),@"type":@"1",@"key":KeyTimerDisabled}];
    if ([[YZAuthID sharedInstance] isHave]) {
        BOOL splashAuthID = [[NSUserDefaults standardUserDefaults] boolForKey:KeySplashAuthID];
        [self.dataArray addObject:@{@"title":@"启动验证",@"detail":@"开启后，打开应用，会验证指纹解锁或刷脸解锁，只为保护您的阅读隐私",@"value":@(splashAuthID),@"type":@"1",@"key":KeySplashAuthID}];
        if (splashAuthID) {
            NSArray *splashTimeArr = @[
            @{@"show":@"一分钟",@"time":@60,@"type":@"1"},
            @{@"show":@"十分钟",@"time":@600,@"type":@"2"},
            @{@"show":@"一小时",@"time":@3600,@"type":@"3"},
            @{@"show":@"十小时",@"time":@36000,@"type":@"4"},
            @{@"show":@"一天",@"time":@86400,@"type":@"5"}];
            [self.dataArray addObject:@{@"title":@"启动验证时间间隔",@"detail":@"",@"value":splashTimeArr,
                                        @"type":@"0",@"key":KeySplashAuthTime}];
        }
    }
    BOOL blurEffect = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBlurEffect];
    [self.dataArray addObject:@{@"title":@"高斯模糊",@"detail":@"开启后，应用切入后台，会添加高斯模糊，只为保护您的阅读隐私",@"value":@(blurEffect),@"type":@"1",@"key":KeyBlurEffect}];
    BOOL exitAlert = [[NSUserDefaults standardUserDefaults] boolForKey:KeyExitAlert];
    [self.dataArray addObject:@{@"title":@"加入书架提示",@"detail":@"开启后，退出小说详情页时，如果该小说未加入书架，将会展示是否加入书架的提示弹框！",@"value":@(exitAlert),@"type":@"1",@"key":KeyExitAlert}];
    BOOL tapClickExchange = [[NSUserDefaults standardUserDefaults] boolForKey:KeyTapClickExchange];
    [self.dataArray addObject:@{@"title":@"左手模式",@"detail":@"开启后，阅读小说界面左侧点击为下一页，右侧点击为上一页",@"value":@(tapClickExchange),@"type":@"1",@"key":KeyTapClickExchange}];
    BOOL bookUpdateReminder = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookUpdateReminder];
    [self.dataArray addObject:@{@"title":@"未读提示",@"detail":@"开启后，将在书架的书籍右上角有红色提示该书还有几章未读，注意，开启此开关，将可能耗费您更多的流量",@"value":@(bookUpdateReminder),@"type":@"1",@"key":KeyBookUpdateReminder}];
    
    BOOL readBookStudy = [[NSUserDefaults standardUserDefaults] boolForKey:KeyReadBookStudy];
    [self.dataArray addObject:@{@"title":@"学习功能",@"detail":@"开启后，在小说阅读界面长按或双击，可进行对选中文字的额外操作，比如复制、粘贴、剪切、字典查询及发音等",@"value":@(readBookStudy),@"type":@"1",@"key":KeyReadBookStudy}];
    
    BOOL cacheBook = [[NSUserDefaults standardUserDefaults] boolForKey:KeyCacheBooks];
    [self.dataArray addObject:@{@"title":@"缓存书籍",@"detail":@"开启后，可在书架首页左滑缓存全本书籍与漫画，缓存开始后，可在最顶部看到一根蓝色进度条，代表缓存的进度！",@"value":@(cacheBook),@"type":@"1",@"key":KeyCacheBooks}];
    BOOL bookHiddleStatus = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookHiddleStatus];
    [self.dataArray addObject:@{@"title":@"隐藏状态栏",@"detail":@"开启后，阅读小说界面将隐藏顶部状态，关闭将展示状态栏",@"value":@(bookHiddleStatus),@"type":@"1",@"key":KeyBookHiddleStatus}];
    BOOL bookHiddleTitle = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookHiddleTitle];
    [self.dataArray addObject:@{@"title":@"隐藏章节及页数",@"detail":@"开启后，阅读小说界面将隐藏顶部章节标题及顶部页数进度等，关闭将展示",@"value":@(bookHiddleTitle),@"type":@"1",@"key":KeyBookHiddleTitle}];
    BOOL bookReadTimeSolt = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookReadTimeSolt];
    [self.dataArray addObject:@{@"title":@"书籍排序",@"detail":@"开启后，书架首页书籍将按照最后阅读时间进行降序排列，最近阅读的将会优先展示",@"value":@(bookReadTimeSolt),@"type":@"1",@"key":KeyBookReadTimeSolt}];
    BOOL bookJiugongStyle = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookJiugongStyle];
    [self.dataArray addObject:@{@"title":@"九宫格展示",@"detail":@"开启后，书架首页书籍将按照九宫格样式展示，关闭则按照列表样式展示，默认关闭",@"value":@(bookJiugongStyle),@"type":@"1",@"key":KeyBookJiugongStyle}];
    BOOL menuReverse = [[NSUserDefaults standardUserDefaults] boolForKey:KeyMenuReverse];
    [self.dataArray addObject:@{@"title":@"目录倒序",@"detail":@"开启后，书籍详情目录将会倒序排列",@"value":@(menuReverse),@"type":@"1",@"key":KeyMenuReverse}];
    BOOL swipeBack = [[NSUserDefaults standardUserDefaults] boolForKey:KeySwipeBack];
    [self.dataArray addObject:@{@"title":@"手势返回",@"detail":@"开启后，上下滑动书籍页面右滑返回；左右翻页书籍页面上滑或下滑返回！点击区域选择为全屏区域时，将默认开启",@"value":@(swipeBack),@"type":@"1",@"key":KeySwipeBack}];
    
    NSArray *pageStyleArr = @[
    @{@"show":@"上下滑动",@"time":@0,@"type":@"1"},
    @{@"show":@"左右拟真翻页",@"time":@0,@"type":@"2"},
    @{@"show":@"左右平滑翻页",@"time":@0,@"type":@"3"},
    @{@"show":@"上下拟真翻页",@"time":@0,@"type":@"4"},
    @{@"show":@"上下平滑翻页",@"time":@0,@"type":@"5"},
    @{@"show":@"无动画",@"time":@0,@"type":@"6"},
    @{@"show":@"自动阅读",@"time":@0,@"type":@"7"}];
    [self.dataArray addObject:@{@"title":@"翻页样式",@"detail":@"",@"value":pageStyleArr, @"type":@"0",@"key":KeyPageStyle}];
    
    NSArray *clickAreaArr = @[
    @{@"show":@"左中右区域",@"time":@0,@"type":@"1"},
    @{@"show":@"上中下区域",@"time":@0,@"type":@"2"},
    @{@"show":@"四周包中区域",@"time":@0,@"type":@"3"},
    @{@"show":@"全屏区域",@"time":@0,@"type":@"4"}];
    [self.dataArray addObject:@{@"title":@"点击区域",@"detail":@"",@"value":clickAreaArr, @"type":@"0",@"key":KeyClickArea}];
    [self.dataArray addObject:@{@"title":@"字体选择",@"detail":@"",@"value":@"SFFontChooseViewController", @"type":@"99",@"key":KeyFontName}];
    
    if (@available(iOS 13.0, *)) {
        NSArray *darkModeArr = @[
        @{@"show":@"跟随系统",@"time":@0,@"type":@"1"},
        @{@"show":@"浅色模式",@"time":@0,@"type":@"2"},
        @{@"show":@"深色模式",@"time":@0,@"type":@"3"}];
        [self.dataArray addObject:@{@"title":@"黑暗模式",@"detail":@"",@"value":darkModeArr, @"type":@"0",@"key":KeyDarkMode}];
    }
    
    CGFloat bookRate = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookRate];
    [self.dataArray addObject:@{@"title":@"朗读语速(默认0.5)",@"detail":@"",@"value":@(bookRate),@"type":@"2",@"min":@"0.0",@"max":@"1.0",@"key":KeyBookRate}];
    
    CGFloat bookPitchMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookPitch];
    [self.dataArray addObject:@{@"title":@"朗读语调(默认1.0)",@"detail":@"",@"value":@(bookPitchMultiplier),@"type":@"2",@"min":@"0.5",@"max":@"2.0",@"key":KeyBookPitch}];
    [self.dataArray addObject:@{@"title":@"语音库选择",@"detail":@"",@"value":@"SFVoicesChooseViewController", @"type":@"99",@"key":@"push"}];
    
    
    [self.dataArray addObject:@{@"title":@"清除缓存",@"detail":@"",@"value":@"clearCacheAlertShow", @"type":@"99",@"key":@"alert"}];
    [self.dataArray addObject:@{@"title":@"分组管理",@"detail":@"",@"value":@"SFGroupManageViewController", @"type":@"99",@"key":@"push"}];
    [self.dataArray addObject:@{@"title":@"小说书源管理",@"detail":@"",@"value":@"SFBookSourceMangerViewController", @"type":@"99",@"key":@"push"}];
    [self.dataArray addObject:@{@"title":@"阅读背景管理",@"detail":@"",@"value":@"SFBookThemeMangerViewController", @"type":@"99",@"key":@"push"}];
    [self.dataArray addObject:@{@"title":@"自定义开屏",@"detail":@"",@"value":@"SFLaunchSetViewController", @"type":@"99",@"key":@"push"}];
    [self.dataArray addObject:@{@"title":@"自定义App图标",@"detail":@"",@"value":@"SFChooseAppLogoViewController", @"type":@"99",@"key":@"push"}];
    [self.dataArray addObject:@{@"title":@"关于APP",@"detail":[NSString stringWithFormat:@"版本%@",[SFTool getAppVersion]],@"value":@"SFAboutAppViewController", @"type":@"99",@"key":@"push"}];
    
    [self.tableView reloadData];
}
- (UIView *)tableViewFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-150)/2.0, 28, 150, 44)];
    [clearBtn setTitle:@"清除所有书籍缓存" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn setBackgroundColor:[UIColor orangeColor]];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    clearBtn.layer.masksToBounds = YES;
    clearBtn.layer.cornerRadius = 22;
    [clearBtn addTarget:self action:@selector(clearCacheAlertShow) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:clearBtn];
    return footerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [UIView new];
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
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *type = dict[@"type"];
    switch (type.intValue) {
        case 0:
            {
                SFBookSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SFBookSetTableViewCellIDfirstObject%d",type.intValue]];
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"SFBookSetTableViewCell" owner:nil options:nil][type.intValue];
                }
                cell.nameLabel.text = dict[@"title"];
                NSArray *detailArr = dict[@"value"];
                NSString *chooseStr = [[NSUserDefaults standardUserDefaults] objectForKey:dict[@"key"]];
                NSDictionary *newDict = detailArr[chooseStr.intValue-1];
                cell.chooseLabel.text = newDict[@"show"];
                return cell;
            }
            break;
        case 1:
            {
                SFBookSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SFBookSetTableViewCellIDfirstObject%d",type.intValue]];
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"SFBookSetTableViewCell" owner:nil options:nil][type.intValue];
                }
                BOOL BrightSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:dict[@"key"]];
                [cell.switchView setOn:BrightSwitch animated:NO];
                cell.switchValueChanged = ^(BOOL off) {
                    [[NSUserDefaults standardUserDefaults] setBool:off forKey:dict[@"key"]];
                    if ([KeySplashAuthID isEqualToString:dict[@"key"]]) {
                        [self createAllData];
                    }
                };
                cell.titleLabel.text = dict[@"title"];
                cell.descLabel.text = dict[@"detail"];
                return cell;
            }
            break;
        case 2:
            {
                SFBookSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SFBookSetTableViewCellIDfirstObject%d",type.intValue]];
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"SFBookSetTableViewCell" owner:nil options:nil][type.intValue];
                }
                cell.typeLabel.text = dict[@"title"];
                cell.minLabel.text = [NSString stringWithFormat:@"最小值(%@)",dict[@"min"]];
                cell.speedSlider.minimumValue = [dict[@"min"] floatValue];
                cell.maxLabel.text = [NSString stringWithFormat:@"最大值(%@)",dict[@"max"]];
                cell.speedSlider.maximumValue = [dict[@"max"] floatValue];
                cell.typeDescLabel.text = [NSString stringWithFormat:@"当前值：%.2f",[dict[@"value"] floatValue]];
                CGFloat sliderValue = [[NSUserDefaults standardUserDefaults] floatForKey:dict[@"key"]];
                cell.speedSlider.value = sliderValue;
                __weak typeof(cell) weakCell = cell;
                cell.sliderValueChanged = ^(CGFloat value) {
                    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:dict[@"key"]];
                    weakCell.typeDescLabel.text = [NSString stringWithFormat:@"当前值：%.2f",value];
                };
                return cell;
            }
            break;
            
        default:
        {
            SFBookSetTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"SFBookSetTableViewCellIDlastObject0"];
            if (!otherCell) {
                otherCell = [[NSBundle mainBundle] loadNibNamed:@"SFBookSetTableViewCell" owner:nil options:nil][0];
            }
            otherCell.nameLabel.text = dict[@"title"];
            otherCell.chooseLabel.text = dict[@"detail"];
            return otherCell;
        }
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *type = dict[@"type"];
    switch (type.intValue) {
        case 0:
        {
            self.pickerDataArray = dict[@"value"];
            self.selectedCellKey = dict[@"key"];
            CustomPicker *customPicker = [CustomPicker sharedInstance];
            customPicker.pickerDataArray = self.pickerDataArray;
            customPicker.delegate = self;
            //默认选中第零行
            NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:[self.selectedCellKey stringByAppendingString:@"SelectedRow"]];
            [customPicker.pickerView selectRow:row inComponent:0 animated:YES];
            [customPicker show];
        }
            break;
        case 1:
            break;
        case 99:
        {
            NSString *titleStr = dict[@"title"];
            if ([titleStr isEqualToString:@"清除缓存"]) {
                [self clearCacheAlertShow];
            } else {//关于APP 字体选择 小工具
                [self.navigationController pushViewController:[NSClassFromString(dict[@"value"]) new] animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *type = dict[@"type"];
    switch (type.intValue) {
        case 0:
            return 55;
            break;
        case 1:
            return 90;
            break;
        case 2:
            return 75;
            break;
        default:
            return 55;
            break;
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

//点击了确定按钮
- (void)finishChoose:(CustomPicker *)myPicker{
    NSInteger row = [myPicker.pickerView selectedRowInComponent:0];
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:[self.selectedCellKey stringByAppendingString:@"SelectedRow"]];
    
//    NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:[self.selectedCellKey stringByAppendingString:@"SelectedRow"]];
    [[NSUserDefaults standardUserDefaults] setObject:self.pickerDataArray[row][@"type"] forKey:self.selectedCellKey];
    if ([self.selectedCellKey isEqualToString:KeyDarkMode]) {
        NSString *chooseStr = self.pickerDataArray[row][@"type"];
        switch (chooseStr.intValue) {
            case 1:
                [self systemEvent];
                break;
            case 2:
                [self lightEvent];
                break;
            case 3:
                [self darkEvent];
                break;
                
            default:
                break;
        }
    }
    [self.tableView reloadData];
}
- (void)lightEvent {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KeySelectNight];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KeyNightFollowingSystem];
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        self.navigationController.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

- (void)darkEvent {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeySelectNight];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KeyNightFollowingSystem];
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        self.navigationController.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
}

- (void)systemEvent {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeyNightFollowingSystem];
    if (@available(iOS 13.0, *)) {
        if ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeySelectNight];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KeySelectNight];
        }
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
        self.navigationController.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    }
}
#pragma mark - 清除APP缓存
- (void)clearCacheAlertShow{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"请选择删除缓存的类型"] preferredStyle:UIAlertControllerStyleActionSheet];

//    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除所有缓存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
//        [self clearAllCacheDataWithPath:cachePath];
//    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除书籍缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Books"];
        [self clearAllCacheDataWithPath:cachePath];
    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除漫画缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
        [self clearAllCacheDataWithPath:cachePath];
    }]];

//    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除其他缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.xiaofu.lurich"];
//        [self clearAllCacheDataWithPath:cachePath];
//    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:@"不删除了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)clearAllCacheDataWithPath:(NSString *)cachePath{
    [SVProgressHUD showWithStatus:@"缓存计算中..."];
    dispatch_async(dispatch_queue_create("getCacheSize", DISPATCH_QUEUE_CONCURRENT), ^{
        CGFloat cacheSize = [self getCacheFileTotalSizeWithFilePath:cachePath];
        NSString *cacheShowStr;
        if (cacheSize>1024.0) {
            cacheShowStr = [NSString stringWithFormat:@"%.2fG",cacheSize/1024.0];
        } else {
            cacheShowStr = [NSString stringWithFormat:@"%.2fM",cacheSize];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前缓存文件大小为%@\n是否全部清除？",cacheShowStr] preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
                if (isExist) {
                    [SVProgressHUD showWithStatus:@"清除缓存中..."];
                    NSError *error;
                    BOOL delegate = [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error];
                    if (delegate) {
                        [SVProgressHUD showSuccessWithStatus:@"清除缓存完成"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"清除缓存失败"];
                        NSLog(@"error = %@",error);
                    }
                }
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        });
    });
}
- (CGFloat)getCacheFileTotalSizeWithFilePath:(NSString *)path{
    //计算结果
    long long totalSize = 0;
    // 1.获得文件夹管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [mgr fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    // 3.判断是否为文件夹
    if (dir)//文件夹, 遍历文件夹里面的所有文件
    {
        //这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径),包括子文件夹下面的所有文件及文件夹
        NSArray *subPaths = [mgr subpathsAtPath:path];
        //遍历所有子路径
        for (NSString *subPath in subPaths) {
            //拼成全路径
            NSString *fullSubPath = [path stringByAppendingPathComponent:subPath];
            //如果是数据库文件，不加入计算
            if ([subPath hasSuffix:@".sqlite"]) { continue; }
            NSDictionary *attrs = [mgr attributesOfItemAtPath:fullSubPath error:nil];
            totalSize += [attrs[NSFileSize] doubleValue];
        }
        totalSize = totalSize / (1024 * 1024.0);//单位M
        return totalSize;
    }
    else//文件
    {
        NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
        totalSize = [attrs[NSFileSize] floatValue] / (1024 * 1024.0);//单位M
        return totalSize;
    }
}

@end
