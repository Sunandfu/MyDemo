//
//  SFSoundPlayer.m
//  wuxiangundongview
//
//  Created by 小富 on 16/7/5.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "SFSoundPlayer.h"

static SFSoundPlayer *soundplayer = nil;
@interface SFSoundPlayer ()

@property (nonatomic,strong) AVSpeechSynthesizer *player;

@end

@implementation SFSoundPlayer

+(SFSoundPlayer *)SFSoundPlayerInit

{
    if(soundplayer == nil)
    {
        soundplayer = [[SFSoundPlayer alloc]init];
        [soundplayer setDefaultWithVolume:-1.0 rate:-1.0 pitchMultiplier:-1.0];
    }
    return soundplayer;
}



//播放声音

-(void)play:(NSString *)string
{
    if(string && string.length > 0){
        AVSpeechSynthesizer *player  = [[AVSpeechSynthesizer alloc]init];
        player.delegate = self;
        self.player = player;
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:string];//设置语音内容
        utterance.voice  = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
        utterance.rate   = self.rate;  //设置语速
        utterance.volume = self.volume;  //设置音量（0.0~1.0）默认为1.0
        utterance.pitchMultiplier = self.pitchMultiplier;  //设置语调 (0.5-2.0)
        utterance.postUtteranceDelay = 0; //目的是让语音合成器播放下一语句前有短暂的暂停
        [player speakUtterance:utterance];
    }
}
- (void)stopSpeaking{
    [self.player stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}
- (void)pauseSpeaking{
    [self.player pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}
- (void)continueSpeaking{
    [self.player continueSpeaking];
}
//初始化配置

/**
 *  设置播放的声音参数 如果选择默认请传入 -1.0
 *
 *  @param aVolume          音量（0.0~1.0）默认为1.0
 *  @param aRate            语速（0.0~1.0）
 *  @param aPitchMultiplier 语调 (0.5-2.0)
 */

-(void)setDefaultWithVolume:(float)aVolume rate:(CGFloat)aRate pitchMultiplier:(CGFloat)aPitchMultiplier
{
    self.rate   = aRate;
    self.volume = aVolume;
    self.pitchMultiplier = aPitchMultiplier;
    
    if (aRate == -1.0) {
        self.rate = 1;
    }
    
    if (aVolume == -1.0) {
        self.volume = 0.5;
    }
    
    if (aPitchMultiplier == -1.0) {
        self.pitchMultiplier = 1;
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"朗读开始");
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:didStartSpeechUtterance:)]) {
        [self.delegate speechSynthesizer:synthesizer didStartSpeechUtterance:utterance];
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"朗读暂停");
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:didPauseSpeechUtterance:)]) {
        [self.delegate speechSynthesizer:synthesizer didPauseSpeechUtterance:utterance];
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"朗读继续");
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:didContinueSpeechUtterance:)]) {
        [self.delegate speechSynthesizer:synthesizer didContinueSpeechUtterance:utterance];
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
     NSLog(@"朗读结束");
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:didFinishSpeechUtterance:)]) {
        [self.delegate speechSynthesizer:synthesizer didFinishSpeechUtterance:utterance];
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:willSpeakRangeOfSpeechString:utterance:)]) {
        [self.delegate speechSynthesizer:synthesizer willSpeakRangeOfSpeechString:characterRange utterance:utterance];
    }
}
@end
