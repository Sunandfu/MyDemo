//
//  UrlSessionDemoViewController.m
//  iOS7_New
//
//  Created by lincoln.liu on 2/1/14.
//  Copyright (c) 2014 xianlinbox. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate>

@property (nonatomic, copy) NSString *myfilePath;//下载得到的文件路径
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, getter=isStartDownload) BOOL startDownload;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.progressBar.progress = 0;
    self.startDownload = NO;
}
- (NSDateFormatter *)formatter{
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyyMMddHHmmssS"];
    }
    return _formatter;
}
- (NSString *)myfilePath{
    NSString *name = [NSString stringWithFormat:@"视频%@",[self.formatter stringFromDate:[NSDate date]]];
    _myfilePath = [NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),name,@"dmg"];
    return _myfilePath;
}
- (NSURLSession *)session
{
    //创建NSURLSession
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession  *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    return session;
}

- (NSURLRequest *)request
{
    NSString *urlStr = @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.1.dmg";
//    NSString *urlStr = @"http://data.vod.itc.cn/?rb=1&prot=1&key=jbZhEJhlqlUN-Wj_HEI8BjaVqKNFvDrn&prod=flash&pt=1&new=/42/154/nuLVh3RpRGqzMNmX9WiWAA.mp4";
    //创建请求
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

-(IBAction)start:(id)sender
{
    if (!self.isStartDownload) {
        //用NSURLSession和NSURLRequest创建网络任务
        self.startDownload = YES;
        self.task = [[self session] downloadTaskWithRequest:[self request]];
        [self.task resume];
    } else {
        NSLog(@"文件已在下载中");
    }
}

-(IBAction)pause:(id)sender
{
    NSLog(@"Pause download task");
    self.startDownload = NO;
    if (self.task) {
        //取消下载任务，把已下载数据存起来
        [self.task cancelByProducingResumeData:^(NSData *resumeData) {
            self.partialData = resumeData;
            self.task = nil;
        }];
    }
}

-(IBAction)resume:(id)sender
{
    NSLog(@"resume download task");
    self.startDownload = YES;
    if (!self.task) {
        //判断是否又已下载数据，有的话就断点续传，没有就完全重新下载
        if (self.partialData) {
            self.task = [[self session] downloadTaskWithResumeData:self.partialData];
        }else{
            self.task = [[self session] downloadTaskWithRequest:[self request]];
        }
    }
    [self.task resume];
}

//创建文件本地保存目录
-(NSURL *)createDirectoryForDownloadItemFromURL:(NSURL *)location
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = urls[0];
    return [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
}
//把文件拷贝到指定路径
-(BOOL) copyTempFileAtURL:(NSURL *)location toDestination:(NSURL *)destination
{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:destination error:NULL];
    [fileManager copyItemAtURL:location toURL:destination error:&error];
    if (error == nil) {
        return true;
    }else{
        NSLog(@"%@",error);
        return false;
    }
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //下载成功后，文件是保存在一个临时目录的，需要开发者自己考到放置该文件的目录
    NSLog(@"Download success for URL: %@",location.description);
    NSURL *destination = [self createDirectoryForDownloadItemFromURL:location];
    BOOL success = [self copyTempFileAtURL:location toDestination:destination];
    
    if(success){
        //文件改名
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *toPath = [destination path];
        NSString *filePath = self.myfilePath;
        [fm createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        NSError *error;
        BOOL isSuccess = [fm moveItemAtPath:toPath toPath:filePath error:&error];
        if (isSuccess) {
//        文件保存成功后，使用GCD调用主线程把图片文件显示在UIImageView中
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"文件路径:%@",[destination path]);
                self.progressLabel.text = @"100％";
                self.startDownload = NO;
            });
        } else {
            NSLog(@"%@",error);
        }
        
    }else{
        NSLog(@"Meet error when copy file");
    }
    self.task = nil;
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //刷新进度条的delegate方法，同样的，获取数据，调用主线程刷新UI
    double currentProgress = totalBytesWritten/(double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressBar.progress = currentProgress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f％",currentProgress*100];
        self.progressBar.hidden = NO;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end