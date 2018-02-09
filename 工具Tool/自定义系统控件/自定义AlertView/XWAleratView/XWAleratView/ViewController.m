//
//  ViewController.m
//  XWAleratView
//
//  Created by 温仲斌 on 15/12/25.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import "ViewController.h"

#import "XWAlterVeiw.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
  
}
- (IBAction)tap:(id)sender {
    XWAlterVeiw *s = [[XWAlterVeiw alloc]init];
    [s show];
    [s setTextBlock:^(NSString *text) {
        NSLog(@"%@", text);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
