//
//  ViewController.m
//  XMFTPServerDemo
//
//  Created by chi on 16/4/14.
//  Copyright © 2016年 chi. All rights reserved.
//

#import "ViewController.h"


#import "XMFTPServer.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *addressInfoLabel;

@property (nonatomic, strong) XMFTPServer *ftpServer;

@property (nonatomic, assign) unsigned ftpPort;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.addressInfoLabel.text = [NSString stringWithFormat:@"ftp://%@:%u", [XMFTPHelper localIPAddress], self.ftpPort];
    
    
    [self generateTestFiles];
}



#pragma mark - Event Response
- (IBAction)toggleFTPSwitch:(UISwitch*)sender {
    
    if (sender.isOn) {
        self.addressLabelHeightConstraint.constant = 40.f;
    }
    else {
        self.addressLabelHeightConstraint.constant = 0.f;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.addressInfoLabel.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
        if (sender.isOn) {
            if (self.ftpServer) {
                [self.ftpServer stopFtpServer];
            }
            
            self.ftpServer = [[XMFTPServer alloc]initWithPort:self.ftpPort withDir:NSHomeDirectory() notifyObject:self];
        } else {
            if (self.ftpServer) {
                [self.ftpServer stopFtpServer];
                self.ftpServer = nil;
            }
        }
    }];
    
}

#pragma mark - Private Method
- (void)generateTestFiles
{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    
    NSDate *nowDate = [NSDate date];
    
    // Documents
    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *docText = [NSString stringWithFormat:@"documents text generate by XMFTPServer at %@", [fmt stringFromDate:nowDate]];
    fmt.dateFormat = @"YYYYMMddHHmmss";
    //文件名
    NSString *filename = [NSString stringWithFormat:@"xmftp_doc_test_files_%@", [fmt stringFromDate:nowDate]];
    //文件路径
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [docText writeToFile:[filePath stringByAppendingPathComponent:filename] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Library
    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *libText = [NSString stringWithFormat:@"library text generate by XMFTPServer at %@", [fmt stringFromDate:nowDate]];
    fmt.dateFormat = @"YYYYMMddHHmmss";
    [libText writeToFile:[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"xmftp_lib_test_files_%@", [fmt stringFromDate:nowDate]]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // tmp
    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *tmpText = [NSString stringWithFormat:@"tmp text generate by XMFTPServer at %@", [fmt stringFromDate:nowDate]];
    fmt.dateFormat = @"YYYYMMddHHmmss";
    [tmpText writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"xmftp_tmp_test_files_%@", [fmt stringFromDate:nowDate]]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


#pragma mark - Properties

- (unsigned)ftpPort
{
    return 20000;
}

@end
