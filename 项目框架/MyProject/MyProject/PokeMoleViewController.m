//
//  PokeMoleViewController.m
//  MyProject
//
//  Created by 小富 on 16/4/22.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "PokeMoleViewController.h"

#import <AudioToolbox/AudioToolbox.h>
@interface PokeMoleViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation PokeMoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageview.frame=CGRectMake(0, 0, 0, 0);
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doaction:)];
    [self.view addGestureRecognizer:tap];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(show) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 20, 30, 30);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)doaction:(UITapGestureRecognizer *)tap
{
    CGPoint aa=[tap locationInView:self.view];
    if (_imageview.frame.origin.x<=aa.x&&aa.x<=_imageview.frame.origin.x+64&&_imageview.frame.origin.y<=aa.y&&aa.y<=_imageview.frame.origin.y+66) {
        SystemSoundID systemsoundID;
        NSString *file=[[NSBundle mainBundle]pathForResource:@"打地鼠" ofType:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:file], &systemsoundID);
        
        AudioServicesPlaySystemSound(systemsoundID);
        i++;
        _label.text=[NSString stringWithFormat:@"%i",i];
    }
    
}
-(void)show{
    int  j=arc4random()%9;												//产生随机值
    switch (j) {
        case 0:
            _imageview.frame=CGRectMake(114, 157, 78, 86);
            break;
        case 1:
            _imageview.frame=CGRectMake(139, 80, 78, 86);
            break;
        case 2:
            _imageview.frame=CGRectMake(106, 247, 78, 86);
            break;
        case 3:
            _imageview.frame=CGRectMake(316, 250, 78, 86);
            break;
        case 4:
            _imageview.frame=CGRectMake(316, 164,78, 86);
            break;
        case 5:
            _imageview.frame=CGRectMake(311, 81, 78, 86);
            break;
        case 6:
            _imageview.frame=CGRectMake(492, 82, 78, 86);
            break;
        case 7:
            _imageview.frame=CGRectMake(493, 153, 78, 86);
            break;
        default:
            _imageview.frame=CGRectMake(511, 246, 78, 86);
            break;
            
    }
}
#pragma mark - 横屏代码
- (BOOL)shouldAutorotate
{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}


@end
