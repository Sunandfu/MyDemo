//
//  SFPlayModel.m
//  deomo
//
//  Created by 张冬 on 2017/12/25.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "SFPlayModel.h"
#import "NSString+SFAES.h"
#import "SFResourceLoader.h"
#import "SFAdConst.h"

@interface SFPlayModel()<SFLoaderDelegate>
@property(nonatomic , strong)AVPlayerLayer *playLayer;
@property(nonatomic , strong)AVPlayer *avLayer;
@property(nonatomic , assign)AVPlayStatus playStatus;
@property(nonatomic , copy)NSString *currentPlayStr;
@property (nonatomic, strong) SFResourceLoader * resourceLoader;
/// 视频总的时间
@property(nonatomic , assign)NSTimeInterval totoalTime;
/// 视频当前的播放时间
@property(nonatomic , assign)NSTimeInterval currentTime;
@property (nonatomic, strong) id timeObserve;
@property (nonatomic, strong) AVPlayerItem * currentItem;

@end

@implementation SFPlayModel
+ (instancetype)sharePlayer {
    static SFPlayModel *sharePlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePlayer = [[SFPlayModel alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver: sharePlayer selector: @selector(playFinishFication:) name: AVPlayerItemDidPlayToEndTimeNotification object: nil];
    });
    return sharePlayer;
}

-(void)dealloc {
    SFLog(@"dealloc: SFPlayModel");
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification object: nil];
}
# pragma mark - set and get
-(AVPlayerLayer *)playLayer {
    if (!_playLayer) {
        _playLayer = [[AVPlayerLayer alloc] init];
        _playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playLayer;
}
-(NSTimeInterval)currentTime {
    return CMTimeGetSeconds(self.avLayer.currentTime);
}

#pragma mark -logic
/// 监听回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass: [AVPlayerItem class]]) {
        AVPlayerItem *playitem = (AVPlayerItem *)object;
        if ([keyPath isEqualToString: @"loadedTimeRanges"]){
//            SFLog(@"%@", playitem.loadedTimeRanges);
            NSArray *array = playitem.loadedTimeRanges;
            //本次缓存的时间
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
            NSTimeInterval totalBufferTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓存的总长度
            CGFloat progress = totalBufferTime / CMTimeGetSeconds(playitem.duration);
//            SFLog(@"progress = %f", progress);
            if (self.playCacheFinishBlock) {
                self.playCacheFinishBlock(progress);
            }
        }else if ([keyPath isEqualToString: @"status"]) {
            if (playitem.status == AVPlayerItemStatusReadyToPlay){
                 self.totoalTime = CMTimeGetSeconds(self.avLayer.currentItem.duration);
                if (self.getVidetTotalTimeBlock) {
                    self.getVidetTotalTimeBlock(self.totoalTime);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName: ReadyToPlay_Notification object:nil];
            }else if (playitem.status == AVPlayerItemStatusFailed) {
                [[NSNotificationCenter defaultCenter] postNotificationName: PlayFailed_Notification object:nil];
            }else if (playitem.status == AVPlayerItemStatusUnknown) {
                [[NSNotificationCenter defaultCenter] postNotificationName: PlayFailed_Notification object:nil];
            }
        }
    }else if ([object isKindOfClass: [AVPlayer class]]) {
        AVPlayer *play =(AVPlayer *)object;
        if (@available(iOS 10.0, *)) {
            if (play.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
//                SFLog(@"播放中");
                self.playStatus = AVPlayPlayingStatus;
            }else if (play.timeControlStatus == AVPlayerTimeControlStatusPaused) {
                NSTimeInterval current = CMTimeGetSeconds(self.avLayer.currentTime);
                if (current == self.totoalTime) {
                    self.playStatus = AVPlayFinishStatus;
                }else{
//                    SFLog(@"暂停了");
                    self.playStatus = AVPlayPauseStatus;
                }
            }else if (play.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
//                SFLog(@"缓冲");
                self.playStatus = AVPlayWaitStatus;
            }
        } else {
            // Fallback on earlier versions
        }
        if (self.playStatusChange) {
            self.playStatusChange(self.playStatus);
        }
    }
}
/// 设置播放url(只有设置了播放链接才初始化播放的layer)
-(void)startPlay:(NSString *)urlStr {
    // 移除之前的播放资源
    [self freePlayer];
    // 设置新的播放资源
    AVPlayerItem *playItem;
    if ([self isCacheVedioPath:urlStr]) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: [urlStr sf_MD5EncryptString]];
        NSURL *url = [NSURL fileURLWithPath: [NSString stringWithFormat:@"%@.m4a",path]];
        playItem = [AVPlayerItem playerItemWithURL:url];
        SFLog(@"视频%@" , [NSString stringWithFormat:@"%@.m4a",path]);
    }else{
        //有缓存播放缓存文件
        NSString * cacheFilePath = [SFFileHandle cacheFileExistsWithURL:[NSURL URLWithString:urlStr]];
        if (cacheFilePath) {
            NSURL *url = [NSURL fileURLWithPath:cacheFilePath];
            playItem = [AVPlayerItem playerItemWithURL:url];
            SFLog(@"有缓存，播放缓存文件");
        }else {
            //没有缓存播放网络文件
            self.resourceLoader = [[SFResourceLoader alloc]init];
            self.resourceLoader.delegate = self;
            
            NSURL *url = [NSURL URLWithString: urlStr];
            SFLog(@"无缓存，播放网络文件");
            AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[url customSchemeURL] options:nil];
            [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
            playItem = [AVPlayerItem playerItemWithAsset:asset];
        }
    }
    self.currentItem = playItem;
    self.avLayer = [AVPlayer playerWithPlayerItem:playItem];
    [self.avLayer addObserver: self  forKeyPath: @"timeControlStatus" options: NSKeyValueObservingOptionNew context:nil];
    [self.playLayer setPlayer: self.avLayer];
    // 添加监听
    [self addObservsForPlayItem: playItem];
    // 从当前的item开始播放
//    [self reStartPlay];
    // 标记当前播放的链接
    self.currentPlayStr = urlStr;
    
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.avLayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat current = CMTimeGetSeconds(time);
        CGFloat total = CMTimeGetSeconds(playItem.duration);
        SFLog(@"%f===%f",total,current / total);
        CGFloat progress = current / total;
        if (weakSelf.playBlock) {
            weakSelf.playBlock(progress);
        }
    }];
}
/// 判断是否为本地视频
-(BOOL)isCacheVedioPath: (NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: [path sf_MD5EncryptString]];
    NSString *Path = [NSString stringWithFormat:@"%@.m4a", cachePath];
    return [fm fileExistsAtPath: Path];
}
/// 开始播放
-(void)reStartPlay {
    [self.avLayer play];
}
/// 暂停播放
-(void)pausePlay {
    [self.avLayer pause];
}
/// 释放当前的播放器
-(void)freePlayer {
    if (_avLayer) {
        if (_avLayer.currentItem) {
            [self removeObsersForPlayItem: _avLayer.currentItem];
            [_avLayer replaceCurrentItemWithPlayerItem: nil];
        }
        [self pausePlay];
        [_avLayer removeObserver: self forKeyPath: @"timeControlStatus"];
        _avLayer = nil;
    }
    self.playStatus = AVPlayNoStartStatus;
}
/// 完成播放的通知回调
-(void)playFinishFication: (NSNotification *)fication {
//    SFLog(@"播放完成了");
    self.playStatus = AVPlayFinishStatus;
    if (self.playFinishBlock) {
        self.playFinishBlock(true, self.currentPlayStr);
    }
}
/// 设置开始播放的播放
-(void)seekPlayTime:(NSTimeInterval)time {
    CMTime seekTime = CMTimeMake(time, 1);
    [self.avLayer seekToTime:seekTime];
    [self reStartPlay];
}
/// 添加AVPlayerItem的播放状态监听
-(void)addObservsForPlayItem: (AVPlayerItem *)item {
    [item addObserver: self forKeyPath: @"status" options: NSKeyValueObservingOptionNew context: nil];
    [item addObserver: self forKeyPath: @"loadedTimeRanges" options:NSKeyValueObservingOptionNew context: nil];
}
/// 移除AVPlayerItem的播放状态监听
-(void)removeObsersForPlayItem: (AVPlayerItem *)item {
    [item removeObserver: self forKeyPath: @"status"];
    [item removeObserver: self forKeyPath: @"loadedTimeRanges"];
    if (self.timeObserve) {
        [self.avLayer removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
}

- (void)loader:(SFResourceLoader *)loader cacheProgress:(CGFloat)progress {
//    SFLog(@"缓存进度%f",progress);
}
- (void)loader:(SFResourceLoader *)loader failLoadingWithError:(NSError *)error{
//    SFLog(@"缓存错误%@",error);
}

@end









