//
//  ViewController.m
//  huachi
//
//  Created by 小富 on 16/4/1.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "ViewController.h"
#import "SFDialScrollView.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet SFDialScrollView *dialView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[SFDialScrollView appearance] setMinorTicksPerMajorTick:10];
    [[SFDialScrollView appearance] setMinorTickDistance:16];
    
    [[SFDialScrollView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialBackground"]]];
    
    [[SFDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [[SFDialScrollView appearance] setLabelStrokeWidth:0.1f];
    [[SFDialScrollView appearance] setLabelFillColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    
    [[SFDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:20]];
    
    [[SFDialScrollView appearance] setMiddleTickColor:[UIColor colorWithRed:0.900 green:0.010 blue:0.010 alpha:1.000]];
    
    [[SFDialScrollView appearance] setMinorTickColor:[UIColor colorWithRed:0.800 green:0.553 blue:0.318 alpha:1.000]];
    [[SFDialScrollView appearance] setMinorTickLength:15.0];
    [[SFDialScrollView appearance] setMinorTickWidth:1.0];
    
    [[SFDialScrollView appearance] setMajorTickColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    [[SFDialScrollView appearance] setMajorTickLength:33.0];
    [[SFDialScrollView appearance] setMajorTickWidth:2.0];
    //刻度范围
    [self.dialView setDialRangeFrom:0 to:250];
    //初始刻度值
    self.dialView.currentValue = 10;
    
    self.dialView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating:");
    //刻度值
    NSLog(@"Current Value = %li", self.dialView.currentValue);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging:");
}

@end
