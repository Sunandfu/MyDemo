//
//  LHCacheController.m
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/7.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHCacheController.h"
#import "LHData.h"

@interface LHCacheController ()

@property (nonatomic,strong) LHMemoryCache* memoryCache;

@property (nonatomic,strong) LHSqliteCache* sqliteCache;

@property (nonatomic,strong) LHFileCache* fileCache;

@end

@implementation LHCacheController

- (LHMemoryCache*)memoryCache
{
    if (!_memoryCache) {
        _memoryCache = [[LHMemoryCache alloc] init];
        _memoryCache.countMax = 100;
    }
    return _memoryCache;
}

- (LHSqliteCache*)sqliteCache
{
    if (!_sqliteCache) {
        _sqliteCache = [[LHSqliteCache alloc] init];
        _sqliteCache.overtime = 3600*24;
    }
    return _sqliteCache;
}

- (LHFileCache*)fileCache
{
    if (!_fileCache) {
        _fileCache = [[LHFileCache alloc] init];
        _fileCache.cacheShouldAppend = YES;
    }
    return _fileCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.fileCache removeAllData];
        for (int i=0; i<200; i++) {
            NSString* key = [NSString stringWithFormat:@"%d",i];
            [self.memoryCache setObject:@(i) forKey:key];
            [self.sqliteCache setData:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:key];
            [self.fileCache setData:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:key];
        }
        id object = [self.memoryCache objectForKey:@"1"];
        NSLog(@"object = %@",object);
        
        NSData* sqliteData = [self.sqliteCache dataForKey:@"1"];
        NSLog(@"sqlite = %@",sqliteData);
        
        NSData* fileData = [self.fileCache dataForKey:@"1"];
        NSLog(@"file = %@",fileData);
    });
    
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
