
//
//  THPlayer.m
//  THPlayer
//
//  Created by inveno on 16/3/23.
//  Copyright © 2016年 inveno. All rights reserved.
//AVAsset：主要用于获取多媒体信息，是一个抽象类，不能直接使用。
//AVURLAsset：AVAsset的子类，可以根据一个URL路径创建一个包含媒体信息的AVURLAsset对象。
//AVPlayerItem：一个媒体资源管理对象，管理者视频的一些基本信息和状态，一个AVPlayerItem对应着一个视频资源。
//

#import "HTPlayer.h"
#import "UIViewExt.h"
#import "Color+Hex.h"

#define kBottomViewHeight 40.0f


static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface HTPlayer()

//播放器
@property(nonatomic,retain)AVPlayer *player;
//playerLayer,可以修改frame
@property(nonatomic,retain)AVPlayerLayer *playerLayer;

//底部工具栏
@property(nonatomic,retain)UIView *bottomView;
@property(nonatomic, retain)UIView *titleView;
//背景
@property(nonatomic,strong)UIView *backView;

//播放进度条
@property(nonatomic,retain)UISlider *progressSlider;

//显示播放时间的UILabel
@property(nonatomic,retain)UILabel *rightTimeLabel;
//显示播放时间的UILabel
@property(nonatomic,retain)UILabel *leftTimeLabel;

//  控制全屏的按钮
@property(nonatomic,retain)UIButton *fullScreenBtn;
//播放暂停按钮
@property(nonatomic,retain)UIButton *playOrPauseBtn;
//关闭按钮
@property(nonatomic,retain)UIButton *closeBtn;
/* playItem */
@property(nonatomic, retain) AVPlayerItem *currentItem;
@property(nonatomic, retain)NSDateFormatter *dateFormatter;
@property(strong, nonatomic)NSTimer *handleBackTime;
@property(assign, nonatomic)BOOL isTouchDownProgress;

@end

@implementation HTPlayer

NSString *const kHTPlayerFinishedPlayNotificationKey  = @"com.hotoday.kHTPlayerFinishedPlayNotificationKey";
NSString *const kHTPlayerCloseVideoNotificationKey    = @"com.hotoday.kHTPlayerCloseVideoNotificationKey";
NSString *const kHTPlayerCloseDetailVideoNotificationKey    = @"com.hotoday.kHTPlayerCloseDetailVideoNotificationKey";
NSString *const kHTPlayerFullScreenBtnNotificationKey = @"com.hotoday.kHTPlayerFullScreenBtnNotificationKey";
NSString *const kHTPlayerPopDetailNotificationKey = @"com.hotoday.kHTPlayerPopDetailNotificationKey";

//根据url 获取播放信息
-(AVPlayerItem *)getPlayItemWithURLString:(NSString *)urlString{
    if ([urlString containsString:@"http"]) {
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }else{
        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:urlString] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}

//   截取指定时间的视频缩略图
-(void)thumbnailImageRequest:(CGFloat )timeBySecond{
    //创建URL
    NSURL *url=[NSURL URLWithString:[_videoURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    //CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
//        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    CGImageRelease(cgImage);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 单击 显示或者隐藏工具栏
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        // 双击暂停或者播放
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        // 双击手势确定监测失败才会触发单击手势的相应操作
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame videoURLStr:(NSString *)videoURLStr{
    self = [self initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        self.videoURLStr = videoURLStr;
        self.screenType = UIHTPlayerSizeRecoveryScreenType;
    }
    
    return self;
}

- (void)addObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    //       监听播放状态的变化
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:PlayViewStatusObservationContext];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
//    AVPlayerItem *playerItem=object;
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            
            //            设置进度条最大value= 视频总时长
            if (CMTimeGetSeconds(self.player.currentItem.duration)) {
                self.progressSlider.maximumValue = CMTimeGetSeconds(self.player.currentItem.duration);
            }
            [self initTimer];
            if (self.status)self.status(UIHTPlayerStatusReadyToPlayTyep);
            
//            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
//        NSArray *array=playerItem.loadedTimeRanges;
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
//        float startSeconds = CMTimeGetSeconds(timeRange.start);
//        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
////        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"共缓冲：%.2f",totalBuffer);
        
        if (self.alpha == 0.00) {
             if (self.status)self.status(UIHTPlayeStatusrLoadedTimeRangesType);
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 1.0;
            }];
        }
    }
}

#pragma  maik - 定时器 视频进度
-(void)initTimer{
    
    __weak typeof(self) weakSelf = self;
    double interval = .1f;
    CMTime playerDuration = [self playerItemDuration];
    //    if (CMTIME_IS_INVALID(playerDuration))
    //    {
    //        return;
    //    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([self.progressSlider bounds]);
        interval = 0.5f * duration / width;
    }
    //    定时循环执行。
    [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)  queue:NULL
                                             usingBlock:^(CMTime time){
                                                 [weakSelf syncScrubber];
                                             }];
}

- (void)syncScrubber{
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)){
        self.progressSlider.minimumValue = 0.0; //设置进度为0
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)){
        float minValue = [self.progressSlider minimumValue];
        float maxValue = [self.progressSlider maximumValue];
        double time = CMTimeGetSeconds([self.player currentTime]);
        
        _leftTimeLabel.text = [self convertTime:time];
        _rightTimeLabel.text =  [self convertTime:duration];
        
        float value = (maxValue - minValue) * time / duration + minValue;
        if (!_isTouchDownProgress) {
            [self.progressSlider setValue:value];
        }
        
    }
}

//获取播放时长。
- (CMTime)playerItemDuration{
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}
//转换时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [[self dateFormatter] stringFromDate:d];
    return newTime;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

#pragma mark - fullScreenAction 全屏通知
-(void)fullScreenAction:(UIButton *)sender{
    
    if (self.backView.alpha == 0.0) return;
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kHTPlayerFullScreenBtnNotificationKey object:sender];
}

//关闭播放视频通知
-(void)colseTheVideo:(UIButton *)sender{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHTPlayerCloseVideoNotificationKey object:sender];
}

//关闭详情视频
- (void)colseDetailVideo:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHTPlayerPopDetailNotificationKey object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHTPlayerCloseDetailVideoNotificationKey object:sender];
}

//获取视频播放的时间
- (double)duration{
    AVPlayerItem *playerItem = self.player.currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return CMTimeGetSeconds([[playerItem asset] duration]);
    }
    else{
        return 0.f;
    }
}

- (double)currentTime{
    return CMTimeGetSeconds([[self player] currentTime]);
}

- (void)setCurrentTime:(double)time{
    [[self player] seekToTime:CMTimeMakeWithSeconds(time, 1)];
}

#pragma mark - PlayOrPause
- (void)PlayOrPause:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (self.player.rate != 1.f) {
        if ([self currentTime] == [self duration])
            [self setCurrentTime:0.f];
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)play
{
    [self PlayOrPause:_playOrPauseBtn];
}

#pragma mark - 单击手势方法
- (void)handleSingleTap{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        if (self.backView.alpha == 0.0) {
            self.backView.alpha = 1.0;
        }else{
            self.backView.alpha = 0.0;
        }
        
    } completion:^(BOOL finished) {
        //            显示之后，3秒钟隐藏
        if (self.backView.alpha == 1.0) {
            [self removeHandleBackTime];
            weakSelf.handleBackTime = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(handleSingleTap) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:weakSelf.handleBackTime forMode:NSDefaultRunLoopMode];
        }else{
            [weakSelf.handleBackTime invalidate];
            weakSelf.handleBackTime = nil;
        }
    }];
}
- (void)hiddenSingleTap
{
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.alpha = 0.0;
    }];
}

- (void)removeHandleBackTime {
    if (self.handleBackTime) {
        [self.handleBackTime invalidate];
        self.handleBackTime = nil;
    }
}

#pragma mark - 双击手势方法
- (void)handleDoubleTap{
    [self PlayOrPause:_playOrPauseBtn];
}

- (void)setPlayTitle:(NSString *)str
{
    UILabel *label = [_titleView viewWithTag:100];
    if (label) label.text = str;
}

#pragma mark - 设置播放的视频
- (void)setVideoURLStr:(NSString *)videoURLStr
{
    self.alpha = 0;
    _videoURLStr = videoURLStr;
    
    if (self.currentItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [self removeObserverFromPlayerItem:self.currentItem];
    }
    self.currentItem = [self getPlayItemWithURLString:videoURLStr];
    
    [self addObserverFromPlayerItem:self.currentItem];
    //    切换视频
    [self.player replaceCurrentItemWithPlayerItem:self.currentItem];

    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
    
    if (self.player == nil) {
        self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.layer.bounds;
        if ([_playerLayer superlayer] == nil)[self.layer addSublayer:_playerLayer];
        if ([self.backView superview] == nil)[self addSubview:self.backView];
    }
    
    self.playOrPauseBtn.selected = NO;
    if (self.player.rate != 1.f) {
        if ([self currentTime] == self.duration) [self setCurrentTime:0.f];
        [self.player play];
    }
    
    if (self.status)self.status(UIHTPlayerStatusLoadingType);
}
- (void)moviePlayDidEnd:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
        [weakSelf.progressSlider setValue:0.0 animated:YES];
        weakSelf.playOrPauseBtn.selected = YES;
        //播放完成后的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kHTPlayerFinishedPlayNotificationKey object:nil];
    }];
}
//#pragma mark - 播放进度
- (void)updateProgress:(UISlider *)slider{
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, 1)];
    [self hiddenSingleTap];
    _isTouchDownProgress = NO;
}
- (void)changeProgress:(UISlider *)slider{
    
    _isTouchDownProgress = YES;
}
- (void)TouchBeganProgress:(UISlider *)slider{
    [self removeHandleBackTime];
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    [self removeFromSuperview];
    self.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.playerLayer.frame =  CGRectMake(0,0, SCREEN_HEIGHT,SCREEN_WIDTH);
    [self changeFrame];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.fullScreenBtn.selected = YES;
    self.screenType = UIHTPlayerSizeFullScreenType;
//    if (self.playerAnimateFinish)self.playerAnimateFinish();
}

-(void)toDetailScreen:(UIView *)view
{
    [self removeFromSuperview];

    self.backView.alpha= 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = view.bounds;
        self.playerLayer.frame =  self.bounds;
        [self changeFrame];
        
    }completion:^(BOOL finished) {
        
        [view addSubview:self];
        [view bringSubviewToFront:self];
        
        [UIView animateWithDuration:0.7f animations:^{
            self.backView.alpha = 1;
        } completion:^(BOOL finished) {
            //            显示之后，3秒钟隐藏
            if (self.backView.alpha == 1.0) {
                [self removeHandleBackTime];
                self.handleBackTime = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(handleSingleTap) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:self.handleBackTime forMode:NSDefaultRunLoopMode];
            }
        }];
        
        self.screenType = UIHTPlayerSizeDetailScreenType;
        self.fullScreenBtn.selected = NO;
    }];
    
}

-(void)reductionWithInterfaceOrientation:(UIView *)view{
    
    if (self.screenType == UIHTPlayerSizeSmallScreenType) {
         [self smallToRight:^(BOOL finished) {
             [self reduction:view];
         }];
    }else [self reduction:view];
}

- (void)reduction:(UIView *)view
{
    [self removeFromSuperview];
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.backView.alpha= 0;
    float duration = self.screenType == UIHTPlayerSizeFullScreenType?0.5f:0.0f;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = view.bounds;
        self.playerLayer.frame =  self.bounds;
        [self changeFrame];
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7f animations:^{
            self.backView.alpha = 1;
        } completion:^(BOOL finished) {
            //            显示之后，3秒钟隐藏
            if (self.backView.alpha == 1.0) {
                [self removeHandleBackTime];
                self.handleBackTime = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(handleSingleTap) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:self.handleBackTime forMode:NSDefaultRunLoopMode];
            }
//            if (self.playerAnimateFinish)self.playerAnimateFinish();
        }];
        
        self.screenType = UIHTPlayerSizeRecoveryScreenType;
        self.fullScreenBtn.selected = NO;
    }];
}

-(void)toSmallScreen{
    //放widow上
    [self removeFromSuperview];
    
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - ((SCREEN_WIDTH/2)*0.65), SCREEN_WIDTH/2, (SCREEN_WIDTH/2)*0.65);
    self.playerLayer.frame =  self.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self changeFrame];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    self.screenType = UIHTPlayerSizeSmallScreenType;
    [UIView animateWithDuration:0.5f animations:^{
        self.left = SCREEN_WIDTH - self.width;
    } completion:^(BOOL finished) {
//        if (self.playerAnimateFinish)self.playerAnimateFinish();
    }];
}

- (void)smallToRight:(void (^ __nullable)(BOOL finished))completion
{
    [UIView animateWithDuration:0.3f animations:^{
        self.left = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

- (void)changeFrame{
    
    self.backView.frame = self.playerLayer.frame;
    _closeBtn.frame = CGRectMake(5, 5, 30, 30);
    UIImage *img = [UIImage imageNamed:@"pause"];
    self.playOrPauseBtn.frame = CGRectMake((_backView.width - img.size.width)/2, (_backView.height - img.size.height)/2, img.size.width, img.size.height);
    _bottomView.frame = CGRectMake(0, self.backView.height-kBottomViewHeight , self.backView.width, kBottomViewHeight);
    [_bottomView viewWithTag:10001].frame = _bottomView.bounds;
    self.fullScreenBtn.frame = CGRectMake(_bottomView.width-img.size.width - 10, (_bottomView.height-img.size.height)/2,img.size.width ,img.size.height);
    self.leftTimeLabel.frame = CGRectMake(0, 0, 60, self.bottomView.height);
    self.rightTimeLabel.frame = CGRectMake(_bottomView.width - self.fullScreenBtn.width-self.leftTimeLabel.width - 5,
                                           self.leftTimeLabel.top, self.leftTimeLabel.width, self.leftTimeLabel.height);
    float width = _bottomView.width - (self.leftTimeLabel.right) - (_bottomView.width - self.rightTimeLabel.left);
    self.progressSlider.frame = CGRectMake(self.leftTimeLabel.right, 0, width ,_bottomView.height);
    self.titleView.frame = CGRectMake(0, 0, self.backView.width, self.titleView.height);
    [self.titleView viewWithTag:100].frame = CGRectMake(15, 0, _backView.width - 30, _titleView.height);
    
    for (CALayer *layer in _titleView.layer.sublayers) {
        if ([layer isMemberOfClass:[CAGradientLayer class]]) {
            CAGradientLayer *gradientLayer = (CAGradientLayer *)layer;
                gradientLayer.bounds = _titleView.bounds;
                gradientLayer.frame = _titleView.bounds;
        }
    }
}

- (void)setScreenType:(UIHTPlayerSizeType)screenType{
    _screenType = screenType;
    if (screenType == UIHTPlayerSizeSmallScreenType || screenType == UIHTPlayerSizeDetailScreenType) {
        _closeBtn.hidden = NO;
        _titleView.hidden = YES;
        
        [_closeBtn removeTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn removeTarget:self action:@selector(colseDetailVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        if (screenType == UIHTPlayerSizeSmallScreenType) {
            [_closeBtn addTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_closeBtn addTarget:self action:@selector(colseDetailVideo:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        _titleView.hidden = NO;
        _closeBtn.hidden = YES;
    }
}

- (UIView *)titleView
{
    if (_titleView) return _titleView;
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, 33)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer.bounds = _titleView.bounds;
    gradientLayer.frame = _titleView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor],(id)[[UIColor clearColor] CGColor], nil];
    gradientLayer.startPoint = CGPointMake(0.0, -3.0);
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    [_titleView.layer insertSublayer:gradientLayer atIndex:0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _backView.width - 30, _titleView.height)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.tag = 100;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [_titleView addSubview:titleLabel];
    
    return _titleView;
}

//关闭当前视频按钮。
- (UIButton *)closeBtn{
    if (_closeBtn) return _closeBtn;
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.showsTouchWhenHighlighted = YES;
    [_closeBtn addTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateSelected];
    _closeBtn.layer.cornerRadius = 30/2;
    _closeBtn.frame = CGRectMake(5, 5, 30, 30);
    _closeBtn.hidden = YES;
    return _closeBtn;
}

- (UIView *)backView{
    if (_backView) return _backView;
    
    _backView = [[UIView alloc] initWithFrame:self.bounds];
    _backView.alpha = 0;
    
    //   开始或者暂停按钮
    UIImage *img = [UIImage imageNamed:@"pause"];
    _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseBtn.showsTouchWhenHighlighted = YES;
    [self.playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn setImage:img forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
    self.playOrPauseBtn.frame = CGRectMake((_backView.width - img.size.width)/2, (_backView.height - img.size.height)/2, img.size.width, img.size.height);
    [_backView addSubview:self.playOrPauseBtn];
    
    [_backView addSubview:self.bottomView];
    [_backView addSubview:self.closeBtn];
    [_backView addSubview:self.titleView];
    return _backView;
}

//底部工具栏
- (UIView *)bottomView{
    if (_bottomView) return _bottomView;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-kBottomViewHeight , self.width, kBottomViewHeight)];
    
    UIView *backView = [[UIView alloc] initWithFrame:_bottomView.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.tag = 10001;
    [_bottomView addSubview:backView];
    
    //    全屏按钮
    UIImage *img = [UIImage imageNamed:@"fullscreen"];
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullScreenBtn.showsTouchWhenHighlighted = YES;
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn setImage:img forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"nonfullscreen"] forState:UIControlStateSelected];
    self.fullScreenBtn.frame = CGRectMake(_bottomView.width-img.size.width - 10, (_bottomView.height-img.size.height)/2,img.size.width ,img.size.height);
    [self.bottomView addSubview:self.fullScreenBtn];
    
    //视频播放时间
    self.leftTimeLabel = [[UILabel alloc]init];
    self.leftTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.leftTimeLabel.textColor = [UIColor whiteColor];
    self.leftTimeLabel.backgroundColor = [UIColor clearColor];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:11];
    self.leftTimeLabel.adjustsFontSizeToFitWidth = YES;
    self.leftTimeLabel.frame = CGRectMake(0, 0, 60, self.bottomView.height);
    [self.bottomView addSubview:self.leftTimeLabel];
    
    self.rightTimeLabel = [[UILabel alloc]init];
    self.rightTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.rightTimeLabel.textColor = [UIColor whiteColor];
    self.rightTimeLabel.backgroundColor = [UIColor clearColor];
    self.rightTimeLabel.font = [UIFont systemFontOfSize:11];
    self.rightTimeLabel.adjustsFontSizeToFitWidth = YES;
    self.rightTimeLabel.frame = CGRectMake(_bottomView.width - self.fullScreenBtn.width-self.leftTimeLabel.width - 5,
                                           self.leftTimeLabel.top, self.leftTimeLabel.width, self.leftTimeLabel.height);
    [self.bottomView addSubview:self.rightTimeLabel];
    
    //播放进度条
    self.progressSlider = [[UISlider alloc]init];
    self.progressSlider.minimumValue = 0.0;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    self.progressSlider.minimumTrackTintColor = [UIColor redColor];
    self.progressSlider.value = 0.0;//指定初始值
    // slider开始滑动事件
    [self.progressSlider addTarget:self action:@selector(TouchBeganProgress:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.progressSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    float width = _bottomView.width - (self.leftTimeLabel.right) - (_bottomView.width - self.rightTimeLabel.left);
    self.progressSlider.frame = CGRectMake(self.leftTimeLabel.right, 0, width ,_bottomView.height);
    [self.bottomView addSubview:self.progressSlider];
    
    [self bringSubviewToFront:self.bottomView];
    
    return _bottomView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void)dealloc{
    [self releaseWMPlayer];
    _backView = nil;
    if(_handleBackTime) [_handleBackTime invalidate];
    _handleBackTime = nil;
}

-(void)releaseWMPlayer{
    [self.currentItem removeObserver:self forKeyPath:@"status"];
    [self.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player pause];
    [self removeFromSuperview];
    [self.playerLayer removeFromSuperlayer];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    self.currentItem = nil;
    self.playOrPauseBtn = nil;
    self.playerLayer = nil;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com