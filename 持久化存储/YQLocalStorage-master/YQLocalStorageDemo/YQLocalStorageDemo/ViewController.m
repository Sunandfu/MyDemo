//
//  ViewController.m
//  YQLocalStorageDemo
//
//  Created by problemchild on 2017/12/13.
//  Copyright © 2017年 freakyyang. All rights reserved.
//

#import "ViewController.h"

#import <YQLocalStorage/YQLocalStorage.h>

@interface ViewController ()

@property (nonatomic,strong) YQLocalStorage *DB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.DB = [YQLocalStorage storageWithPath:@"temp.sqlite"];
    
    [self.DB checkOrCreatTableWithName:@"person"
                                  keys:@[@"name",@"age",@"sex",@"groupx",@"aaa",@"bbb"]
                                 block:^(BOOL succeed, NSString * _Nullable reason)
    {
        NSLog(@"check :: %d,%@",succeed,reason);
    }];
    
    [self.DB insertObjectWithTableName:@"person"
                                  data:@{@"name":@"yangqi",
                                         @"age":@"20",
                                         @"groupx":@"freak",
                                         @"sex":@"man"
                                         }
                                 block:^(BOOL succeed, NSString * _Nullable reason)
    {
        NSLog(@"first : %d,%@",succeed,reason);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        //delete
        [self.DB deleteObjectWithTableName:@"person" condition:nil block:^(BOOL succeed, NSString * _Nullable reason) {
            NSLog(@"delete : %d , %@",succeed,reason);
        }];
        //insert
        for (int i=0; i<50; i++) {
            NSLog(@"in loop : %d",i);
            [self.DB insertObjectWithTableName:@"person"
                                          data:@{@"name":[NSString stringWithFormat:@"yangqi%d",i],
                                                 @"age":[NSString stringWithFormat:@"%d",i+100],
                                                 @"groupx":@"freak",
                                                 @"sex":@"man"
                                                 }
                                         block:^(BOOL succeed, NSString * _Nullable reason) {
                                             NSLog(@"block %d result : %d , %@",i,succeed,reason);
                                         }];
        }
        //search
        [self.DB searchStorageWithTableName:@"person" condition:nil Keys:nil block:^(BOOL succeed, NSArray<YQLSSearchResultItem *> * _Nullable result) {
            NSLog(@"search : %@",result);
        }];
    //update
    [self.DB searchStorageWithTableName:@"person" condition:nil Keys:nil block:^(BOOL succeed, NSArray<YQLSSearchResultItem *> * _Nullable result) {
        NSLog(@"search : %@",result);
        for (int i=0;i<result.count ; i++) {
            YQLSSearchResultItem *item = result[i];
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:item.data];
            [dataDic setObject:@"freak22222" forKey:@"groupx"];
            [self.DB updateObjectWithTableName:@"person" objectID:item.ID data:dataDic block:^(BOOL succeed, NSString * _Nullable reason) {
                NSLog(@"update finish %d : %d , %@",i,succeed,reason);
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
