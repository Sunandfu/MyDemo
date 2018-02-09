//
//  ViewController.m
//  AmrWavConverter
//
//  Created by Jeans on 6/5/15.
//  Copyright (c) 2015 gzhu. All rights reserved.
//

#import "ViewController.h"
#import "VoiceConverter.h"
@import AVFoundation;
@import AudioToolbox;

@interface ViewController ()

//! 播放转换后wavBtn
@property (weak, nonatomic) IBOutlet UIButton *playConvertedBtn;
//! 录音btn
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
//! 播放原wavBtn
@property (weak, nonatomic) IBOutlet UIButton *playOriginalWavBtn;

//! amr转wav
@property (weak, nonatomic) IBOutlet UILabel *toWavLabel;
//! wav转amr
@property (weak, nonatomic) IBOutlet UILabel *toAmrLabel;
//! 原wav
@property (weak, nonatomic) IBOutlet UILabel *originalWavLabel;


@property (strong, nonatomic)   AVAudioRecorder  *recorder;
@property (strong, nonatomic)   AVAudioPlayer    *player;
@property (strong, nonatomic)   NSString         *recordFileName;
@property (strong, nonatomic)   NSString         *recordFilePath;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化播放器
    self.player = [[AVAudioPlayer alloc]init];
}

#pragma mark - 录音
- (IBAction)record:(UIButton *)sender {
    
    if (self.recorder.isRecording){//录音中
        //停止录音
        [self.recorder stop];
        [sender setTitle:@"录音" forState:UIControlStateNormal];
        
        self.playOriginalWavBtn.enabled = YES;
        //设置label信息
        self.originalWavLabel.text = [NSString stringWithFormat:@"原wav:\n%@",[self getVoiceFileInfoByPath:self.recordFilePath convertTime:0]];
        
        //开始转换格式
        
        NSDate *date = [NSDate date];
        NSString *amrPath = [ViewController GetPathByFileName:self.recordFileName ofType:@"amr"];
        
#warning wav转amr
        if ([VoiceConverter ConvertWavToAmr:self.recordFilePath amrSavePath:amrPath]){
            
            //设置label信息
            self.toAmrLabel.text = [NSString stringWithFormat:@"原wav转amr:\n%@",[self getVoiceFileInfoByPath:amrPath convertTime:[[NSDate date] timeIntervalSinceDate:date]]];
        
            date = [NSDate date];
            NSString *convertedPath = [ViewController GetPathByFileName:[self.recordFileName stringByAppendingString:@"_AmrToWav"] ofType:@"wav"];
            
#warning amr转wav
            if ([VoiceConverter ConvertAmrToWav:amrPath wavSavePath:convertedPath]){
                //设置label信息
                self.toWavLabel.text = [NSString stringWithFormat:@"amr转wav:\n%@",[self getVoiceFileInfoByPath:convertedPath convertTime:[[NSDate date] timeIntervalSinceDate:date]]];
                self.playConvertedBtn.enabled = YES;
            }else
                NSLog(@"amr转wav失败");
            
        }else
            NSLog(@"wav转amr失败");
    
    }else{
        //录音
        
        //根据当前时间生成文件名
        self.recordFileName = [ViewController GetCurrentTimeString];
        //获取路径
        self.recordFilePath = [ViewController GetPathByFileName:self.recordFileName ofType:@"wav"];
        
        //初始化录音
        self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:self.recordFilePath]
                                                   settings:[VoiceConverter GetAudioRecorderSettingDict]
                                                      error:nil];
        
        //准备录音
        if ([self.recorder prepareToRecord]){
            
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            
            //开始录音
            if ([self.recorder record]){
                [sender setTitle:@"停止" forState:UIControlStateNormal];
                self.playConvertedBtn.enabled = NO;
                self.playOriginalWavBtn.enabled = NO;
                
            }
        }
    }
}

#pragma mark - 播放原wav
- (IBAction)playOriginalWav:(UIButton *)sender {
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.player = [self.player initWithContentsOfURL:[NSURL URLWithString:self.recordFilePath] error:nil];
    [self.player play];
}

#pragma mark - 播放amr转换后wav
- (IBAction)playConverted:(id)sender {
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSString *convertedPath = [ViewController GetPathByFileName:[self.recordFileName stringByAppendingString:@"_AmrToWav"] ofType:@"wav"];
    self.player = [self.player initWithContentsOfURL:[NSURL URLWithString:convertedPath] error:nil];
    [self.player play];
}

#pragma mark - Others

#pragma mark - 生成当前时间字符串
+ (NSString*)GetCurrentTimeString{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

#pragma mark - 生成文件路径
+ (NSString*)GetPathByFileName:(NSString *)_fileName ofType:(NSString *)_type{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];;
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:_fileName]
                               stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",fileDirectory);
    return fileDirectory;
}

#pragma mark - 获取音频文件信息
- (NSString *)getVoiceFileInfoByPath:(NSString *)aFilePath convertTime:(NSTimeInterval)aConTime{
    
    NSInteger size = [self getFileSize:aFilePath]/1024;
    NSString *info = [NSString stringWithFormat:@"文件名:%@\n文件大小:%ldkb\n",aFilePath.lastPathComponent,(long)size];
    
    NSRange range = [aFilePath rangeOfString:@"wav"];
    if (range.length > 0) {
        AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:aFilePath] error:nil];
        info = [info stringByAppendingFormat:@"文件时长:%f\n",play.duration];
    }
    
    if (aConTime > 0)
        info = [info stringByAppendingFormat:@"转换时间:%f",aConTime];
    return info;
}

#pragma mark - 获取文件大小
- (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}


@end
