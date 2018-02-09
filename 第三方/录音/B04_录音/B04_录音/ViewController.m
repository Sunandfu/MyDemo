//
//  ViewController.m
//  B04_录音
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)AVAudioRecorder *recorder;//录音器
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property(nonatomic,strong)NSMutableArray *data;//音频数据[存文件路径]
@end

@implementation ViewController

-(NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 *  开始录音
 *
 */
- (IBAction)startRecord:(UIButton *)sender {
    NSLog(@"%s",__func__);
    
    //1.创建录音器
    
    //1.1URL 是录音文件保存的地址
    //音频文件保存在沙盒 document/20150228171912.caf
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //音频文件名
    NSString *audioName = [timeStr stringByAppendingString:@".caf"];
    
    //doc目录

    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //拼接音频URL
    NSString *fileURL = [doc stringByAppendingPathComponent:audioName];
    NSLog(@"%@",fileURL);
    
   //保存文件路径到数组
    [self.data addObject:fileURL];
    
    //setting 录音时的设置
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    //音频编码格式
    settings[AVFormatIDKey] = @(kAudioFormatAppleIMA4); //音频采样频率
    settings[AVSampleRateKey] = @(8000.0);
    //音频频道
    settings[AVNumberOfChannelsKey] = @(1);
    //音频线性音频的位深度
    settings[AVLinearPCMBitDepthKey] = @(8);
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:fileURL] settings:settings error:nil];
    
    //录音的准备
    [self.recorder prepareToRecord];
    
    //录音
    [self.recorder record];
    
}


/**
 *  结束录音
 *
 */
- (IBAction)endRecord:(UIButton *)sender {
    
    //录音的时间
    double duration = self.recorder.currentTime;
    NSLog(@"录音的时间%lf",self.recorder.currentTime);
    
    
     NSLog(@"%s",__func__);
    [self.recorder stop];
    
    //判断录音的时间否大于0.5
    if(duration <=0.5){
        NSLog(@"录音时间太短");
        //移除最后的录音文件
        [self.data removeLastObject];
    }else{
        //刷新表格
        [self.tableVIew reloadData];
    }
    
    
}

#pragma mark 表格数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return     self.data.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"Record";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //显示音频的文件名
    cell.textLabel.text = [self.data[indexPath.row] lastPathComponent];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //AVAudioPlayer
//    NSString *nameStr = [self.data[indexPath.row] lastPathComponent];
////    NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:nameStr withExtension:nil];
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    //拼接音频URL
//    NSString *soundUrl = [doc stringByAppendingPathComponent:nameStr];
//    //音频ID,一个音频文件对应一个soundID
//    SystemSoundID soundId = 0;
//    NSLog(@"%d",soundId);
//    
//    //加载了音频文件到内存
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundId);
//    
//    //播放音频
//    AudioServicesPlaySystemSound(soundId);
}


@end
