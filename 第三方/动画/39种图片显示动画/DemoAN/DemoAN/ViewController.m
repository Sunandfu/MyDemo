//
//  ViewController.m
//  DemoAN
//
//  Created by Dolphin-MC700 on 14-9-17.
//  Copyright (c) 2014年 kid8. All rights reserved.
//

#import "ViewController.h"
#import "Demo5Transition.h"
#import "EPGLTransitionView.h"
#import "DemoTransition.h"
#import "Demo2Transition.h"
#import "Demo3Transition.h"
#import "Demo4Transition.h"
#import "Demo5Transition.h"
#import "Demo8Transition.h"
#import "Demo6Transition.h"
#import "Demo7Transition.h"
#import "DimageView.h"

@interface ViewController ()<DimageViewsDelegate>{
    DimageView *imageS;
    UIImageView *iview;
    NSTimer *timer;
    float x;
    float y;
    float w;
    float h;
    int number;
}

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//圆形进
- (IBAction)btnAction:(UIButton *)sender {
    iview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    [iview setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:iview];
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:0];
    [imageS setBackgroundColor:[UIColor clearColor]];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
     
}
//圆形出
- (IBAction)waiAction:(UIButton *)sender {
    iview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    [iview setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:iview];
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:1];
    [imageS setBackgroundColor:[UIColor clearColor]];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//矩形进
- (IBAction)juAction1:(UIButton *)sender {
    iview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    [iview setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:iview];
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:2];
    [imageS setBackgroundColor:[UIColor clearColor]];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//矩形出
- (IBAction)juAction2:(UIButton *)sender {
    iview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    [iview setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:iview];
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:3];
    [imageS setBackgroundColor:[UIColor clearColor]];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//十字形进
- (IBAction)shiAction1:(UIButton *)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:4];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//十字形出
- (IBAction)shiAction2:(UIButton *)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:5];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//菱形进
- (IBAction)lingAction:(UIButton *)sender {
    iview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    [iview setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:iview];
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:6];
    [imageS setBackgroundColor:[UIColor clearColor]];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//菱形出
- (IBAction)lingAction1:(UIButton *)sender {
    iview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    [iview setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:iview];
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:7];
    [imageS setBackgroundColor:[UIColor clearColor]];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//左右百叶窗出
- (IBAction)baiAction1:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:8];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//左右百叶窗进
- (IBAction)baiAction2:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:9];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//左右对开进
- (IBAction)duiAction:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:10];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//左右对开出
- (IBAction)duiAction1:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:11];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//上下百叶窗出
- (IBAction)shangAction:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:12];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//上下百叶窗进
- (IBAction)shangAction1:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:13];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//上下对开出
- (IBAction)kaiAction:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:14];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//上下对开进
- (IBAction)kaiAction1:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:15];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//马赛克出
- (IBAction)maAction:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:16];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//马赛克现
- (IBAction)maAction1:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:17];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//由小变大(中间)、由小变大(左上角)"、由小变大(右上角)"、由小变大(左下角)、由小变大(右下角)
- (IBAction)daAction:(UIButton *)sender {
    if (iview) {
        [iview removeFromSuperview];
        iview = [[UIImageView alloc]init];
        [iview setImage:[UIImage imageNamed:@"1.jpg"]];
        [self.view addSubview:iview];
    }else{
        iview = [[UIImageView alloc]init];
        [iview setImage:[UIImage imageNamed:@"1.jpg"]];
        [self.view addSubview:iview];
    }
    switch (sender.tag) {
        case 1:{
            x = 150;
            y = 100;
            w = 0;
            h = 0;
            break;
        }
        case 2:
            x = 10;
            y = 10;
            w = 0;
            h = 0;
            break;
        case 3:
            x = 10;
            y = 150;
            w = 0;
            h = 0;
            break;
        case 4:
            x = 310;
            y = 10;
            w = 0;
            h = 0;
            break;
        case 5:
            x = 300;
            y = 150;
            w = 0;
            h = 0;
            break;
        default:
            break;
    }
    number = sender.tag;
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(chageFrame)
                                           userInfo: nil
                                            repeats: YES];
}
//左覆盖出
- (IBAction)fuAction:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:18];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//右覆盖出
- (IBAction)fuAction1:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:19];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//上覆盖出
- (IBAction)fuAction2:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:20];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//下覆盖出
- (IBAction)fuAction3:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:21];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//左覆盖现
- (IBAction)fuAction4:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:22];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//右覆盖现
- (IBAction)fuAction5:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:23];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//上覆盖现
- (IBAction)fuAction6:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:24];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}
//下覆盖现
- (IBAction)fuAction7:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:25];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (IBAction)gaiAction:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:26];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (IBAction)gaiAction1:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:27];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (IBAction)gaiAction2:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:28];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (IBAction)gaiAction3:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:29];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (IBAction)gaiAction4:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:30];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (IBAction)gaiAction5:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:31];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (IBAction)gaiAction6:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:32];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (IBAction)gaiAction7:(id)sender {
    imageS = [[DimageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200) maxWight:320 maxHight:480 number:33];
    imageS.delegate = self;
    [self.view addSubview:imageS];
    if (!timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}

- (void)handleTimer{
    [imageS setNeedsDisplay];
}

-(void)stopDraw{
    if (timer) {
        [timer invalidate];
    }
}

-(void)chageFrame{
    switch (number) {
        case 1:
            if (x>0) {
                iview.frame = CGRectMake(x, y, w, h);
                x-=x/y;
                y--;
                w+=x/y*2;
                h+=2;
            }else{
                if (timer) {
                    [timer invalidate];
                }
            }
            break;
        case 2:
            if (w<300) {
                iview.frame = CGRectMake(x, y, w, h);
                w+=2;
                h++;
            }else{
                if (timer) {
                    [timer invalidate];
                }
            }
            break;
        case 3:
            if (w<300) {
                iview.frame = CGRectMake(x, y, w, h);
                y--;
                w+=2;
                h++;
            }else{
                if (timer) {
                    [timer invalidate];
                }
            }
            break;
        case 4:
            if (w<300) {
                iview.frame = CGRectMake(x, y, w, h);
                x-=2;
                w+=2;
                h++;
            }else{
                if (timer) {
                    [timer invalidate];
                }
            }
            break;
        case 5:
            if (w<300) {
                iview.frame = CGRectMake(x, y, w, h);
                x-=2;
                y--;
                w+=2;
                h++;
            }else{
                if (timer) {
                    [timer invalidate];
                }
            }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
