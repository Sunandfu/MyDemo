//
//  ViewController.m
//  02-NSURLConnection异步下载
//
//  Created by 刘天源 on 14/12/8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSOperationQueue *myQueue;
@property (nonatomic, strong) NSOperation *downloadOp;

@property (nonatomic, assign) long long expectedContentLength;
@property (nonatomic, assign) long long currentLenght;
@property (nonatomic, copy) NSString *targetPath;

@property (nonatomic, assign) BOOL finished;

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@end

@implementation ViewController

- (NSOperationQueue *)myQueue {
    if (_myQueue == nil) {
        _myQueue = [[NSOperationQueue alloc] init];
    }
    return _myQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",NSHomeDirectory());
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.downloadOp = [NSBlockOperation blockOperationWithBlock:^{
        [self download];
    }];
    
    [self.myQueue addOperation:self.downloadOp];
}

- (void)download {
//    NSString *urlString = @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.1.dmg";
    NSString *urlString = @"http://flv2.bn.netease.com/videolib3/1511/19/RiCBl0272/SD/RiCBl0272-mobile.mp4";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];

    self.finished = NO;
    [conn start];
    
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    } while (!self.finished);
    
    NSLog(@"come here");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%s", __FUNCTION__);
    self.expectedContentLength = response.expectedContentLength;
    self.currentLenght = 0;
    self.targetPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/test_movie.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:self.targetPath error:NULL];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s %@", __FUNCTION__, [NSThread currentThread]);
    self.currentLenght += data.length;
    float progress = (float) self.currentLenght / self.expectedContentLength;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f％",progress*100];
    });
    
    // 2> 拼接文件数据
    [self writeToSandbox:data];
}
- (void)writeToSandbox:(NSData *)data {
    NSFileHandle *fp = [NSFileHandle fileHandleForWritingAtPath:self.targetPath];
    
    if (fp == nil) {
        [data writeToFile:self.targetPath atomically:YES];
    } else {
        [fp seekToEndOfFile];
        [fp writeData:data];
        [fp closeFile];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s", __FUNCTION__);
     NSLog(@"接收成功");
    self.finished = YES;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"出现错误%@",error);
}
@end
