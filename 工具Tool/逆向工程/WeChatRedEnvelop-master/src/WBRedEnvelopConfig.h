//
//  WBRedEnvelopConfig.h
//  WeChatRedEnvelop
//
//  Created by 杨志超 on 2017/2/22.
//  Copyright © 2017年 swiftyper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CContact;
@interface WBRedEnvelopConfig : NSObject

+ (instancetype)sharedConfig;

@property (assign, nonatomic) BOOL autoReceiveEnable;
@property (assign, nonatomic) NSInteger delaySeconds;

/** Pro */
@property (assign, nonatomic) BOOL receiveSelfRedEnvelop;
@property (assign, nonatomic) BOOL serialReceive;
@property (strong, nonatomic) NSArray *blackList;
@property (assign, nonatomic) BOOL revokeEnable;

/**  步数设置 */
@property (nonatomic, assign) BOOL changeStepEnable;
@property (nonatomic, assign) NSInteger deviceStep;            /**<    步数设置  */

/**  游戏作弊 */
@property (nonatomic, assign) BOOL preventGameCheatEnable;

/// 是否修改经纬度
@property (nonatomic, assign) BOOL shouldChangeCoordinate;
/// 经度
@property (nonatomic, assign) double latitude;
/// 纬度
@property (nonatomic, assign) double longitude;
/// 在我们进行坐标选择的时候,需要使用原始的
@property (nonatomic, assign) BOOL useOriginalCordinate;

@end
