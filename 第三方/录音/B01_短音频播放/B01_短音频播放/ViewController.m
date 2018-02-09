//
//  ViewController.m
//  B01_短音频播放
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CZAudioTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
//    [[CZAudioTool sharedCZAudioTool] playMp3WithName:@"enemy3_down.mp3"];
    [self test];
   
}

-(void)test{
    /*
     * iOS8里播放音频是有问题
     */
    
    //播放enemy1_down.mp3 音频文件
    
    //音频文件的URL
    NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:@"demo.mp3" withExtension:nil];
    
    //音频ID,一个音频文件对应一个soundID
    SystemSoundID soundId;
//    NSLog(@"%d",soundId);
    
    //加载了音频文件到内存
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundId);
    
    //播放音频
    AudioServicesPlaySystemSound(soundId);
    
    //抽取一个工具类,这个工具类一次加载所有的音频文件
}

@end
