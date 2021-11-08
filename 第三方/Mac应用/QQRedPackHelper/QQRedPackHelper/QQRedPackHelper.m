//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//
//  QQRedPackHelper.m
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/2/4.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import "QQRedPackHelper.h"
#import "substrate.h"
#import "QQHelperSetting.h"

@class MQAIOChatViewController;
@class MQAIORecentSessionViewController;

@class BHMsgListManager;
@class AppController;
@class MQAIOChatViewController;
@class TChatWalletTransferViewController;
@class RedPackWindowController;
@class RedPackViewController;
@class MsgDbService;
@class BHMsgManager;

static void openRedPack(BHMessageModel *msgKey) {
    if ([[QQHelperSetting sharedInstance] isEnableRedPacket]) {
        if ([msgKey isKindOfClass:NSClassFromString(@"BHMessageModel")]) {
            int mType = [[msgKey valueForKey:@"_msgType"] intValue];
            int read = [[msgKey valueForKey:@"_read"] intValue];
            NSInteger groupCode = [[msgKey valueForKey:@"_groupCode"] integerValue];
            if (mType == 311 && read == 0) {
                if (groupCode == 0) {
                    // 个人红包处理逻辑
                    BOOL personOk = [[QQHelperSetting sharedInstance] isPersonRedPackage];
                    if (!personOk) {
                        return;
                    }
                    NSString * content = [msgKey performSelector:@selector(content)];
                    NSDictionary * contentDic = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                    NSString *title = [contentDic objectForKey:@"title"];
                    NSString *msgType = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"msgType"]];
                    // 1. 关键字过滤
                    BOOL ok = [[QQHelperSetting sharedInstance] keywordContainer:title];
                    if (ok) {
                        return;
                    }
                    // 2. 红包延迟
                    QQHelperSetting *helper = [QQHelperSetting sharedInstance];
                    NSInteger delayInSeconds = [helper getRandomNumber:[helper startTime] to:[helper endTime]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [NSClassFromString(@"RedPackHelper") openRedPackWithMsgModel:msgKey operation:0];
                        if ([msgType isEqualToString:@"6"]) {
                            // 口令红包
                            NSString *notice = [contentDic objectForKey:@"notice"];
                            NSString *redContent = [[notice componentsSeparatedByString:@"[QQ红包]"] lastObject];
                            if (redContent) {
                                [[QQHelperSetting new] sendTextMessage:redContent uin:[msgKey.uin longLongValue] sessionType:msgKey.msgSessionType delay:0.2];
                            }
                        }
                        [QQHelperNotification showNotificationWithTitle:@"红包助手提示" content:@"抢到红包😝😝😝"];
                        NSLog(@"QQRedPackHelper：抢到红包 %@ ---- 详细信息: %@",msgKey,content);
                    });
                }
                else {
                    // 群红包处理逻辑
                    NSString * content = [msgKey performSelector:@selector(content)];
                    NSDictionary * contentDic = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                    NSString *title = [contentDic objectForKey:@"title"];
                    NSString *msgType = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"msgType"]];
                    // 1. 关键字过滤
                    BOOL ok = [[QQHelperSetting sharedInstance] keywordContainer:title];
                    if (ok) {
                        return;
                    }
                    // 2. 指定群过滤
                    BOOL groupOk = [[QQHelperSetting sharedInstance] groupSessionIdContainer:groupCode];
                    if (groupOk) {
                        return;
                    }
                    // 3. 红包延迟
                    QQHelperSetting *helper = [QQHelperSetting sharedInstance];
                    NSInteger delayInSeconds = [helper getRandomNumber:[helper startTime] to:[helper endTime]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [NSClassFromString(@"RedPackHelper") openRedPackWithMsgModel:msgKey operation:0];
                        if ([msgType isEqualToString:@"6"]) {
                            // 口令红包
                            NSString *notice = [contentDic objectForKey:@"notice"];
                            NSString *redContent = [[notice componentsSeparatedByString:@"[QQ红包]"] lastObject];
                            if (redContent) {
                                [[QQHelperSetting new] sendTextMessage:redContent uin:[msgKey.groupCode longLongValue] sessionType:msgKey.msgSessionType delay:0.2];
                            }
                        }
                        [QQHelperNotification showNotificationWithTitle:@"红包助手提示" content:@"抢到红包😝😝😝"];
                        NSLog(@"QQRedPackHelper：抢到红包 %@ ---- 详细信息: %@",msgKey,content);
                    });
                }
            }
        }
    }
}

static void (*origin_MQAIORecentSessionViewController_setupMenuForSessionId)(MQAIORecentSessionViewController *,SEL,id,id);
static void new_MQAIORecentSessionViewController_setupMenuForSessionId(MQAIORecentSessionViewController* self,SEL _cmd,id a3,id a4) {
    origin_MQAIORecentSessionViewController_setupMenuForSessionId(self,_cmd,a3,a4);
    {
        NSInteger uin = [[a4 valueForKey:@"_uin"] integerValue];
        NSInteger sessionChatType = [[a4 valueForKey:@"_sessionChatType"] integerValue];
        if (sessionChatType == 2 && uin != 0) {
            {
                NSMenuItem *separatorItem1 = [NSMenuItem separatorItem];
                [a3 addItem:separatorItem1];
            }
            {
                RedPackSettingMenuItem *item = [RedPackSettingMenuItem sharedInstance];
                item.groupSessionId = uin;
                NSMenuItem *settingWindowItem = [item redPacSettingItem];
                BOOL ok = [[QQHelperSetting sharedInstance] groupSessionIdContainer:uin];
                if (ok) {
                    [settingWindowItem setState:NSControlStateValueOn];
                } else {
                    [settingWindowItem setState:NSControlStateValueOff];
                }
                [a3 addItem:settingWindowItem];
            }
        }
    }
}

static void (*origin_AppController_applicationDidFinishLaunching)(AppController *,SEL,NSNotification *);
static void new_AppController_applicationDidFinishLaunching(AppController* self,SEL _cmd,NSNotification * aNotification) {
    origin_AppController_applicationDidFinishLaunching(self,_cmd,aNotification);
    [[QQHelperMenu sharedInstance] addMenu];
}

static void (*origin_MQAIOChatViewController_revokeMessages)(MQAIOChatViewController*,SEL,id);
static void new_MQAIOChatViewController_revokeMessages(MQAIOChatViewController* self,SEL _cmd,id arrays){
    if (![[QQHelperSetting sharedInstance] isMessageRevoke]) {
        origin_MQAIOChatViewController_revokeMessages(self,_cmd,arrays);
    }
}

static void (*origin_QQMessageRevokeEngine_handleRecallNotify_isOnline)(QQMessageRevokeEngine*,SEL,void * ,BOOL);
static void new_QQMessageRevokeEngine_handleRecallNotify_isOnline(QQMessageRevokeEngine* self,SEL _cmd,void * notify,BOOL isOnline){
    if (![[QQHelperSetting sharedInstance] isMessageRevoke]) {
        origin_QQMessageRevokeEngine_handleRecallNotify_isOnline(self,_cmd,notify,isOnline);
    }
}

static void (*origin_RedPackViewController_viewDidLoad)(RedPackViewController*,SEL);
static void new_RedPackViewController_viewDidLoad(RedPackViewController* self,SEL _cmd) {
    origin_RedPackViewController_viewDidLoad(self,_cmd);
    NSViewController *redPackVc = (NSViewController *)self;
    [[QQHelperSetting sharedInstance] saveOneRedPacController:redPackVc];
    if ([[QQHelperSetting sharedInstance] isHideRedDetailWindow]) {
        [[QQHelperSetting sharedInstance] closeRedPacWindowns];
    }
}

// https://github.com/AsTryE/QQRedPackHelper/issues/13 历史消息记录不一致问题，感谢 TKkk-iOSer 提供思路
static NSString *(*origin_NSHomeDirectory)(void);
NSString *new_NSHomeDirectory(void) {
    return [NSString stringWithFormat:@"%@/Library/Containers/com.tencent.qq/Data",origin_NSHomeDirectory()];
}

static NSArray<NSString *> *(*origin_NSSearchPathForDirectoriesInDomains)(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde);
NSArray<NSString *> *new_NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde) {
    NSMutableArray<NSString *> *paths = [origin_NSSearchPathForDirectoriesInDomains(directory, domainMask, expandTilde) mutableCopy];
    NSString *sandBoxPath = [NSString stringWithFormat:@"%@/Library/Containers/com.tencent.qq/Data",origin_NSHomeDirectory()];
    [paths enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [filePath rangeOfString:origin_NSHomeDirectory()];
        if (range.length > 0) {
            NSMutableString *newFilePath = [filePath mutableCopy];
            [newFilePath replaceCharactersInRange:range withString:sandBoxPath];
            paths[idx] = newFilePath;
        }
    }];
    return paths;
}

// 消息撤回拦截

static void (*origin_MsgDbService_updateMessageModel_keyArray)(MsgDbService *,SEL, BHMessageModel * ,id);
static void new_MsgDbService_updateMessageModel_keyArray(MsgDbService *self,SEL _cmd, BHMessageModel * msgModel ,id keyArrays) {
    if (msgModel.msgType != 332 || ![[QQHelperSetting sharedInstance] isMessageRevoke]) {
        origin_MsgDbService_updateMessageModel_keyArray(self,_cmd,msgModel,keyArrays);
        return;
    }
    
    NSString *revokeUserName;
    if (IS_VALID_STRING(msgModel.groupCode)) {
        BHGroupManager *groupManager = [objc_getClass("BHGroupManager") sharedInstance];
        revokeUserName = [groupManager displayNameForGroupMemberWithGroupCode:msgModel.groupCode memberUin:msgModel.uin];
    } else if (IS_VALID_STRING(msgModel.discussGroupUin)) {
        BHGroupManager *groupManager = [objc_getClass("BHGroupManager") sharedInstance];
        revokeUserName = [groupManager displayNameForGroupMemberWithGroupCode:msgModel.discussGroupUin memberUin:msgModel.uin];
    } else {
        BHFriendListManager *friendManager = [objc_getClass("BHFriendListManager") sharedInstance];
        BHFriendModel *frindModel =  [friendManager getFriendModelByUin:msgModel.uin];
        if (IS_VALID_STRING(frindModel.remark)) {
            revokeUserName = frindModel.remark;
        } else {
            revokeUserName = frindModel.profileModel.nick;
        }
    }
    
    NSString *sessionUin = [[QQHelperSetting sharedInstance] getUinByMessageModel:msgModel];
    MsgDbService *msgService = [objc_getClass("MsgDbService") sharedInstance];
    BHMessageModel *revokeMsgModel = [[msgService getMessageWithUin:[sessionUin longLongValue]
                                                           sessType:msgModel.msgSessionType
                                                             msgIds:@[@(msgModel.msgID)]] firstObject];
    
    NSString *revokeMsg = @"[非文本信息]";
    switch (revokeMsgModel.msgType) {
        case 1024: {
            NSArray *msgContent =  [[QQHelperSetting sharedInstance] msgContentsFromMessageModel:revokeMsgModel];
            if (msgContent.count > 1) {
                revokeMsg = @"[富文本]";
            } else if (msgContent.count == 1) {
                NSDictionary *msgDict = msgContent.firstObject;
                if ([msgDict[@"msg-type"] integerValue] == 0) {         // 纯文字
                    revokeMsg = msgDict[@"text"];
                    if (revokeMsg.length > 35) {
                        revokeMsg = [[revokeMsg substringToIndex:35] stringByAppendingString:@"…"];
                    }
                } else if ([msgDict[@"msg-type"] integerValue] == 1) {  // 纯图片
                    revokeMsg = @"[图片]";
                }
            }
            break;
        }
        case 3:
            revokeMsg = @"[语音]";
            break;
        case 4:
            revokeMsg = @"[文件(视频)]";
            break;
        case 181:
            revokeMsg = @"[视频]";
            break;
        case 140:
            revokeMsg = @"[分享(位置|联系人|收藏)]";
            break;
        default:
            revokeMsg = @"[非文本消息]";
            break;
    }
    
    NSString *revokeTipContent = [NSString stringWithFormat:@"QQ助手 拦截到一条撤回消息:\n\t%@：%@", revokeUserName, revokeMsg];
    if (msgModel.isSelfSend) {
        revokeTipContent = @"你 撤回了一条消息";
    }
    
    BHTipsMsgOption *tipOpt = [[objc_getClass("BHTipsMsgOption") alloc] init];
    tipOpt.addToDb = YES;
    
    BHMsgManager *msgManager = [objc_getClass("BHMsgManager") sharedInstance];
    [msgManager addTipsMessage:revokeTipContent sessType:msgModel.msgSessionType uin:sessionUin option:tipOpt];
}

// 接受消息响应函数
static void (* origin_BHMsgManager_appendReceiveMessageModel_msgSource)(BHMsgManager *,SEL , NSArray * ,long long);
static void new_BHMsgManager_appendReceiveMessageModel_msgSource(BHMsgManager *self,SEL _cmd, NSArray * msgModels ,long long arg2) {
    origin_BHMsgManager_appendReceiveMessageModel_msgSource(self,_cmd,msgModels,arg2);
    [msgModels enumerateObjectsUsingBlock:^(BHMessageModel *msgModel, NSUInteger idx, BOOL * _Nonnull stop) {
            // 自动回复
            [[QQHelperSetting sharedInstance] autoReplyWithMsg:msgModel];
            // 自动抢他人发送红包
            openRedPack(msgModel);
    }];
}

static void (* origin_AppController_notifyLoginWithAccount_resultCode_userInfo)(AppController *self, SEL _cmd, id arg1,  long long arg2 ,id arg3);
static void new_AppController_notifyLoginWithAccount_resultCode_userInfo(AppController *self, SEL _cmd, id arg1,  long long arg2 ,id arg3) {
    origin_AppController_notifyLoginWithAccount_resultCode_userInfo(self,_cmd,arg1,arg2,arg3);
    [[TKWebServerManager shareManager] startServer];
}

static void (* origin_AppController_notifyForceLogoutWithAccount_type_tips)(AppController *self, SEL _cmd, id arg1,  long long arg2 ,id arg3);
static void new_AppController_notifyForceLogoutWithAccount_type_tips(AppController *self, SEL _cmd, id arg1,  long long arg2 ,id arg3) {
    origin_AppController_notifyForceLogoutWithAccount_type_tips(self,_cmd,arg1,arg2,arg3);
    [[TKWebServerManager shareManager] endServer];
}

static void __attribute__((constructor)) initialize(void) {
    
    NSLog(@"QQRedPackHelper：抢红包插件4.0 开启 ----------------------------------");
    
    // 初始化红包关键字配置
    if ([[QQHelperSetting sharedInstance] filterKeyword] == nil) {
        [[QQHelperSetting sharedInstance] setFilterKeyword:@"外挂,测试"];
    }
    
    // 消息防撤回 1
    MSHookMessageEx(objc_getClass("MQAIOChatViewController"),  @selector(revokeMessages:), (IMP)&new_MQAIOChatViewController_revokeMessages, (IMP*)&origin_MQAIOChatViewController_revokeMessages);
    
    // 消息防撤回 2
    MSHookMessageEx(objc_getClass("MsgDbService"),  @selector(updateQQMessageModel:keyArray:), (IMP)&new_MsgDbService_updateMessageModel_keyArray, (IMP*)&origin_MsgDbService_updateMessageModel_keyArray);
    
    // 接受消息响应
    MSHookMessageEx(objc_getClass("BHMsgManager"),  @selector(appendReceiveMessageModel:msgSource:), (IMP)&new_BHMsgManager_appendReceiveMessageModel_msgSource, (IMP*)&origin_BHMsgManager_appendReceiveMessageModel_msgSource);

    // 助手设置菜单项
    MSHookMessageEx(objc_getClass("AppController"), @selector(applicationDidFinishLaunching:), (IMP)&new_AppController_applicationDidFinishLaunching, (IMP *)&origin_AppController_applicationDidFinishLaunching);
    
    // 群右键设置选项
    MSHookMessageEx(objc_getClass("MQAIORecentSessionViewController"), @selector(setupMenu:forSessionId:), (IMP)&new_MQAIORecentSessionViewController_setupMenuForSessionId, (IMP *)&origin_MQAIORecentSessionViewController_setupMenuForSessionId);
    
    // 自动关闭红包弹框
     MSHookMessageEx(objc_getClass("RedPackViewController"), @selector(viewDidLoad), (IMP)&new_RedPackViewController_viewDidLoad, (IMP *)&origin_RedPackViewController_viewDidLoad);
    
    // 解决历史记录
    MSHookFunction(&NSSearchPathForDirectoriesInDomains, &new_NSSearchPathForDirectoriesInDomains, &origin_NSSearchPathForDirectoriesInDomains);
    MSHookFunction(&NSHomeDirectory, &new_NSHomeDirectory, &origin_NSHomeDirectory);
    
    // 开启本地服务器
    MSHookMessageEx(objc_getClass("AppController"), @selector(notifyLoginWithAccount:resultCode:userInfo:), (IMP)&new_AppController_notifyLoginWithAccount_resultCode_userInfo, (IMP *)&origin_AppController_notifyLoginWithAccount_resultCode_userInfo);
    MSHookMessageEx(objc_getClass("AppController"), @selector(notifyForceLogoutWithAccount:type:tips:), (IMP)&new_AppController_notifyForceLogoutWithAccount_type_tips, (IMP *)&origin_AppController_notifyForceLogoutWithAccount_type_tips);
}
