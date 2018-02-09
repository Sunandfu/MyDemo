//
//  ViewController.m
//  XHSoundRecorder
//
//  Created by Apple on 16/6/7.
//  Copyright © 2016年 张轩赫. All rights reserved.
//

#import "ViewController.h"
#import "XHSoundRecorder.h"
#import "XHTableViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *recorder;

@property (weak, nonatomic) IBOutlet UIButton *player;

@property (nonatomic, strong) NSMutableArray *filePaths;

@property (nonatomic, copy) NSString *file;

@end

@implementation ViewController

- (NSMutableArray *)filePaths {
    
    if (!_filePaths) {
        
        _filePaths = [NSMutableArray array];
    }
    
    return _filePaths;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"录音";
    
#warning mark 获取录音分贝
    CGFloat decibels = [[XHSoundRecorder sharedSoundRecorder] decibels];
    
    
}

- (IBAction)recorder:(id)sender {
    
    typeof(self) wSelf = self;
    
    [[XHSoundRecorder sharedSoundRecorder] startRecorder:^(NSString *filePath) {
        
        NSLog(@"录音文件路径:%@",filePath);
        
        NSLog(@"录音结束");
        
        [wSelf.filePaths addObject:filePath];
        
        wSelf.file = filePath;
    }];
    
    [self.recorder setTitle:@"正在录音" forState:UIControlStateNormal];
}


- (IBAction)pauseRecorder:(id)sender {
    
    [[XHSoundRecorder sharedSoundRecorder] pauseRecorder];
    
    [self.recorder setTitle:@"继续录音" forState:UIControlStateNormal];
}

- (IBAction)stopRecorder:(id)sender {
    
    [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
    
    [self.recorder setTitle:@"录音" forState:UIControlStateNormal];
}

- (IBAction)player:(id)sender {
    
    typeof(self) wSelf = self;
    
    [[XHSoundRecorder sharedSoundRecorder] playsound:nil withFinishPlaying:^{
        
        NSLog(@"播放结束");
        
        [wSelf.player setTitle:@"播放" forState:UIControlStateNormal];
    }];
    
    [self.player setTitle:@"正在播放" forState:UIControlStateNormal];
}

- (IBAction)pausePlayer:(id)sender {
    
    [[XHSoundRecorder sharedSoundRecorder] pausePlaysound];
    
    [self.player setTitle:@"继续播放" forState:UIControlStateNormal];
}

- (IBAction)stopPlayer:(id)sender {
    
    [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
    
    [self.player setTitle:@"播放" forState:UIControlStateNormal];
}

- (IBAction)removeRecord:(id)sender {
    
    [[XHSoundRecorder sharedSoundRecorder] removeSoundRecorder];
    
    [self.filePaths removeLastObject];
}

- (IBAction)toMp3:(id)sender {
    
    typeof(self) wSelf = self;
    
    [[XHSoundRecorder sharedSoundRecorder] recorderFileToMp3WithType:Simulator filePath:nil FilePath:^(NSString *newfilePath) {
        
        NSLog(@"转换之后的路径:%@",newfilePath);
        
        [wSelf.filePaths removeObject:self.file];
        
        [wSelf.filePaths addObject:newfilePath];

    }];
    
    
}


- (IBAction)allRecord:(id)sender {
    
    XHTableViewController *table = [[XHTableViewController alloc] init];
    
    table.filePaths = self.filePaths;
    
    [self.navigationController pushViewController:table animated:YES];
    
}


@end





