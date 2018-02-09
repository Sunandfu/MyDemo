//
//  ViewController.m
//  喷枪打字动画
//
//  Created by laouhn on 15/10/19.
//  Copyright (c) 2015年 滕运华. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy , nonatomic)NSString *contentStr;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(animationLabel) object:nil];
    [thread start];
    self.contentStr = @"人生最宝贵的是生命，生命属于人只有一次。一个人的生命应当这样度过：当他回忆往事的时候，他不致因虚度年华而悔恨，也不致因碌碌无为而羞愧；在临死的时候，他能够说：“我的整个生命和全部精力，都已献给世界上最壮丽的事业——为人类的解放而斗争。”";

    
}

- (void)animationLabel
{
    for (NSInteger i = 0; i < self.contentStr.length; i++)
    {
        [self performSelectorOnMainThread:@selector(refreshUIWithContentStr:) withObject:[self.contentStr substringWithRange:NSMakeRange(0, i+1)] waitUntilDone:YES];
        [NSThread sleepForTimeInterval:0.3];
    }
}

- (void)refreshUIWithContentStr:(NSString *)contentStr
{
    self.titleLabel.text = contentStr;
}

@end















