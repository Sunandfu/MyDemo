//
//  ViewController.m
//  CXPlayerTableviewcell
//
//  Created by artifeng on 16/1/5.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MediaCell.h"



@interface ViewController ()
/** 视频播放控制器*/
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
/** 加载动画*/
@property(nonatomic,strong) UIActivityIndicatorView *loadingAni;
@property(nonatomic,strong)NSNotificationCenter *notificationCenter;
@property(nonatomic,strong)UIImageView *backmovieplayer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if (self.moviePlayer.playbackState==MPMoviePlaybackStatePlaying||self.moviePlayer.playbackState==MPMoviePlaybackStatePaused) {
        [self.moviePlayer play];
    }
    else
    {
        [self show];
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
//    if ([self.moviePlayer isFullscreen])
//    {
//        [self.moviePlayer play];
//    }
//    else
//    {
//        [self.moviePlayer pause];
//        self.moviePlayer=nil;
//    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}
/**
 *  支持横竖屏显示
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(void)show
{
    self.myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
   // self.myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[MediaCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.myTableView];
    self.loadingAni=[[UIActivityIndicatorView alloc]init];
    self.loadingAni.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
   // NSURL *imageUrl=[NSURL URLWithString:[[self.allDataArray objectAtIndex:indexPath.row] backImage]];
   // [cell.btnimage sd_setImageWithURL:imageUrl];
    [cell.btnimage setImage:[UIImage imageNamed:@"1"]];
    cell.btn.tag=indexPath.row;
    [cell.btn addTarget:self action:@selector(doput:) forControlEvents:UIControlEventTouchUpInside];
    cell.Labeltitle.text=@"视频标题";
    cell.playcountLabel.text=@"播放次数：4123";
    if (cell.btnimage==nil)
    {
        [cell.myImageView removeFromSuperview];
    }
    cell.playtimeLabel.text=[NSString stringWithFormat:@"%02d:%02d",7,34];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280;
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.moviePlayer.playbackState==MPMoviePlaybackStatePlaying||self.moviePlayer.playbackState==MPMoviePlaybackStatePaused)
    {
        [self.backmovieplayer removeFromSuperview];
        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer=nil;
        
    }


}

-(void)doput:(UIButton *)btn
{
    
    if (self.moviePlayer.playbackState==MPMoviePlaybackStatePlaying||self.moviePlayer.playbackState==MPMoviePlaybackStatePaused)
    {
        [self.backmovieplayer removeFromSuperview];
        [self.moviePlayer.view removeFromSuperview];
    }
    NSString *urlStr= @"http://flv2.bn.netease.com/videolib3/1511/19/RiCBl0272/SD/RiCBl0272-mobile.mp4";//[[self.allDataArray objectAtIndex:btn.tag] mp4_url];
    NSString* UrlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:UrlStr];
    if (!_moviePlayer) {
        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    if ([self.moviePlayer isPreparedToPlay]) {
        [_moviePlayer setContentURL:url];
        [self.backmovieplayer removeFromSuperview];
    }
    
    self.moviePlayer.view.frame=CGRectMake(10,(btn.tag)*280+20,self.view.frame.size.width-20, 210);
    self.loadingAni.frame=CGRectMake(self.moviePlayer.view.bounds.size.width/2-18.5,self.moviePlayer.view.bounds.size.height/2-18.5, 37, 37);
    [self.myTableView addSubview:self.moviePlayer.view];
    self.backmovieplayer=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width-20, 210)];
    self.backmovieplayer.image=[UIImage imageNamed:@"night_sidebar_cellhighlighted_bg@2x"];
    [self.moviePlayer.view addSubview:self.backmovieplayer];
    [self.backmovieplayer addSubview:self.loadingAni];
    [self addNotification];
    [self.loadingAni startAnimating];
    [self.myTableView reloadData];
    
}




-(void)addNotification{
    
    self.notificationCenter=[NSNotificationCenter defaultCenter];
    
    
    [self.notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    
    if ([self.moviePlayer respondsToSelector:@selector(loadState)])
    {
        [self.moviePlayer prepareToPlay];
    }
    else
    {
        [self.moviePlayer play];
    }
    [self.notificationCenter addObserver:self selector:@selector(mediaPlayerPlayFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
}
/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */

-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    [self.loadingAni stopAnimating];
    [self.backmovieplayer removeFromSuperview];
    if ([self.moviePlayer loadState]!=MPMovieLoadStateUnknown)
    {
        
        switch (self.moviePlayer.playbackState) {
            case MPMoviePlaybackStatePlaying:
                
                //  NSLog(@"正在播放...");
                break;
            case MPMoviePlaybackStatePaused:
                // NSLog(@"暂停播放.");
                break;
            case MPMoviePlaybackStateStopped:
                // NSLog(@"停止播放.");
                break;
            default:
                // NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
                break;
        }
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlayFinished:(NSNotification *)notification
{
    //NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
