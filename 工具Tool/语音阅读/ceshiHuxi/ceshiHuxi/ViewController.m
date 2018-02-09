//
//  ViewController.m
//  ceshiHuxi
//
//  Created by 小富 on 16/7/5.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "ViewController.h"
#import "SFSoundPlayer.h"

@interface ViewController () <SFSoundPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic,strong) SFSoundPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SFSoundPlayer *player = [SFSoundPlayer SFSoundPlayerInit];
    player.delegate = self;
    [player setDefaultWithVolume:1.0 rate:0.5 pitchMultiplier:1.0];
    self.player = player;
    
    
}
- (IBAction)play:(id)sender {
    [self.player play:@"大家上午好！让我来见证同学们生命中这个重要的时刻。"];
}
- (IBAction)stop:(id)sender {
    [self.player stopSpeaking];
    self.button.backgroundColor = [UIColor blueColor];
    self.button.userInteractionEnabled = YES;
}
- (IBAction)pause:(id)sender {
    [self.player pauseSpeaking];
}
- (IBAction)continue:(id)sender {
    [self.player continueSpeaking];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}
//朗读开始
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    self.button.backgroundColor = [UIColor grayColor];
    self.button.userInteractionEnabled = NO;
}
//朗读结束
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    self.button.backgroundColor = [UIColor blueColor];
    self.button.userInteractionEnabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
