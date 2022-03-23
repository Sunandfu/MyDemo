//
//  ViewController.m
//  CJLCustom
//
//  Created by - on 2020/10/26.
//  Copyright © 2020 CJL. All rights reserved.
//

#import "ViewController.h"
#import "CJLPerson.h"
#import "NSObject+CJLKVC.h"
#import "CJLViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CJLPerson *person = [[CJLPerson alloc] init];
//    [person cjl_setValue:@"CJL" forKey:@"name"];
//    NSLog(@"取值：%@", [person cjl_valueForKey:@"name"]);
    
//    [self transmitMsg];
}
- (IBAction)pushClick:(id)sender {
    CJLViewController *cjlVC = [[CJLViewController alloc] init];
    [self.navigationController pushViewController:cjlVC animated:true];
}


//KVC实现高阶消息传递
- (void)transmitMsg{
    NSArray *arrStr = @[@"english", @"franch", @"chinese"];
    NSArray *arrCapStr = [arrStr valueForKey:@"capitalizedString"];
    
    for (NSString *str in arrCapStr) {
        NSLog(@"%@", str);
    }
    
    NSArray *arrCapStrLength = [arrCapStr valueForKeyPath:@"capitalizedString.length"];
    for (NSNumber *length in arrCapStrLength) {
        NSLog(@"%ld", (long)length.integerValue);
    }
}


@end
