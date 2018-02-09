//
//  XHSoundRecorder.h
//  XHSoundRecorder
//
//  Created by Apple on 16/6/7.
//  Copyright © 2016年 张轩赫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Type) {
    
    TrueMachine,
    Simulator,
};

@interface XHSoundRecorder : NSObject

+ (instancetype)sharedSoundRecorder;

//开始录音和继续录音 录完之后的回调 传出文件路径
- (void)startRecorder:(void (^)(NSString *filePath))FinishRecording;

//暂停录音
- (void)pauseRecorder;

//停止录音
- (void)stopRecorder;

//播放录音  传人需要播放的文件(如果传nil 直接播放录音文件)  播放完之后的回调
- (void)playsound:(NSString *)filePath withFinishPlaying:(void (^)())FinishPlaying;

//暂停播放录音
- (void)pausePlaysound;

//停止播放录音
- (void)stopPlaysound;

//删除录音
- (void)removeSoundRecorder;

//获取分贝数
- (CGFloat)decibels;

//转成mp3格式 传如要转换的文件(如果传nil 直接转换最后一个录音文件) 传出文件路径
- (void)recorderFileToMp3WithType:(Type)type filePath:(NSString *)filePath FilePath:(void (^)(NSString *newfilePath))newFilePath;

@end


