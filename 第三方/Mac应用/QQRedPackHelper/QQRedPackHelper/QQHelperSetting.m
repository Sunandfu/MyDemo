//
//  QQHelperSetting.m
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/2.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#import "QQHelperSetting.h"

@implementation QQHelperSetting {
    
}

static NSString *hideRedDetailWindowKey = @"txh_hideRedDetailWindowKey";
static NSString *redPacketKey = @"txh_redPacketKeyy";
static NSString *messageRevokeKey = @"txh_messageRevokeKey";
static NSString *messageReplyKey = @"txh_messageAutoReply";

static NSString *startTimeKey = @"txh_startTimeKey";
static NSString *endTimeKey = @"txh_endTimeKey";

static NSString *msgRandomKey = @"txh_msgRandomKey";
static NSString *filterKeywordKey = @"txh_filterKeywordKey";

static NSString *groupSessionIdsKey = @"txh_groupSessionIdsKey";
static NSString *personRedPacKey = @"txh_personRedPacKey";

static QQHelperSetting *instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (BOOL)isPersonRedPackage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:personRedPacKey] != nil) {
        BOOL enable = [[[NSUserDefaults standardUserDefaults] objectForKey:personRedPacKey]boolValue];
        return enable;
    }
    return true;
}

- (void)setIsPersonRedPackage:(BOOL)isPersonRedPac {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isPersonRedPac] forKey:personRedPacKey];
}

- (NSNumber *)msgRandom {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:msgRandomKey] != nil) {
        NSNumber * randomValue = [[NSUserDefaults standardUserDefaults] objectForKey:msgRandomKey];
        return randomValue;
    }
    return nil;
}

- (void)setMsgRandom:(NSNumber *)msgRandom {
    [[NSUserDefaults standardUserDefaults] setObject:msgRandom forKey:msgRandomKey];
}

- (int)startTime {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:startTimeKey] != nil) {
        int time = [[[NSUserDefaults standardUserDefaults] objectForKey:startTimeKey]intValue];
        return time;
    }
    return 0;
}

- (void)setStartTime:(int)startTime {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:startTime] forKey:startTimeKey];
}

- (int)endTime {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:endTimeKey] != nil) {
        int time = [[[NSUserDefaults standardUserDefaults] objectForKey:endTimeKey]intValue];
        return time;
    }
    return 0;
}

- (void)setEndTime:(int)endTime {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:endTime] forKey:endTimeKey];
}

- (void)setIsEnableRedPacket:(BOOL)isEnableRedPacket {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isEnableRedPacket] forKey:redPacketKey];
}

- (BOOL)isEnableRedPacket {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:redPacketKey] != nil) {
        BOOL enable = [[[NSUserDefaults standardUserDefaults] objectForKey:redPacketKey]boolValue];
        return enable;
    }
    return true;
}

- (void)setIsHideRedDetailWindow:(BOOL)isHideRedDetailWindow {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isHideRedDetailWindow] forKey:hideRedDetailWindowKey];
}

- (BOOL)isHideRedDetailWindow {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:hideRedDetailWindowKey] != nil) {
        BOOL autoLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:hideRedDetailWindowKey]boolValue];
        return autoLogin;
    }
    return false;
}

- (void)setIsMessageRevoke:(BOOL)isMessageRevoke {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isMessageRevoke] forKey:messageRevokeKey];
}

- (BOOL)isMessageRevoke {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:messageRevokeKey] != nil) {
        BOOL autoLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:messageRevokeKey]boolValue];
        return autoLogin;
    }
    return false;
}

//- (BOOL)isMessageReply {
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:messageReplyKey] != nil) {
//        BOOL autoLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:messageReplyKey]boolValue];
//        return autoLogin;
//    }
//    return false;
//}
//
//- (void)setIsMessageReply:(BOOL)isMessageReply {
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isMessageReply] forKey:messageReplyKey];
//}

- (void)saveOneRedPacController:(NSViewController *)redPacVc {
    if (self.redPacControllers == nil) {
        self.redPacControllers = [NSMutableArray new];
    }
    [self.redPacControllers addObject:redPacVc];
}

- (void)closeRedPacWindowns {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.redPacControllers == nil || [self.redPacControllers count] == 0) {
            return;
        }
        NSArray *controllers = [self.redPacControllers copy];
        for (NSViewController *vc in controllers) {
            [vc performSelector:@selector(onClose:) withObject:nil];
            [self.redPacControllers removeObject:vc];
        }
    });
}

- (NSString *)filterKeyword {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:filterKeywordKey] != nil) {
        NSString * keyword = [[NSUserDefaults standardUserDefaults] objectForKey:filterKeywordKey];
        return keyword;
    }
    return nil;
}

- (void)setFilterKeyword:(NSString *)filterKeyword {
    [[NSUserDefaults standardUserDefaults] setObject:filterKeyword forKey:filterKeywordKey];
}

- (NSArray *)sessionIds {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:groupSessionIdsKey] != nil) {
        NSArray * tempSessionIds = [[NSUserDefaults standardUserDefaults] objectForKey:groupSessionIdsKey];
        return tempSessionIds;
    }
    return nil;
}

- (void)setSessionIds:(NSArray *)sessionIds {
    // groupSessionIdsKey
    [[NSUserDefaults standardUserDefaults] setObject:sessionIds forKey:groupSessionIdsKey];
}

#pragma mark - tools

- (NSInteger)getRandomNumber:(int)from to:(int)to
{
    int time = (int)(from + (arc4random() % (to - from + 1)));
    return [[NSNumber numberWithInt:time] integerValue];
}


- (void)showWarnMessage:(NSString *)msg {
    NSAlert *alert = [[NSAlert alloc]init];
    [alert addButtonWithTitle:@"确定"];
    alert.messageText = @"提示";
    alert.informativeText = msg;
    [alert setAlertStyle:NSAlertStyleWarning];
    //回调Block
    NSWindow *mainWindow = [NSApp mainWindow];
    [alert beginSheetModalForWindow:mainWindow completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn ) {
            // 处理点击事件
        }
    }];
}

- (void)showMessage:(NSString *)msg {
    NSAlert *alert = [[NSAlert alloc]init];
    [alert addButtonWithTitle:@"确定"];
    alert.messageText = @"提示";
    alert.informativeText = msg;
    [alert setAlertStyle:NSAlertStyleInformational];
    //回调Block
    NSWindow *mainWindow = [NSApp mainWindow];
    [alert beginSheetModalForWindow:mainWindow completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn ) {
            // 处理点击事件
        }
    }];
}

- (BOOL)keywordContainer:(NSString *)redPackKeyword {
    if ([redPackKeyword isEqualToString:@""]) {
        return NO;
    }
    NSString *localKeyword = [self filterKeyword];
    if (localKeyword == nil) {
        return NO;
    }
    if (![localKeyword containsString:@","] && ![localKeyword containsString:@"，"]) {
        // 单个字符
        return [redPackKeyword containsString:localKeyword];
    }
    
    // 多个字符判断，可以处理中英文状态下的逗号
    NSString *temp = @",";
    if ([localKeyword containsString:@"，"]) {
        temp = @"，";
    }
    NSArray *keywords = [localKeyword componentsSeparatedByString:temp];
    __block BOOL result = NO;
    if ([keywords count] >= 1) {
        [keywords enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
            NSString *keyword = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([redPackKeyword containsString:keyword]) {
                result = YES;
                *stop = YES;
            }
        }];
    }
    return result;
}

- (BOOL)groupSessionIdContainer:(NSInteger)sessionId {
    __block BOOL result = NO;
    NSArray *localSessionIds = [self sessionIds];
    if ([localSessionIds count] != 0)  {
        [localSessionIds enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
            NSInteger tempSessionId = [obj integerValue];
            if (tempSessionId == sessionId) {
                result = YES;
                *stop = YES;
            }
        }];
    }
    return result;
}

//- (BOOL)removeGroupById:(NSInteger)sessionId {
//    __block BOOL result = NO;
//    NSArray *localSessionIds = [self sessionIds];
//    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:localSessionIds];
//    if ([localSessionIds count] != 0)  {
//        [localSessionIds enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
//            NSInteger tempSessionId = [obj integerValue];
//            if (tempSessionId == sessionId) {
//                [tempArray removeObject:obj];
//            }
//        }];
//        [self setSessionIds:tempArray];
//    }
//    return result;
//}

/**
 获取当前消息的 uin
 
 @param msgModel 消息model
 @return 消息的 uin
 */
- (NSString *)getUinByMessageModel:(BHMessageModel *)msgModel {
    NSString *currentUin;
    if (IS_VALID_STRING(msgModel.groupCode)) {
        currentUin = msgModel.groupCode;
    } else if (IS_VALID_STRING(msgModel.discussGroupUin)) {
        currentUin = msgModel.discussGroupUin;
    } else {
        currentUin = msgModel.uin;
    }
    return currentUin;
}

/**
 获取当前消息的内容数组
 
 @param model 消息model
 @return 内容数组
 */
- (NSArray *)msgContentsFromMessageModel:(BHMessageModel *)model {
    NSData *jsonData = [model.smallContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *msgContent = [NSJSONSerialization JSONObjectWithData:jsonData
                                                          options:NSJSONReadingMutableContainers
                                                            error:&error];
    
    return error ? nil : msgContent;
}

/**
 自动回复
 
 @param msgModel 接收的消息
 */
- (void)autoReplyWithMsg:(BHMessageModel *)msgModel {
    if (msgModel.msgType != 1024) return;
    NSDate *now = [NSDate date];
    NSTimeInterval nowTime = [now timeIntervalSince1970];
    NSTimeInterval receiveTime = [msgModel time];
    NSTimeInterval value = nowTime - receiveTime;
    if (value > 180) { //   3 分钟前的不回复
        return;
    }
    
    NSArray *msgContentArray = [self msgContentsFromMessageModel:msgModel];
    NSMutableString *msgContent = [NSMutableString stringWithFormat:@""];
    if (msgContentArray.count > 0) {
        [msgContentArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (IS_VALID_STRING(obj[@"text"]) && [obj[@"msg-type"] integerValue] == 0) {
                [msgContent appendString:obj[@"text"]];
            }
        }];
    }
    
    NSArray *autoReplyModels = [[TKQQPluginConfig sharedConfig] autoReplyModels];
    [autoReplyModels enumerateObjectsUsingBlock:^(TKAutoReplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!model.enable) return;
        if (!model.replyContent || model.replyContent.length == 0) return;
        if ((IS_VALID_STRING(msgModel.groupCode) || IS_VALID_STRING(msgModel.discussGroupUin)) && !model.enableGroupReply) return;
        if (!(IS_VALID_STRING(msgModel.groupCode) || IS_VALID_STRING(msgModel.discussGroupUin)) && !model.enableSingleReply) return;
        
        NSArray *replyArray = [model.replyContent componentsSeparatedByString:@"|"];
        int index = arc4random() % replyArray.count;
        NSString *randomReplyContent = replyArray[index];
        
        if (model.enableRegex) {
            NSString *regex = model.keyword;
            NSError *error;
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
            if (error) return;
            NSInteger count = [regular numberOfMatchesInString:msgContent options:NSMatchingReportCompletion range:NSMakeRange(0, msgContent.length)];
            if (count > 0) {
                long long uin = [[self getUinByMessageModel:msgModel] longLongValue];
                NSInteger delayTime = model.enableDelay ? model.delayTime : 0;
                [self sendTextMessage:randomReplyContent uin:uin sessionType:msgModel.msgSessionType delay:delayTime];
            }
        } else {
            NSArray * keyWordArray = [model.keyword componentsSeparatedByString:@"|"];
            [keyWordArray enumerateObjectsUsingBlock:^(NSString *keyword, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([keyword isEqualToString:@"*"] || [msgContent isEqualToString:keyword]) {
                    long long uin = [[self getUinByMessageModel:msgModel] longLongValue];
                    NSInteger delayTime = model.enableDelay ? model.delayTime : 0;
                    [self sendTextMessage:randomReplyContent uin:uin sessionType:msgModel.msgSessionType delay:delayTime];
                }
            }];
        }
    }];
}

- (void)sendTextMessage:(NSString *)msg uin:(long long)uin sessionType:(int)type delay:(NSInteger)delayTime {
    if (delayTime == 0) {
        [TKMsgManager sendTextMessage:msg
                                  uin:uin
                          sessionType:type];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [TKMsgManager sendTextMessage:msg
                                      uin:uin
                              sessionType:type];
        });
    });
}

@end
