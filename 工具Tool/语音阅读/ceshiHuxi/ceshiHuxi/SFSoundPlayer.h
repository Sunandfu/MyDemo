//
//  SDSoundPlayer.h
//  wuxiangundongview
//
//  Created by 小富 on 16/7/5.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@protocol SFSoundPlayerDelegate <NSObject>

@optional

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance;//朗读开始
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance;//朗读暂停
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance;//朗读继续
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance;//朗读结束
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance;//朗读中

@end

@interface SFSoundPlayer : NSObject<AVSpeechSynthesizerDelegate>

@property(nonatomic,assign)float rate;   //语速
@property(nonatomic,assign)float volume; //音量
@property(nonatomic,assign)float pitchMultiplier;  //音调
@property(nonatomic,assign)BOOL  autoPlay;  //自动播放

@property (weak,nonatomic) id<SFSoundPlayerDelegate> delegate;

//类方法实例出对象
+(SFSoundPlayer *)SFSoundPlayerInit;

//基础设置，如果有别的设置，也很好实现
/**
 *  设置播放的声音参数 如果选择默认请传入 -1.0
 *  @param aVolume          音量（0.0~1.0）默认为1.0
 *  @param aRate            语速（0.0~1.0）
 *  @param aPitchMultiplier 语调 (0.5-2.0)
 */
-(void)setDefaultWithVolume:(float)aVolume rate:(CGFloat)aRate pitchMultiplier:(CGFloat)aPitchMultiplier;

//播放文字
-(void)play:(NSString *)string;

- (void)stopSpeaking;//停止播放
- (void)pauseSpeaking;//暂停播放
- (void)continueSpeaking;//继续播放

@end
