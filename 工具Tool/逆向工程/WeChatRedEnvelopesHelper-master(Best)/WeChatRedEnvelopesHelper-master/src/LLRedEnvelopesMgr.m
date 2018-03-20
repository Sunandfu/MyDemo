//
//  LLRedEnvelopesMgr.m
//  test
//
//  Created by fqb on 2017/12/12.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLRedEnvelopesMgr.h"
#import <objc/runtime.h>

static NSString * const isOpenRedEnvelopesHelperKey = @"isOpenRedEnvelopesHelperKey";
static NSString * const isOpenSportHelperKey = @"isOpenSportHelperKey";
static NSString * const isOpenBackgroundModeKey = @"isOpenBackgroundModeKey";
static NSString * const isOpenRedEnvelopesAlertKey = @"isOpenRedEnvelopesAlertKey";
static NSString * const isOpenVirtualLocationKey = @"isOpenVirtualLocationKey";
static NSString * const isOpenAutoReplyKey = @"isOpenAutoReplyKey";
static NSString * const isOpenAutoLeaveMessageKey = @"isOpenAutoLeaveMessageKey";
static NSString * const isOpenKeywordFilterKey = @"isOpenKeywordFilterKey";
static NSString * const isSnatchSelfRedEnvelopesKey = @"isSnatchSelfRedEnvelopesKey";
static NSString * const isOpenAvoidRevokeMessageKey = @"isOpenAvoidRevokeMessageKey";
static NSString * const sportStepCountModeKey = @"sportStepCountModeKey";
static NSString * const sportStepCountUpperLimitKey = @"sportStepCountUpperLimitKey";
static NSString * const sportStepCountLowerLimitkey = @"sportStepCountLowerLimitkey";
static NSString * const keywordFilterTextKey = @"keywordFilterTextKey";
static NSString * const autoReplyTextKey = @"autoReplyTextKey";
static NSString * const autoLeaveMessageTextKey = @"autoLeaveMessageTextKey";
static NSString * const openRedEnvelopesDelaySecondKey = @"openRedEnvelopesDelaySecondKey";
static NSString * const wantSportStepCountKey = @"wantSportStepCountKey"; 
static NSString * const filterRoomDicKey = @"filterRoomDicKey";
static NSString * const XYLatitudeValueKey = @"latitude";
static NSString * const XYLongitudeValueKey = @"longitude";
static NSString * const KTKPreventGameCheatEnableKey = @"KTKPreventGameCheatEnableKey";
static NSString * const totalAssistAmountKey = @"totalAssistAmountKey";
static NSString * const isOpenBlockSendInputStatusKey = @"isOpenBlockSendInputStatusKey";

static const char isHiddenRedEnvelopesReceiveViewKey;
static const char logicControllerKey;

@implementation LLRedEnvelopesMgr

+ (LLRedEnvelopesMgr *)shared{
    static LLRedEnvelopesMgr *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LLRedEnvelopesMgr alloc] init];
    });
    return manager;
}

- (id)init{
    if(self = [super init]){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _isOpenRedEnvelopesHelper = [userDefaults boolForKey:isOpenRedEnvelopesHelperKey];
        _isOpenSportHelper = [userDefaults boolForKey:isOpenSportHelperKey];
        _isOpenBackgroundMode = [userDefaults boolForKey:isOpenBackgroundModeKey];
        _isOpenRedEnvelopesAlert = [userDefaults boolForKey:isOpenRedEnvelopesAlertKey];
        _isOpenVirtualLocation = [userDefaults boolForKey:isOpenVirtualLocationKey];
        _isOpenAutoReply = [userDefaults boolForKey:isOpenAutoReplyKey];
        _isOpenAutoLeaveMessage = [userDefaults boolForKey:isOpenAutoLeaveMessageKey];
        _isOpenKeywordFilter = [userDefaults boolForKey:isOpenKeywordFilterKey];
        _isSnatchSelfRedEnvelopes = [userDefaults boolForKey:isSnatchSelfRedEnvelopesKey];
        _isOpenAvoidRevokeMessage = [userDefaults boolForKey:isOpenAvoidRevokeMessageKey];
        _sportStepCountMode = [userDefaults boolForKey:sportStepCountModeKey];
        _sportStepCountUpperLimit = [userDefaults integerForKey:sportStepCountUpperLimitKey];
        _sportStepCountLowerLimit = [userDefaults integerForKey:sportStepCountLowerLimitkey];
        _keywordFilterText = [userDefaults objectForKey:keywordFilterTextKey];
        _autoReplyText = [userDefaults objectForKey:autoReplyTextKey];
        _autoLeaveMessageText = [userDefaults objectForKey:autoLeaveMessageTextKey];
        _openRedEnvelopesDelaySecond = [userDefaults floatForKey:openRedEnvelopesDelaySecondKey];
        _wantSportStepCount = [userDefaults integerForKey:wantSportStepCountKey];
        _filterRoomDic = [userDefaults objectForKey:filterRoomDicKey];
        _preventGameCheatEnable = [[NSUserDefaults standardUserDefaults] boolForKey:KTKPreventGameCheatEnableKey];
        _totalAssistAmount = [userDefaults integerForKey:totalAssistAmountKey];
        _isOpenBlockSendInputStatus = [userDefaults boolForKey:isOpenBlockSendInputStatusKey];
    }
    return self;
}

- (void)reset{
    self.logicController = nil;
}

#pragma mark SET GET METHOD

//- (void)setHaveNewRedEnvelopes:(BOOL)haveNewRedEnvelopes{
//    _haveNewRedEnvelopes = haveNewRedEnvelopes;
//}
//
//- (void)setIsHongBaoPush:(BOOL)isHongBaoPush{
//    _isHongBaoPush = isHongBaoPush;
//}
//
//- (void)setIsHiddenRedEnvelopesReceiveView:(BOOL)isHiddenRedEnvelopesReceiveView{
//    _isHiddenRedEnvelopesReceiveView = isHiddenRedEnvelopesReceiveView;
//}

//- (void)setBgTaskIdentifier:(UIBackgroundTaskIdentifier)bgTaskIdentifier{
//    _bgTaskIdentifier = bgTaskIdentifier;
//}
//
//- (void)setBgTaskTimer:(NSTimer *)bgTaskTimer{
//    _bgTaskTimer = bgTaskTimer;
//}

//- (void)setOpenRedEnvelopesBlock:(void (^)(void))openRedEnvelopesBlock{
//    _openRedEnvelopesBlock = [openRedEnvelopesBlock copy];
//}

- (void)setIsOpenRedEnvelopesHelper:(BOOL)isOpenRedEnvelopesHelper{
    _isOpenRedEnvelopesHelper = isOpenRedEnvelopesHelper;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenRedEnvelopesHelper forKey:isOpenRedEnvelopesHelperKey];
}

- (void)setIsOpenSportHelper:(BOOL)isOpenSportHelper{
    _isOpenSportHelper = isOpenSportHelper;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenSportHelper forKey:isOpenSportHelperKey];
}
- (void)setSportStepCountMode:(BOOL)sportStepCountMode{
    _sportStepCountMode = sportStepCountMode;
    [[NSUserDefaults standardUserDefaults] setBool:sportStepCountMode forKey:sportStepCountModeKey];
}
- (void)setIsOpenBackgroundMode:(BOOL)isOpenBackgroundMode{
    _isOpenBackgroundMode = isOpenBackgroundMode;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenBackgroundMode forKey:isOpenBackgroundModeKey];
}
- (void)setIsOpenAvoidRevokeMessage:(BOOL)isOpenAvoidRevokeMessage{
    _isOpenAvoidRevokeMessage = isOpenAvoidRevokeMessage;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenAvoidRevokeMessage forKey:isOpenAvoidRevokeMessageKey];
}
- (void)setIsOpenRedEnvelopesAlert:(BOOL)isOpenRedEnvelopesAlert{
    _isOpenRedEnvelopesAlert = isOpenRedEnvelopesAlert;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenRedEnvelopesAlert forKey:isOpenRedEnvelopesAlertKey];
}
- (void)setIsSnatchSelfRedEnvelopes:(BOOL)isSnatchSelfRedEnvelopes{
    _isSnatchSelfRedEnvelopes = isSnatchSelfRedEnvelopes;
    [[NSUserDefaults standardUserDefaults] setBool:isSnatchSelfRedEnvelopes forKey:isSnatchSelfRedEnvelopesKey];
}
- (void)setIsOpenVirtualLocation:(BOOL)isOpenVirtualLocation{
    _isOpenVirtualLocation = isOpenVirtualLocation;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenVirtualLocation forKey:isOpenVirtualLocationKey];
}
- (void)setIsOpenKeywordFilter:(BOOL)isOpenKeywordFilter{
    _isOpenKeywordFilter = isOpenKeywordFilter;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenKeywordFilter forKey:isOpenKeywordFilterKey];
}
- (void)setIsOpenAutoReply:(BOOL)isOpenAutoReply{
    _isOpenAutoReply = isOpenAutoReply;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenAutoReply forKey:isOpenAutoReplyKey];
}

- (void)setIsOpenAutoLeaveMessage:(BOOL)isOpenAutoLeaveMessage{
    _isOpenAutoLeaveMessage = isOpenAutoLeaveMessage;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenAutoLeaveMessage forKey:isOpenAutoLeaveMessageKey];
}

- (void)setFilterRoomDic:(NSMutableDictionary *)filterRoomDic{
    _filterRoomDic = filterRoomDic;
    [[NSUserDefaults standardUserDefaults] setObject:filterRoomDic forKey:filterRoomDicKey];
}

- (void)setOpenRedEnvelopesDelaySecond:(CGFloat)openRedEnvelopesDelaySecond{
    _openRedEnvelopesDelaySecond = openRedEnvelopesDelaySecond;
    [[NSUserDefaults standardUserDefaults] setFloat:openRedEnvelopesDelaySecond forKey:openRedEnvelopesDelaySecondKey];
}
- (void)setAutoReplyText:(NSString *)autoReplyText{
    _autoReplyText = [autoReplyText copy];
    [[NSUserDefaults standardUserDefaults] setObject:autoReplyText forKey:autoReplyTextKey];
}

- (void)setAutoLeaveMessageText:(NSString *)autoLeaveMessageText{
    _autoLeaveMessageText = [autoLeaveMessageText copy];
    [[NSUserDefaults standardUserDefaults] setObject:autoLeaveMessageText forKey:autoLeaveMessageTextKey];
}

- (void)setKeywordFilterText:(NSString *)keywordFilterText{
    _keywordFilterText = [keywordFilterText copy];
    [[NSUserDefaults standardUserDefaults] setObject:keywordFilterText forKey:keywordFilterTextKey];
}

- (void)setWantSportStepCount:(NSInteger)wantSportStepCount{
    _wantSportStepCount = wantSportStepCount;
    [[NSUserDefaults standardUserDefaults] setInteger:wantSportStepCount forKey:wantSportStepCountKey];
}
- (void)setSportStepCountLowerLimit:(NSInteger)sportStepCountLowerLimit{
    _sportStepCountLowerLimit = sportStepCountLowerLimit;
    [[NSUserDefaults standardUserDefaults] setInteger:sportStepCountLowerLimit forKey:sportStepCountLowerLimitkey];
}
- (void)setSportStepCountUpperLimit:(NSInteger)sportStepCountUpperLimit{
    _sportStepCountUpperLimit = sportStepCountUpperLimit;
    [[NSUserDefaults standardUserDefaults] setInteger:sportStepCountUpperLimit forKey:sportStepCountUpperLimitKey];
}
- (void)setTotalAssistAmount:(double)totalAssistAmount{
    _totalAssistAmount = totalAssistAmount;
    [[NSUserDefaults standardUserDefaults] setInteger:totalAssistAmount forKey:totalAssistAmountKey];
}
- (void)setIsOpenBlockSendInputStatus:(BOOL)isOpenBlockSendInputStatus{
    _isOpenBlockSendInputStatus = isOpenBlockSendInputStatus;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenBlockSendInputStatus forKey:isOpenBlockSendInputStatusKey];
}

//new

- (void)setBgTaskIdentifier:(UIBackgroundTaskIdentifier)bgTaskIdentifier{
    _bgTaskIdentifier = bgTaskIdentifier;
}

- (void)setBgTaskTimer:(NSTimer *)bgTaskTimer{
    _bgTaskTimer = bgTaskTimer;
}

- (BOOL)isHiddenRedEnvelopesReceiveView:(id)object{
    return [objc_getAssociatedObject(object, &isHiddenRedEnvelopesReceiveViewKey) boolValue];
}

- (void)setIsHiddenRedEnvelopesReceiveView:(id)object value:(BOOL)value{
    objc_setAssociatedObject(object, &isHiddenRedEnvelopesReceiveViewKey, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeIsHiddenRedEnvelopesReceiveView:(id)object{
    objc_removeAssociatedObjects(object);
}

- (id)logicController:(id)object{
    return objc_getAssociatedObject(object, &logicControllerKey);
}

//处理微信消息,过滤红包消息
- (void)handleMessageWithMessageWrap:(CMessageWrap *)msgWrap isBackground:(BOOL)isBackground{
    if (msgWrap && msgWrap.m_uiMessageType == 49 && [self isSnatchRedEnvelopes:msgWrap]){
        //红包消息
        self.lastMsgWrap = self.msgWrap;
        self.msgWrap = msgWrap;
        [self openRedEnvelopes];
//        self.haveNewRedEnvelopes = YES;
//        if(isBackground && self.openRedEnvelopesBlock){
//            self.openRedEnvelopesBlock();
//        }
    }
}

//判断是否是我发送的消息
- (BOOL)isMySendMsgWithMsgWrap:(CMessageWrap *)msgWrap{
    CContactMgr *contactMgr = [[NSClassFromString(@"MMServiceCenter") defaultCenter] getService:NSClassFromString(@"CContactMgr")];
    CContact *selfContact = [contactMgr getSelfContact];
    CContact *senderContact = [contactMgr getContactByName:msgWrap.m_nsFromUsr];
    return [selfContact isEqualToContact:senderContact];
}

//判断是否抢红包
- (BOOL)isSnatchRedEnvelopes:(CMessageWrap *)msgWrap{
    unsigned int appMsgInnerType = msgWrap.m_uiAppMsgInnerType;
    if(appMsgInnerType == 0x1 || appMsgInnerType == 0xa){
        return NO;
    }
    if(!(appMsgInnerType != 0x7d0 || msgWrap.m_oWCPayInfoItem.m_uiPaySubType >= 0xb)){
        return NO;
    }
    if(appMsgInnerType != 0x7d1 || msgWrap.m_oWCPayInfoItem.m_sceneId != 0x3ea){
        return NO;
    }
    if(!((msgWrap.m_n64MesSvrID == 0 && msgWrap.m_oWCPayInfoItem.m_nsPayMsgID != self.lastMsgWrap.m_oWCPayInfoItem.m_nsPayMsgID) || msgWrap.m_n64MesSvrID != self.lastMsgWrap.m_n64MesSvrID)){
        return NO; //过滤领取红包消息
    }
    if([self isMySendMsgWithMsgWrap:msgWrap]){
        return _isSnatchSelfRedEnvelopes;
    }
    if(_filterRoomDic && _filterRoomDic[msgWrap.m_nsFromUsr]){
        return NO; //过滤群组
    }
    if(_isOpenKeywordFilter){
        NSString *wishing = [msgWrap wishingString];
        NSArray *keywords = [_keywordFilterText componentsSeparatedByString:@","];
        for (NSString *keyword in keywords) {
            if ([wishing containsString:keyword]) {
                return NO; //过滤关键字
            }
        }
    }
    return YES;
}

#pragma mark HANDLER METHOD

- (void)openRedEnvelopes{
    NewMainFrameViewController *mainVC = [[NSClassFromString(@"CAppViewControllerManager") getAppViewControllerManager] getNewMainFrameViewController];
    NSArray *controllers = mainVC.navigationController.viewControllers;
    BaseMsgContentViewController *msgContentVC = nil;
    for (UIViewController *aController in controllers) {
        if ([aController isMemberOfClass:NSClassFromString(@"BaseMsgContentViewController")]) {
            msgContentVC = (BaseMsgContentViewController *)aController;
            break;
        }
    }
    CContactMgr *contactMgr = [[NSClassFromString(@"MMServiceCenter") defaultCenter] getService:NSClassFromString(@"CContactMgr")];
    CContact *fromContact = [contactMgr getContactByName:self.msgWrap.m_nsFromUsr];
    BOOL isMySendMsg = [self isMySendMsgWithMsgWrap:self.msgWrap];
    BaseMsgContentViewController *baseMsgVC = nil;
    if(!isMySendMsg && ![[msgContentVC getChatContact] isEqualToContact:fromContact]){
        BaseMsgContentLogicController *logicController = [[NSClassFromString(@"BaseMsgContentLogicController") alloc] initWithLocalID:self.msgWrap.m_uiMesLocalID CreateTime:self.msgWrap.m_uiCreateTime ContentViewDisshowStatus:0x4];
        [logicController setM_contact:fromContact];
        [logicController setM_dicExtraInfo:nil];
        [logicController onWillEnterRoom];
        objc_setAssociatedObject(self.msgWrap,&logicControllerKey,logicController,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //self.logicController = logicController;
        //MMMsgLogicManager *logicMgr = [[NSClassFromString(@"MMServiceCenter") defaultCenter] getService:NSClassFromString(@"MMMsgLogicManager")];
        //[logicMgr PushLogicController:logicController navigationController:mainVC.navigationController animated:NO];
        baseMsgVC = [logicController getMsgContentViewController];
    } else {
        //self.logicController = nil;
        baseMsgVC = msgContentVC;
    }
    [self handleRedEnvelopesPushVC:baseMsgVC];
    //if (msgContentVC) {
    //    [mainVC.navigationController PushViewController:msgContentVC animated:YES];
    //} else {
    //    [mainVC tableView:[mainVC valueForKey:@"m_tableView"] didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //}
}

- (void)handleRedEnvelopesPushVC:(BaseMsgContentViewController *)baseMsgVC{
    //红包push
    if(![[self.msgWrap nativeUrl] containsString:@"weixin://openNativeUrl/weixinHB/startreceivebizhbrequest?"]){
        
        /*if(!isMySendMsg && ![[baseMsgVC getChatContact] isEqualToContact:fromContact]){
         BaseMsgContentLogicController *logicController = [[NSClassFromString(@"BaseMsgContentLogicController") alloc] initWithLocalID:self.msgWrap.m_uiMesLocalID CreateTime:self.msgWrap.m_uiCreateTime ContentViewDisshowStatus:0x4];
         [logicController setM_contact:fromContact];
         [logicController setM_dicExtraInfo:nil];
         [logicController onWillEnterRoom];
         self.logicController = logicController;
         baseMsgVC = [logicController getMsgContentViewController];
         } else {
         self.logicController = nil;
         }*/
        WCRedEnvelopesControlData *data = [[NSClassFromString(@"WCRedEnvelopesControlData") alloc] init];
        [data setM_oSelectedMessageWrap:self.msgWrap];
        WCRedEnvelopesControlMgr *controlMgr = [[NSClassFromString(@"MMServiceCenter") defaultCenter] getService:NSClassFromString(@"WCRedEnvelopesControlMgr")];
        //self.isHiddenRedEnvelopesReceiveView = YES;
        [self setIsHiddenRedEnvelopesReceiveView:self.msgWrap value:YES];
        [controlMgr startReceiveRedEnvelopesLogic:baseMsgVC Data:data];
    }
}

- (void)successOpenRedEnvelopesHandler:(WCRedEnvelopesDetailInfo *)detailInfo{
    long long m_lAmount = detailInfo.m_lAmount;
    self.totalAssistAmount += m_lAmount;
    [[NSUserDefaults standardUserDefaults] setInteger:self.totalAssistAmount forKey:totalAssistAmountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(self.isOpenRedEnvelopesAlert){
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = [NSString stringWithFormat:@"帮您领了%.2f元红包！快去查看吧~",m_lAmount / 100.0f];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        [self playCashReceivedAudio];
    }
}

//程序进入后台处理
- (void)enterBackgroundHandler{
    if(!self.isOpenBackgroundMode){
        return;
    }
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTaskIdentifier];
        self.bgTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    self.bgTaskTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(requestMoreTime) userInfo:nil repeats:YES];
    [self.bgTaskTimer fire];
}

- (void)requestMoreTime{
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 30) {
    	[self playBlankAudio];
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskIdentifier];
        self.bgTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskIdentifier];
            self.bgTaskIdentifier = UIBackgroundTaskInvalid;
        }];
    }
}

//播放收到红包音频
- (void)playCashReceivedAudio{
    [self playAudioForResource:@"cash_received" ofType:@"caf"];
}

//播放无声音频
- (void)playBlankAudio{
    [self playAudioForResource:@"blank" ofType:@"caf"];
}

//开始播放音频
- (void)playAudioForResource:(NSString *)resource ofType:(NSString *)ofType{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     withOptions: AVAudioSessionCategoryOptionMixWithOthers
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    NSURL *blankSoundURL = [[NSURL alloc]initWithString:[[NSBundle mainBundle] pathForResource:resource ofType:ofType]];
    if(blankSoundURL){
        self.blankPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:blankSoundURL error:nil];
        [self.blankPlayer play];
    }
}

//处理运动步数
- (long)getSportStepCount{
    if(_sportStepCountMode){
        return [self genRandomNumberFrom:_sportStepCountUpperLimit to:_sportStepCountLowerLimit];
    } else {
        return _wantSportStepCount;
    }
}

//在指定范围生成随机数
- (long)genRandomNumberFrom:(long)from to:(long)to{  
    return (long)(from + (arc4random() % (to - from + 1)));  
}

- (double)latitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:XYLatitudeValueKey];
}

- (void)setLatitude:(double)latitude {
    [[NSUserDefaults standardUserDefaults] setDouble:latitude forKey:XYLatitudeValueKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)longitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:XYLongitudeValueKey];
}

- (void)setLongitude:(double)longitude {
    [[NSUserDefaults standardUserDefaults] setDouble:longitude forKey:XYLongitudeValueKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)poiName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"poiName"];
}
- (void)setPoiName:(NSString *)poiName{
    [[NSUserDefaults standardUserDefaults] setObject:poiName forKey:@"poiName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取虚拟位置
- (CLLocation *)getVirutalLocationWithRealLocation:(CLLocation *)realLocation{
    return self.isOpenVirtualLocation ? [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude) altitude:realLocation.altitude horizontalAccuracy: realLocation.horizontalAccuracy verticalAccuracy:realLocation.verticalAccuracy course:realLocation.course speed:realLocation.speed timestamp:realLocation.timestamp] : realLocation;
}
- (BOOL)isUpdateLocation{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"isUpdateLocation"];
}
- (void)setIsUpdateLocation:(BOOL)isUpdateLocation{
    [[NSUserDefaults standardUserDefaults] setBool:isUpdateLocation forKey:@"isUpdateLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPreventGameCheatEnable:(BOOL)preventGameCheatEnable {
    _preventGameCheatEnable = preventGameCheatEnable;
    [[NSUserDefaults standardUserDefaults] setBool:preventGameCheatEnable forKey:KTKPreventGameCheatEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
