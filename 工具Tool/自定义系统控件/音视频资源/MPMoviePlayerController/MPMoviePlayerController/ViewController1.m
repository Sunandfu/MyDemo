////
////  ViewController.m
////  MPMoviePlayerController
////
////  Created by Kenshin Cui on 14/03/30.
////  Copyright (c) 2014年 cmjstudio. All rights reserved.
////  
//
//#import "ViewController.h"
//#import <MediaPlayer/MediaPlayer.h>
//
//@interface ViewController ()
//
//@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
//
//@end
//
//@implementation ViewController
//
//#pragma mark - 控制器视图方法
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    //播放
//    [self.moviePlayer play];
//    
//    //添加通知
//    [self addNotification];
//    
//}
//
//-(void)dealloc{
//    //移除所有通知监控
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//
//#pragma mark - 私有方法
///**
// *  取得本地文件路径
// *
// *  @return 文件路径
// */
//-(NSURL *)getFileUrl{
//    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"The New Look of OS X Yosemite.mp4" ofType:nil];
//    NSURL *url=[NSURL fileURLWithPath:urlStr];
//    return url;
//}
//
///**
// *  取得网络文件路径
// *
// *  @return 文件路径
// */
//-(NSURL *)getNetworkUrl{
//    NSString *urlStr=@"http://192.168.1.161/The New Look of OS X Yosemite.mp4";
//    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url=[NSURL URLWithString:urlStr];
//    return url;
//}
//
///**
// *  创建媒体播放控制器
// *
// *  @return 媒体播放控制器
// */
//-(MPMoviePlayerController *)moviePlayer{
//    if (!_moviePlayer) {
//        NSURL *url=[self getNetworkUrl];
//        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
//        _moviePlayer.view.frame=self.view.bounds;
//        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        [self.view addSubview:_moviePlayer.view];
//    }
//    return _moviePlayer;
//}
//
///**
// *  添加通知监控媒体播放控制器状态
// */
//-(void)addNotification{
//    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
//    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
//    
//}
//
///**
// *  播放状态改变，注意播放完成时的状态是暂停
// *
// *  @param notification 通知对象
// */
//-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
//    switch (self.moviePlayer.playbackState) {
//        case MPMoviePlaybackStatePlaying:
//            NSLog(@"正在播放...");
//            break;
//        case MPMoviePlaybackStatePaused:
//            NSLog(@"暂停播放.");
//            break;
//        case MPMoviePlaybackStateStopped:
//            NSLog(@"停止播放.");
//            break;
//        default:
//            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
//            break;
//    }
//}
//
///**
// *  播放完成
// *
// *  @param notification 通知对象
// */
//-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
//    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
//}
//
//
//@end
