//
//  ViewController.m
//  B02_长MP3播放
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property(nonatomic,strong)AVAudioPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //获取mp3路径
    NSURL *mp3Url = [[NSBundle mainBundle] URLForResource:@"呼吸训练背景音乐-夜的钢琴曲.mp3" withExtension:nil];
    
    //播放音乐
    NSError *error = nil;
    // 1.创建一个音乐播放器
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3Url error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    // 2.准备播放
    [player prepareToPlay];
    
    // 打开可以改变速度的开头
    player.enableRate = YES;
    
    // 播放次数
    player.numberOfLoops = 0;//0代表播放一次 1代表播放2次
    
    
    player.delegate = self;
    
    self.player = player;
    
    //设置timeSlider的最大值
    self.timeSlider.maximumValue = self.player.duration;
    
    //监听音乐的中断
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:session];
    

}


/**
 *  处理中断
 */
-(void)handleInterruption:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo);
//    2015-02-28 15:54:47.635 B02_长MP3播放[710:53635] {
//        AVAudioSessionInterruptionTypeKey = 1;
//    }
//    2015-02-28 15:54:54.545 B02_长MP3播放[710:53635] {
//        AVAudioSessionInterruptionOptionKey = 1;
//        AVAudioSessionInterruptionTypeKey = 0;
//    }
    
//    AVAudioSessionInterruptionTypeKey = 1 //开始中断
//    AVAudioSessionInterruptionTypeKey = 0 //结束中断


}
- (IBAction)stopBtnClick:(id)sender {
    
    [self.player stop];
    
    //自己指定播放的时候到0的位置
    self.player.currentTime = 0;
}


- (IBAction)playBtnClick:(id)sender {
    
    
    // 3.播放
    [self.player play];
}

- (IBAction)pauseBtnClick:(id)sender {
    
    [self.player pause];
}



/**
 *  播放时间变化
 *
 */
- (IBAction)timeChange:(UISlider *)sender {
    
    NSLog(@"时间变化:%f",sender.value);
    
    self.player.currentTime = sender.value;
    
}

/**
 *  播放速度变化
 *
 */
- (IBAction)rateChange:(UISlider *)sender {
    
    self.player.rate = sender.value;
}

/*
 *播放音量的改变
*/
- (IBAction)volumnChange:(UISlider *)sender {
    
    self.player.volume = sender.value;
}


#pragma mark - AVAuidoPalyer的代理

#pragma mark 音乐播放完成扣调用
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"%s",__func__);
}


/**
 *  下面的方法,在ios8已经过期
 *
 */
//#pragma mark 中断(电话进来)
//-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
//    NSLog(@"%s",__func__);
//    //暂停音乐
//    [self.player pause];
//}
//
//#pragma mark 停止中断(电话挂了)
////13533123059
//-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
//    NSLog(@"%s",__func__);
//    //恢复播放
//    [self.player play];
//}

@end
