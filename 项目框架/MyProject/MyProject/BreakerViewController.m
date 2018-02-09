//
//  BreakerViewController.m
//  MyProject
//
//  Created by 小富 on 16/4/22.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "BreakerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
@interface BreakerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ballImage;
@property (weak, nonatomic) IBOutlet UIImageView *paddleImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *blockImages;
/*标示游戏是否在进行*/
@property BOOL isPlaying;
/*小球的速度*/
@property CGPoint ballVeocity;
/*定时器*/
@property CADisplayLink *gameTimer;
/*滑板水平位移*/
@property CGFloat deltaX;
@property (nonatomic,strong)AVAudioPlayer*player;
-(BOOL)checkWithScreen;
-(BOOL)checkWithBlocks;
-(void)checkWithPaddle;
/*重置游戏*/
-(void)resetGameStatusWithMessage:(NSString*)message;
@end

@implementation BreakerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.ballImage.layer.masksToBounds = YES;
    self.ballImage.layer.cornerRadius = 17;
    self.paddleImage.layer.masksToBounds = YES;
    self.paddleImage.layer.cornerRadius = 17;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.ballImage.center = CGPointMake(self.view.center.x, self.view.height-100);
    self.paddleImage.center = CGPointMake(self.view.center.x, self.ballImage.frameBottom+self.paddleImage.height/2);
    if ([[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 6S Plus"] || [[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 6 Plus"]) {
        self.paddleImage.center = CGPointMake(self.view.center.x, self.ballImage.frameBottom+self.paddleImage.height/2-4);
    }
    _isPlaying = NO;
    [self sounds];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*如果游戏没有开始，则开始游戏*/
    if (!_isPlaying) {
        _isPlaying = YES;
        _ballVeocity = CGPointMake(0, -5);
        _gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step:)];
        /*将定时器添加到应用循环中*/
        [_gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    _deltaX = 0;
    [_player play];
}
-(void)step:(CADisplayLink*)sender
{
    if ([self checkWithScreen]) {
        [self resetGameStatusWithMessage:@"游戏结束"];
    }
    if ([self checkWithBlocks]) {
        [self resetGameStatusWithMessage:@"你真棒！"];
    }
    [self checkWithPaddle];
    _ballImage.center=CGPointMake(_ballImage.center.x+_ballVeocity.x, _ballImage.center.y+_ballVeocity.y);
}
-(BOOL)checkWithScreen{
    BOOL gameOver = NO;
    //左边
    if (_ballImage.frame.origin.x<=0) {
        _ballVeocity.x = fabs(_ballVeocity.x);
        /*下面一行为解决一bug,球速横向为0时可能会卡进屏幕中*/
        _ballImage.center = CGPointMake(_ballImage.frame.size.width/2, _ballImage.center.y);}
    //右边
    if (CGRectGetMaxX(_ballImage.frame)>=self.view.frame.size.width) {
        _ballVeocity.x = -1*(fabs(_ballVeocity.x));
        /*下面一行为解决一bug,球速横向为0时可能会卡进屏幕中*/
        _ballImage.center = CGPointMake(self.view.frame.size.width-_ballImage.frame.size.width/2, _ballImage.center.y);
    }
    //top
    if (_ballImage.frame.origin.y<=0) {
        _ballVeocity.y = fabs(_ballVeocity.y);
    }
    //botom
    if (_ballImage.frame.origin.y+_ballImage.frame.size.height>=self.view.frame.size.height) {
        gameOver = YES;
    }
    return gameOver;
}
//监测砖头碰撞
-(BOOL)checkWithBlocks
{
    for(UIImageView *block in _blockImages){
        /*如果碰撞，隐藏砖块*/
        if (CGRectIntersectsRect([block frame], [_ballImage frame])&&![block isHidden]) {
            [block setHidden:YES];
            _ballVeocity.y = fabs(_ballVeocity.y);
            break;
        }
    }
    //判断游戏胜利
    BOOL gameWin = YES;
    for(UIImageView *b in _blockImages) {
        if (![b isHidden]) {
            gameWin = NO;
            break;
        }
    }
    return gameWin;
}

//挡板的碰撞
-(void)checkWithPaddle
{
    if(CGRectIntersectsRect([_paddleImage frame], [_ballImage frame])) {
        _ballVeocity.y = -1*fabs(_ballVeocity.y);
        _ballVeocity.x = 0.5*_deltaX;
    }
}

-(void)resetGameStatusWithMessage:(NSString*)message
{
    CGFloat kuan = 0;
    CGFloat gao = 0;
    [_gameTimer invalidate];
    /*先让砖块全部消失不见*/
    for (UIImageView *b in _blockImages) {
        [b setHidden:NO];
        [b setAlpha:0];
        kuan = b.frame.size.width;
        gao = b.frame.size.height;
        b.frame = CGRectMake(b.center.x, b.center.y, 0, 0);
    }
    /*动画方式出现砖头*/
    [UIView animateWithDuration:2.0 animations:^{
        for(UIImageView *b in _blockImages){
            [b setAlpha:1];
            [b setFrame:CGRectMake(b.center.x-kuan/2, b.center.y-gao/2, kuan, gao)];
            
            _ballImage.center = CGPointMake(self.view.centerX,self.view.height-100);
        }
    } completion:^(BOOL finished) {
        _isPlaying = NO;
        _paddleImage.center = CGPointMake(self.view.centerX, _ballImage.frameBottom+self.paddleImage.height/2);
    }];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    [_player pause];
    if (_isPlaying) {
        UITouch *touch = [touches anyObject];
        /*计算水平方向移动距离*/
        _deltaX = [touch locationInView:self.view].x-[touch previousLocationInView:self.view].x;
        
        if (_paddleImage.center.x+_deltaX<_paddleImage.width/2) {
            _paddleImage.center = CGPointMake(_paddleImage.width/2, _paddleImage.center.y);
        } else if (_paddleImage.center.x+_deltaX>(self.view.right-_paddleImage.width/2)) {
            _paddleImage.center = CGPointMake((self.view.right-_paddleImage.width/2), _paddleImage.center.y);
        } else {
            _paddleImage.center = CGPointMake(_paddleImage.center.x+_deltaX, _paddleImage.center.y);
        }
    }
}
/*自定义方法*/
-(void)sounds
{
    NSString *path =[[NSBundle mainBundle]pathForResource:@"漂洋过海来看你" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player.volume = 0.8;
    self.player.numberOfLoops = 3;
    /*设置音乐跳过的时间*/
    self.player.currentTime = 0;
    
    [self.player play];
}

@end
