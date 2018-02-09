//
//  ViewController.m
//  MoveStar
//
//  Created by yang on 15/12/15.
//  Copyright © 2015年 yang. All rights reserved.
//

#import "ViewController.h"
#import "MovieAddComment.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addxinxin:(id)sender{
    MovieAddComment *movie = [[MovieAddComment alloc] initWithFrame:CGRectMake(0, 0,  [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.view addSubview:movie];
}

@end
