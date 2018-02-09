//
//  LHModelController.m
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/7.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHModelController.h"
#import "Teacher.h"
#import "LHData.h"

@interface LHModelController ()

@end

@implementation LHModelController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary* dic = @{@"name":@"dshahdua",@"imageUrl":@"www.baidu.com",@"age":[NSNumber numberWithInteger:190],@"height":@"120",@"c":@"z",@"studentName":@[@"godL1",@"godL2",@"godL3"],@"studentInfo":@{@"name":@"godL",@"age":@22,@"height":@180}};
    Teacher* teacher = [Teacher lh_ModelWithDictionary:dic];
    NSLog(@"name = %@\n imageUrl = %@\n age = %ld\n height = %@\n c = %c\n studentName = %@\n studentInfo = %@",teacher.name,teacher.imageUrl,teacher.age,teacher.height,teacher.c,teacher.studentName,teacher.studentInfo);
    NSDictionary* dicValue = [teacher lh_ModelToDictionary];
    NSLog(@"dicValue = %@",dicValue);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
