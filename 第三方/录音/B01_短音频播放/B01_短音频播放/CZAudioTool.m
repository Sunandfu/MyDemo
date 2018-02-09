//
//  CZAudioTool.m
//  B01_短音频播放
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZAudioTool.h"
#import <AudioToolbox/AudioToolbox.h>

static NSDictionary *soundDict;//存储所有音频文件的SystemSoundID
@implementation CZAudioTool

singleton_implementation(CZAudioTool)


+(void)initialize{
    //1.加载所有音频文件
    //1.1 遍历plane.bundle的所有音频文件
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //1.2获取plane.bundle的路径
    NSString *planePath = [[NSBundle mainBundle] pathForResource:@"plane.bundle" ofType:nil];
    
    NSError *error = nil;
    NSArray *contents = [manager contentsOfDirectoryAtPath:planePath error:&error];
    NSLog(@"%@",contents);
    
    //1.3 遍历里面的mp3文件,创建SystemSoundID
    NSMutableDictionary *soundDictM = [NSMutableDictionary dictionary];
    for (NSString *mp3Name in contents) {
        //音频文件的URL
        NSString *soundUrlStr = [planePath stringByAppendingPathComponent:mp3Name];
        NSURL *soundUrl = [NSURL fileURLWithPath:soundUrlStr];
        
        //音频ID,一个音频文件对应一个soundID
        SystemSoundID soundId;
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundUrl), &soundId);
        
        //1.4通过字典存储soundID @{"enemy1_down.mp3":11111,"enemy2_down.mp3",11112}
        soundDictM[mp3Name] = @(soundId);
        
    }
    
    NSLog(@"%@",soundDictM);
    soundDict = soundDictM;

}

//2.给一个方法播放音频文件
-(void)playMp3WithName:(NSString *)mp3Name{

    //通过键值获取soundId
    SystemSoundID soundId =  [soundDict[mp3Name] unsignedIntValue];
    
    //播放
    AudioServicesPlaySystemSound(soundId);
    
    //振动
    //AudioServicesPlayAlertSound(<#SystemSoundID inSystemSoundID#>)
}
@end
