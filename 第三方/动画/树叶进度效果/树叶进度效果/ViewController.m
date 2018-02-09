//
//  ViewController.m
//  树叶进度效果
//
//  Created by PengXiaodong on 16/1/27.
//  Copyright © 2016年 Tomy. All rights reserved.
//

#import "ViewController.h"
#import "LeafProgressView.h"

@interface ViewController ()
@property (nonatomic, strong) LeafProgressView *progress;
@property (nonatomic, assign) CGFloat rate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor orangeColor];
    
    self.progress = [[LeafProgressView alloc]initWithFrame:CGRectMake(36, 200, 248, 36)];
//    self.progress.backgroundColor = [UIColor orangeColor];
    self.progress.layer.cornerRadius = 18;
    self.progress.layer.borderWidth = 1.0;
    self.progress.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.view addSubview:_progress];
    
    [_progress startLoading];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self wodeanimol];
}
- (void)wodeanimol{
    _rate += 0.01;
    
    [_progress setProgress:_rate];
    if (_rate >= 0.999) {
        //        _rate = 0 ;
        [_progress stopLoading];
        return;
    }
    [self performSelector:@selector(wodeanimol) withObject:nil afterDelay:0.5];
}
@end







