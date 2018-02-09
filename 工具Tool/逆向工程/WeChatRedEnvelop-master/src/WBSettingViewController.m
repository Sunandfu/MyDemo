//
//  WBSettingViewController.m
//  WeChatRedEnvelop
//
//  Created by 杨志超 on 2017/2/22.
//  Copyright © 2017年 swiftyper. All rights reserved.
//

#import "WBSettingViewController.h"
#import "WeChatRedEnvelop.h"
#import "WBRedEnvelopConfig.h"
#import <objc/objc-runtime.h>
#import "WBMultiSelectGroupsViewController.h"
#import "XYMapViewController.h"

@interface WBSettingViewController () <MultiSelectGroupsViewControllerDelegate>

@property (nonatomic, strong) MMTableViewInfo *tableViewInfo;

@end

@implementation WBSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 增加对iPhone X的屏幕适配
        CGRect winSize = [UIScreen mainScreen].bounds;
        if (winSize.size.height == 812) { // iPhone X 高为812
            winSize.size.height -= 88;
            winSize.origin.y = 0;
        } else {
            winSize.size.height -= 64;
            winSize.origin.y = 0;
        }
        _tableViewInfo = [[objc_getClass("MMTableViewInfo") alloc] initWithFrame:winSize style:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTitle];
    [self reloadTableData];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    MMTableView *tableView = [self.tableViewInfo getTableView];
    [self.view addSubview:tableView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopLoading];
}

- (void)initTitle {
    self.title = @"微信小助手";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]}];
}

- (void)reloadTableData {
    [self.tableViewInfo clearAllSection];
    
    [self addBasicSettingSection];
    [self addNiubilitySection];
    [self addAdvanceSettingSection];
    [self addModifyCoordinateCell];
    [self addSupportSection];
    
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [tableView reloadData];
}

#pragma mark - BasicSetting

- (void)addBasicSettingSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self createAutoReceiveRedEnvelopCell]];
    [sectionInfo addCell:[self createDelaySettingCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}


- (MMTableViewCellInfo *)createAutoReceiveRedEnvelopCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(switchRedEnvelop:) target:self title:@"自动抢红包" on:[WBRedEnvelopConfig sharedConfig].autoReceiveEnable];
}

- (MMTableViewCellInfo *)createDelaySettingCell {
    NSInteger delaySeconds = [WBRedEnvelopConfig sharedConfig].delaySeconds;
    NSString *delayString = delaySeconds == 0 ? @"不延迟" : [NSString stringWithFormat:@"%ld 秒", (long)delaySeconds];
    
    MMTableViewCellInfo *cellInfo;
    if ([WBRedEnvelopConfig sharedConfig].autoReceiveEnable) {
        cellInfo = [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(settingDelay) target:self title:@"延迟抢红包" rightValue: delayString accessoryType:1];
    } else {
        cellInfo = [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"延迟抢红包" rightValue: @"抢红包已关闭"];
    }
    return cellInfo;
}

- (void)switchRedEnvelop:(UISwitch *)envelopSwitch {
    [WBRedEnvelopConfig sharedConfig].autoReceiveEnable = envelopSwitch.on;
    
    [self reloadTableData];
}

- (void)settingDelay {
    NSInteger delaySeconds = [WBRedEnvelopConfig sharedConfig].delaySeconds;
    [self alertControllerWithTitle:@"延迟抢红包(秒)" message:nil content:[NSString stringWithFormat:@"%ld", (long)delaySeconds] placeholder:@"延迟时长" keyboardType:UIKeyboardTypeNumberPad blk:^(UITextField *textField) {
        [[WBRedEnvelopConfig sharedConfig] setDelaySeconds:textField.text.integerValue];
        [self reloadTableData];
    }];
}

#pragma mark - 修改运动步数
- (void)addNiubilitySection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoHeader:@"装逼必备"];
    
    [sectionInfo addCell:[self createStepSwitchCell]];
    
    BOOL changeStepEnable = [WBRedEnvelopConfig sharedConfig].changeStepEnable;
    if (changeStepEnable) {
        [sectionInfo addCell:[self createStepCountCell]];
    }
    [sectionInfo addCell:[self createGameCheatSwitchCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}
- (MMTableViewCellInfo *)createGameCheatSwitchCell {
    BOOL preventGameCheatEnable = [[WBRedEnvelopConfig sharedConfig] preventGameCheatEnable];
    MMTableViewCellInfo *cellInfo = [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingGameCheatSwitch:) target:self title:@"开启游戏作弊" on:preventGameCheatEnable];
    
    return cellInfo;
}
- (void)settingGameCheatSwitch:(UISwitch *)arg {
    [[WBRedEnvelopConfig sharedConfig] setPreventGameCheatEnable:arg.on];
    [self reloadTableData];
}
- (MMTableViewCellInfo *)createStepSwitchCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingStepSwitch:) target:self title:@"是否修改微信步数" on:[WBRedEnvelopConfig sharedConfig].changeStepEnable];
}

- (MMTableViewCellInfo *)createStepCountCell {
    NSInteger deviceStep = [WBRedEnvelopConfig sharedConfig].deviceStep;
    MMTableViewCellInfo *cellInfo = [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(settingStepCount) target:self title:@"微信运动步数" rightValue: [NSString stringWithFormat:@"%ld", (long)deviceStep] accessoryType:1];
    return cellInfo;
}
- (void)settingStepSwitch:(UISwitch *)arg {
    [[WBRedEnvelopConfig sharedConfig] setChangeStepEnable:arg.on];
    [self reloadTableData];
}

- (void)settingStepCount {
    NSInteger deviceStep = [WBRedEnvelopConfig sharedConfig].deviceStep;
    [self alertControllerWithTitle:@"微信运动设置"
                           message:@"步数需比之前设置的步数大才能生效，最大值为98800"
                           content:[NSString stringWithFormat:@"%ld", (long)deviceStep]
                       placeholder:@"请输入步数"
                      keyboardType:UIKeyboardTypeNumberPad
                               blk:^(UITextField *textField) {
                                   [[WBRedEnvelopConfig sharedConfig] setDeviceStep:textField.text.integerValue];
                                   [self reloadTableData];
                               }];
}
- (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message content:(NSString *)content placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType blk:(void (^)(UITextField *))blk  {
    UIAlertController *alertController = ({
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:message
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    if (blk) {
                                                        blk(alert.textFields.firstObject);
                                                    }
                                                }]];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholder;
            textField.text = content;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = keyboardType;
        }];
        
        alert;
    });
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - ProSetting
- (void)addAdvanceSettingSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoHeader:@"高级功能"];
    
    [sectionInfo addCell:[self createReceiveSelfRedEnvelopCell]];
    [sectionInfo addCell:[self createQueueCell]];
    [sectionInfo addCell:[self createBlackListCell]];
    [sectionInfo addCell:[self createAbortRemokeMessageCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)createReceiveSelfRedEnvelopCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingReceiveSelfRedEnvelop:) target:self title:@"抢自己发的红包" on:[WBRedEnvelopConfig sharedConfig].receiveSelfRedEnvelop];
}

- (MMTableViewCellInfo *)createQueueCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingReceiveByQueue:) target:self title:@"防止同时抢多个红包" on:[WBRedEnvelopConfig sharedConfig].serialReceive];
}

- (MMTableViewCellInfo *)createBlackListCell {
    
    if ([WBRedEnvelopConfig sharedConfig].blackList.count == 0) {
        return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(showBlackList) target:self title:@"群聊过滤" rightValue:@"已关闭" accessoryType:1];
    } else {
        NSString *blackListCountStr = [NSString stringWithFormat:@"已选 %lu 个群", (unsigned long)[WBRedEnvelopConfig sharedConfig].blackList.count];
        return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(showBlackList) target:self title:@"群聊过滤" rightValue:blackListCountStr accessoryType:1];
    }
    
}

- (MMTableViewSectionInfo *)createAbortRemokeMessageCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(settingMessageRevoke:) target:self title:@"消息防撤回" on:[WBRedEnvelopConfig sharedConfig].revokeEnable];
}

- (void)settingReceiveSelfRedEnvelop:(UISwitch *)receiveSwitch {
    [WBRedEnvelopConfig sharedConfig].receiveSelfRedEnvelop = receiveSwitch.on;
}

- (void)settingReceiveByQueue:(UISwitch *)queueSwitch {
    [WBRedEnvelopConfig sharedConfig].serialReceive = queueSwitch.on;
}

- (void)showBlackList {
    WBMultiSelectGroupsViewController *contactsViewController = [[WBMultiSelectGroupsViewController alloc] initWithBlackList:[WBRedEnvelopConfig sharedConfig].blackList];
    contactsViewController.delegate = self;
    
    MMUINavigationController *navigationController = [[objc_getClass("MMUINavigationController") alloc] initWithRootViewController:contactsViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)settingMessageRevoke:(UISwitch *)revokeSwitch {
    [WBRedEnvelopConfig sharedConfig].revokeEnable = revokeSwitch.on;
}

#pragma mark - 给作者打赏
- (void)addSupportSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    [sectionInfo addCell:[self createWeChatPayingCell]];
    
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)createWeChatPayingCell {
    return [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(payingToAuthor) target:self title:@"微信打赏" rightValue:@"支持作者开发" accessoryType:1];
}

- (void)payingToAuthor {
    [self startLoadingNonBlock];
    ScanQRCodeLogicController *scanQRCodeLogic = [[objc_getClass("ScanQRCodeLogicController") alloc] initWithViewController:self CodeType:3];
    scanQRCodeLogic.fromScene = 2;
    
    NewQRCodeScanner *qrCodeScanner = [[objc_getClass("NewQRCodeScanner") alloc] initWithDelegate:scanQRCodeLogic CodeType:3];
    [qrCodeScanner notifyResult:@"wxp://f2f0dIeuFV8yKKpI-obgtf--7HwAaneyxCSd" type:@"QR_CODE" version:6];
}

#pragma mark - MultiSelectGroupsViewControllerDelegate
- (void)onMultiSelectGroupCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)onMultiSelectGroupReturn:(NSArray *)arg1 {
    [WBRedEnvelopConfig sharedConfig].blackList = arg1;
    
    [self reloadTableData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - 更新经纬度信息
////////////////////////////////////////////////////////////////////////
- (void)addModifyCoordinateCell {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoHeader:@"最新功能"];
    [sectionInfo addCell:[self createChangeCoordinateSwitchCell]];
    
    BOOL shouldChangeCoordinate = [[WBRedEnvelopConfig sharedConfig] shouldChangeCoordinate];
    if (shouldChangeCoordinate) {
        [sectionInfo addCell:[self createadLatitudeCell]];
        [sectionInfo addCell:[self createadLongitudeCell]];
        [sectionInfo addCell:[self createMapViewCell]];
    }
    [self.tableViewInfo addSection:sectionInfo];
}

- (MMTableViewCellInfo *)createMapViewCell {
    MMTableViewCellInfo *cellInfo = [objc_getClass("MMTableViewCellInfo")  normalCellForSel:@selector(jumpToMapView) target:self title:@"进入地图页选择位置" accessoryType:1];
    return cellInfo;
}

- (void)jumpToMapView {
    XYMapViewController *mvc = [[XYMapViewController alloc] init];
    [self showViewController:mvc sender:self];
}

- (MMTableViewCellInfo *)createadLatitudeCell {
    double latitude = [[WBRedEnvelopConfig sharedConfig] latitude];
    MMTableViewCellInfo *cellInfo = [objc_getClass("MMTableViewCellInfo")  normalCellForSel:@selector(updateLatitude) target:self title:@"修改的经度(latitude)" rightValue:[NSString stringWithFormat:@"%f", latitude] accessoryType:1];
    
    return cellInfo;
}

- (MMTableViewCellInfo *)createadLongitudeCell {
    double longitude = [[WBRedEnvelopConfig sharedConfig] longitude];
    MMTableViewCellInfo *cellInfo = [objc_getClass("MMTableViewCellInfo")  normalCellForSel:@selector(updateLongitude) target:self title:@"修改的纬度(longitude)" rightValue:[NSString stringWithFormat:@"%f", longitude] accessoryType:1];
    
    return cellInfo;
}

/// 更新经度
- (void)updateLatitude {
    
    double latitude = [[WBRedEnvelopConfig sharedConfig] latitude];
    [self alertControllerWithTitle:@"修改经度(latitude)"
                           message:@"请同时修改经度和纬度，若其中一个小于0则无效，关于经纬度的获取可去高德地图或百度地图，并转换为Wgs84"
                           content:[NSString stringWithFormat:@"%f", latitude]
                       placeholder:@"请输入经度"
                      keyboardType:UIKeyboardTypeDecimalPad
                               blk:^(UITextField *textField) {
                                   [[WBRedEnvelopConfig sharedConfig] setLatitude:MAX(0.0, textField.text.doubleValue)];
                                   [self reloadTableData];
                               }];
}

/// 更新纬度
- (void)updateLongitude {
    double longitude = [[WBRedEnvelopConfig sharedConfig] longitude];
    [self alertControllerWithTitle:@"修改纬度(longitude)"
                           message:@"请同时修改经度和纬度，若其中一个小于0则无效"
                           content:[NSString stringWithFormat:@"%f", longitude]
                       placeholder:@"请输入纬度"
                      keyboardType:UIKeyboardTypeDecimalPad
                               blk:^(UITextField *textField) {
                                   [[WBRedEnvelopConfig sharedConfig] setLongitude:MAX(0.0, textField.text.doubleValue)];
                                   [self reloadTableData];
                               }];
}

/// 创建是否更新经纬度cell
- (MMTableViewCellInfo *)createChangeCoordinateSwitchCell {
    BOOL shouldChangeCoordinate = [[WBRedEnvelopConfig sharedConfig] shouldChangeCoordinate];
    MMTableViewCellInfo *cellInfo = [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(setShouldChangeCoordinate:) target:self title:@"修改经纬度" on:shouldChangeCoordinate];
    
    return cellInfo;
}


- (void)setShouldChangeCoordinate:(UISwitch *)sw {
    
    [WBRedEnvelopConfig sharedConfig].shouldChangeCoordinate = sw.on;
    [self reloadTableData];
    
}

@end
