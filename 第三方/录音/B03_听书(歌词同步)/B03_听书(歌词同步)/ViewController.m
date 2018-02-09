//
//  ViewController.m
//  B03_听书(歌词同步)
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "CZWord.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>

@property(nonatomic,strong)NSArray *words;//所有的诗词

@property(nonatomic,strong)AVAudioPlayer *bgMusicPalyer;//背景音乐播放器
@property(nonatomic,strong)AVAudioPlayer *wordsPlayer;//诗词播放器

@property(nonatomic,strong)CADisplayLink *link;//定时器

@end

@implementation ViewController

-(NSArray *)words{
    if (!_words) {
        //加载plist的数据
        _words = [CZWord objectArrayWithFilename:@"一东.plist"];
        
    }
    
    return _words;
}

-(CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    
    return _link;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",self.words);
    
    //1.显示数据
    //2.播放两个音频文件 一个音频文件对应一个AVAudioPlayer
    NSURL *bgMusicURL = [[NSBundle mainBundle] URLForResource:@"Background.caf" withExtension:nil];
    self.bgMusicPalyer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgMusicURL error:nil];
    
    //设置播放次数
    self.bgMusicPalyer.numberOfLoops = 5;
    
    [self.bgMusicPalyer prepareToPlay];
    [self.bgMusicPalyer play];
    
    NSURL *wordURL =  [[NSBundle mainBundle] URLForResource:@"一东.mp3" withExtension:nil];
    self.wordsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:wordURL error:nil];
    self.wordsPlayer.delegate = self;
    //设置诗词的播放时间
    self.wordsPlayer.currentTime = 130;
    [self.wordsPlayer prepareToPlay];
    [self.wordsPlayer play];
    
    
    //同步诗词
    // 开启定时器
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}



#pragma mark tableview的数据源
#pragma mark 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.words.count;
}


#pragma mark cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    static NSString *ID = @"Word";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //设置数据
    cell.textLabel.text = [self.words[indexPath.row] text];
    
    
    return cell;
    
}


/**
 *  刷新诗词 读 的进度
 */
-(void)update{
    double  currentTime = self.wordsPlayer.currentTime;
    NSLog(@"当前播放的时间 %lf",currentTime);
    
    //倒序遍历诗词
    //self.words -> CZWord
    //总的"句数"
    NSInteger numberOfWord = self.words.count;

    //诗词最大的索引
    NSInteger maxIndex = numberOfWord - 1;
    for (NSInteger i = maxIndex; i >=0 ; i--) {
        //获取遍历的诗词
        CZWord *word = self.words[i];
        if (currentTime >= word.time) {
            NSLog(@"当前诗词的索引为 %ld",i);
            [self selectedCellWithIndex:i];
            break;
        }
        
    }
}


/**
 *  选中表格
 *
 */
-(void)selectedCellWithIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //选中
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}


#pragma mark AudioPlayer代理
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //当诗词播放完成后,背景音乐停止
    [self.bgMusicPalyer stop];
    
    //定时器也要移除
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
@end
