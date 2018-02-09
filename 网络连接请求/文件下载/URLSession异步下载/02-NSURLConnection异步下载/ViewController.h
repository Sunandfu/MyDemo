//
//  ViewController.h
//  02-NSURLConnection异步下载
//
//  Created by 刘天源 on 14/12/8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (atomic,strong) IBOutlet UIImageView *imageView;

@property (atomic,strong) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (atomic,strong) IBOutlet UIButton *start;

@property (atomic,strong) IBOutlet UIButton *pause;

@property (atomic,strong) IBOutlet UIButton *resume;

@property (atomic, strong) NSURLSessionDownloadTask *task;
@property (atomic, strong) NSData *partialData;

-(IBAction)start:(id)sender;
-(IBAction)pause:(id)sender;
-(IBAction)resume:(id)sender;
@end

