//
//  SFSoundPlayer.m
//
//  Created by 小富 on 16/7/5.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "SFSoundPlayer.h"
#import "SFConstant.h"

static SFSoundPlayer *soundplayer = nil;
@interface SFSoundPlayer ()

@property (nonatomic,strong) AVSpeechSynthesizer *player;

@end

@implementation SFSoundPlayer

+ (instancetype)SharedSoundPlayer{
    static id shareSpeechSynthesis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSpeechSynthesis = [[self alloc] init];
        [soundplayer setDefaultWithVolume:1.0 rate:0.5 pitchMultiplier:1.0];
    });
    return shareSpeechSynthesis;
}

- (AVSpeechSynthesizer *)player{
    if (_player == nil){
        _player = [[AVSpeechSynthesizer alloc]init];
        _player.delegate = self;
    }
    return _player;
}

//播放声音

-(void)play:(NSString *)string
{
    if(string && string.length > 0){
        self.paused = NO;
        NSString *voiceName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyVoiceName];
        NSUInteger idx = [AVSpeechSynthesisVoice.speechVoices indexOfObjectPassingTest:^BOOL(AVSpeechSynthesisVoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.identifier isEqualToString:voiceName];
        }];
        NSLog(@"voiceName = %@***%ld===%ld",voiceName,AVSpeechSynthesisVoice.speechVoices.count,idx);
        AVSpeechSynthesisVoice *voice;
        if (voiceName && AVSpeechSynthesisVoice.speechVoices.count>idx) {
            voice = AVSpeechSynthesisVoice.speechVoices[idx];
        } else {
            voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
        }
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:string];//设置语音内容
        //设置发音，这是中文普通话
        utterance.voice  = voice;
        utterance.rate   = self.rate;  //设置语速 0.0~1.0）默认为0.5
        utterance.volume = self.volume;  //设置音量（0.0~1.0）默认为1.0
        utterance.pitchMultiplier = self.pitchMultiplier;  //设置语调 (0.5-2.0)
        utterance.preUtteranceDelay = 0;  //读一段前的停顿时间
        utterance.postUtteranceDelay = 1; //读完一段后的停顿时间 目的是让语音合成器播放下一语句前有短暂的暂停
        [self.player speakUtterance:utterance];
    }
}
- (void)stopSpeaking{
    [self.player stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}
- (void)pauseSpeaking{
    if (self.player.isPaused == YES) {
        [self.player continueSpeaking];
        self.paused = NO;
    }else{
        [self.player pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        self.paused = YES;
    }
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
    self.volume = aVolume;
    self.rate   = aRate;
    self.pitchMultiplier = aPitchMultiplier;
    
    
    if (aVolume < 0.0 || aVolume > 1.0) {
        self.volume = 0.5;
    }
    if (aRate < 0.0 || aRate > 1.0) {
        self.rate = 1;
    }
    if (aPitchMultiplier < 0.5 || aPitchMultiplier > 2.0) {
        self.pitchMultiplier = 1;
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"朗读开始");
    self.play = YES;
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:didStartSpeechUtterance:)]) {
        [self.delegate speechSynthesizer:synthesizer didStartSpeechUtterance:utterance];
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"朗读暂停");
    self.paused = YES;
    self.play = NO;
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:didPauseSpeechUtterance:)]) {
        [self.delegate speechSynthesizer:synthesizer didPauseSpeechUtterance:utterance];
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"朗读继续");
    self.paused = NO;
    self.play = YES;
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:didContinueSpeechUtterance:)]) {
        [self.delegate speechSynthesizer:synthesizer didContinueSpeechUtterance:utterance];
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"朗读结束");
    self.paused = NO;
    self.play = NO;
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:didFinishSpeechUtterance:)]) {
        [self.delegate speechSynthesizer:synthesizer didFinishSpeechUtterance:utterance];
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    self.play = YES;
    if ([self.delegate respondsToSelector:@selector(speechSynthesizer:willSpeakRangeOfSpeechString:utterance:)]) {
        [self.delegate speechSynthesizer:synthesizer willSpeakRangeOfSpeechString:characterRange utterance:utterance];
    }
}

@end
