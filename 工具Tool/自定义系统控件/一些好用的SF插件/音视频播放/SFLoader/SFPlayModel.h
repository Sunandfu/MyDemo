//
//  SFPlayModel.h
//  deomo
//
//  Created by 张冬 on 2017/12/25.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
/// 播放的状态
typedef NS_ENUM(NSInteger , AVPlayStatus){
    /// 没有开始
    AVPlayNoStartStatus = 0,
    /// 暂停状态
    AVPlayPauseStatus,
    /// 播放状态
    AVPlayPlayingStatus,
    /// 缓冲状态
    AVPlayWaitStatus ,
    /// 播放完成
    AVPlayFinishStatus,
};

/// 准备可以开始播放的通知
#define ReadyToPlay_Notification @"READ_TO_PLAY_NOTIFICATION"
/// 播放加载失败的通知
#define PlayFailed_Notification @"PLAY_FAILED_NOTFICATION"

/**
 视频类控制
 */
@interface SFPlayModel : NSObject
/// 播放的layer
@property(nonatomic , strong , readonly)AVPlayerLayer *playLayer;
/// 当前播放的状态
@property(nonatomic , assign , readonly)AVPlayStatus playStatus;
/// 视频总的时间
@property(nonatomic , assign , readonly)NSTimeInterval totoalTime;
/// 当前视频播放的时间
@property(nonatomic , assign , readonly)NSTimeInterval currentTime;
/// 播放完成的回调
@property(nonatomic , copy , readwrite)void (^playFinishBlock)(BOOL isFinish,NSString* url);
/// 播放状态变化的回调
@property(nonatomic , copy , readwrite)void (^playStatusChange)(AVPlayStatus status);
/// 获取播放总时长的回调
@property(nonatomic , copy , readwrite)void (^getVidetTotalTimeBlock)(NSTimeInterval totalTime);
/// 缓存的回调
@property(nonatomic , copy , readwrite)void (^playCacheFinishBlock)(CGFloat progress);
/// 播放的回调
@property(nonatomic , copy , readwrite)void (^playBlock)(CGFloat progress);
/// 单利初始化
+ (instancetype)sharePlayer;
/// 设置播放链接
-(void)startPlay: (NSString *)urlStr;
/// 恢复播放
-(void)reStartPlay ;
/// 暂停播放
-(void)pausePlay ;
/// 释放当前的播放器
-(void)freePlayer;
/// 设置开始播放的时间
-(void)seekPlayTime:(NSTimeInterval)time;

@end
