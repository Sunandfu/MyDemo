//
//  ViewController.m
//  下载动画
//
//  Created by iMac on 16/9/21.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#import "WSDownloadView.h"
#import "AFNetworking.h"


#define WSColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface ViewController ()<WSDownloadAnimationDelegate>


@property (nonatomic, strong) WSDownloadView *downloadView;


@end

@implementation ViewController {
    NSURLSessionDownloadTask *downloadTask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
    _downloadView = [[WSDownloadView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-50, CGRectGetHeight(self.view.frame)/2-50, 100, 100)];
    _downloadView.delegate = self;
    _downloadView.progressWidth = 4;
    [self.view addSubview:_downloadView];
    
}



#pragma mark -  animation delegate

//点击开始下载
- (void)animationStart {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sc1.111ttt.com/2016/1/09/21/202211221224.mp3"]];

    downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *progressString  = [NSString stringWithFormat:@"%.2f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
            self.downloadView.progress = progressString.floatValue;
        });

        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        self.downloadView.isSuccess = YES;

        NSLog(@"%@",response);
        NSLog(@"地址%@",filePath);
        
    }];
    
    [downloadTask resume];
}

- (void)animationSuspend {
    
    [downloadTask suspend];
}

- (void)animationEnd {
    
    
}



@end
