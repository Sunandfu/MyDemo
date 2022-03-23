//
//  ViewController.m
//  a
//
//  Created by Ibokan on 15/9/28.
//  Copyright © 2015年 Crazy凡. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "GetColor.h"

@interface ViewController ()
@property (nonatomic,strong) GetColor * getcolor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib；
    NSLog(@"%@",[UIColor clearColor]);
    
    self.getcolor = [[GetColor alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.getcolor];
    
    [self.getcolor setBlock:^(UIColor *color)
    {
        NSLog(@"%@",color);
    }];
    
    NSData *data =  UIImagePNGRepresentation([UIImage imageNamed:@"1"]);
    NSString * base64String = [data base64EncodedStringWithOptions:0];
    NSString *asd = [base64String stringByReplacingOccurrencesOfString:@"c" withString:@"Copyright_Lurich"];
    NSLog(@"%@",asd);
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.getcolor runThisMetodWhenViewDidAppear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
