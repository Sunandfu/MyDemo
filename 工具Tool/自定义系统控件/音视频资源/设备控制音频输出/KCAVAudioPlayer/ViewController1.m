////
////  ViewController.m
////  KCAVAudioPlayer
////
////  Created by Kenshin Cui on 14/03/30.
////  Copyright (c) 2014年 cmjstudio. All rights reserved.
////
//
//#import "ViewController.h"
//#import <AVFoundation/AVFoundation.h>
//#define kMusicFile @"刘若英 - 原来你也在这里.mp3"
//#define kMusicSinger @"刘若英"
//#define kMusicTitle @"原来你也在这里"
//
//@interface ViewController ()<AVAudioPlayerDelegate>
//
//@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
//@property (weak, nonatomic) IBOutlet UILabel *controlPanel; //控制面板
//@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;//播放进度
//@property (weak, nonatomic) IBOutlet UILabel *musicSinger; //演唱者
//@property (weak, nonatomic) IBOutlet UIButton *playOrPause; //播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)
//
//@property (weak ,nonatomic) NSTimer *timer;//进度更新定时器
//
//@end
//
//@implementation ViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self setupUI];
//    
//}
//
///**
// *  初始化UI
// */
//-(void)setupUI{
//    self.title=kMusicTitle;
//    self.musicSinger.text=kMusicSinger;
//}
//
//-(NSTimer *)timer{
//    if (!_timer) {
//        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
//    }
//    return _timer;
//}
//
///**
// *  创建播放器
// *
// *  @return 音频播放器
// */
//-(AVAudioPlayer *)audioPlayer{
//    if (!_audioPlayer) {
//        NSString *urlStr=[[NSBundle mainBundle]pathForResource:kMusicFile ofType:nil];
//        NSURL *url=[NSURL fileURLWithPath:urlStr];
//        NSError *error=nil;
//        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
//        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
//        //设置播放器属性
//        _audioPlayer.numberOfLoops=0;//设置为0不循环
//        _audioPlayer.delegate=self;
//        [_audioPlayer prepareToPlay];//加载音频文件到缓存
//        if(error){
//            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
//            return nil;
//        }
//    }
//    return _audioPlayer;
//}
//
///**
// *  播放音频
// */
//-(void)play{
//    if (![self.audioPlayer isPlaying]) {
//        [self.audioPlayer play];
//        self.timer.fireDate=[NSDate distantPast];//恢复定时器
//    }
//}
//
///**
// *  暂停播放
// */
//-(void)pause{
//    if ([self.audioPlayer isPlaying]) {
//        [self.audioPlayer pause];
//        self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
//        
//    }
//}
//
///**
// *  点击播放/暂停按钮
// *
// *  @param sender 播放/暂停按钮
// */
//- (IBAction)playClick:(UIButton *)sender {
//    if(sender.tag){
//        sender.tag=0;
//        [sender setImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
//        [sender setImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateHighlighted];
//        [self pause];
//    }else{
//        sender.tag=1;
//        [sender setImage:[UIImage imageNamed:@"playing_btn_pause_n"] forState:UIControlStateNormal];
//        [sender setImage:[UIImage imageNamed:@"playing_btn_pause_h"] forState:UIControlStateHighlighted];
//        [self play];
//    }
//}
//
///**
// *  更新播放进度
// */
//-(void)updateProgress{
//    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
//    [self.playProgress setProgress:progress animated:true];
//}
//
//#pragma mark - 播放器代理方法
//-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    NSLog(@"音乐播放完成...");
//}
//
//@end
