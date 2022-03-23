//
//  SFStringViewController.m
//  SFCodeObfuscation
//
//  Created by SF on 2018/8/18.
//  Copyright © 2018年 Lurich All rights reserved.
//

#import "SFStringViewController.h"
#import "SFObfuscationTool.h"
#import "NSString+Extension.h"
#import "NSFileManager+Extension.h"

@interface SFStringViewController ()
@property (weak) IBOutlet NSTextField *stringField;
@property (weak) IBOutlet NSButton *encryptBtn;

@property (weak) IBOutlet NSButton *chooseBtn;
@property (weak) IBOutlet NSButton *startBtn;
@property (weak) IBOutlet NSButton *openBtn;
@property (weak) IBOutlet NSTextField *tipLabel;
@property (weak) IBOutlet NSTextField *filepathLabel;
@property (weak) IBOutlet NSTextField *destFilepathLabel;
@property (unsafe_unretained) IBOutlet NSTextView *resultView;

@property (copy) NSString *filepath;
@property (copy) NSString *destFilepath;
@end

@implementation SFStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.tipLabel.stringValue = @"";
    self.filepathLabel.stringValue = @"";
    self.destFilepathLabel.stringValue = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stringDidChange) name:NSControlTextDidChangeNotification object:self.stringField];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stringDidChange
{
    NSString *text = [self.stringField.stringValue sf_stringByRemovingSpace];
    self.encryptBtn.enabled = (text.length != 0) ;
}

- (IBAction)encrypt:(NSButton *)sender {
    [SFObfuscationTool encryptString:self.stringField.stringValue completion:^(NSString *h, NSString *m) {
        self.resultView.string = [NSString stringWithFormat:@"%@\n%@", h, m];
    }];
}

- (IBAction)start:(NSButton *)sender {
    self.destFilepathLabel.stringValue = @"";
    self.startBtn.enabled = NO;
    self.chooseBtn.enabled = NO;
    
    // 处理进度
    void (^progress)(NSString *) = ^(NSString *detail) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.stringValue = detail;
        });
    };
    
    // 处理结束
    void (^completion)(NSString *, NSString *) = ^(NSString *h, NSString *m) {
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSString *dir = [self.filepath stringByAppendingPathComponent:@"SFEncryptString"];
        dir = [NSFileManager sf_checkPathExists:dir];
        [mgr createDirectoryAtPath:dir withIntermediateDirectories:YES
                        attributes:nil error:nil];
        self.destFilepath = dir;
        
        [h writeToFile:[dir stringByAppendingPathComponent:@"SFEncryptStringData.h"]
            atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [m writeToFile:[dir stringByAppendingPathComponent:@"SFEncryptStringData.m"]
            atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        [mgr copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SFEncryptStringH" ofType:@"tpl"]
                     toPath:[dir stringByAppendingPathComponent:@"SFEncryptString.h"] error:nil];
        [mgr copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SFEncryptStringM" ofType:@"tpl"]
                     toPath:[dir stringByAppendingPathComponent:@"SFEncryptString.m"] error:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.destFilepathLabel.stringValue = [NSString stringWithFormat:
                                                  @"加密后的文件路径：\n%@",
                                                  self.destFilepath];
            self.startBtn.enabled = YES;
            self.chooseBtn.enabled = YES;
        });
    };

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [SFObfuscationTool encryptStringsAtDir:self.filepath
                                      progress:progress
                                    completion:completion];
    });
}

- (IBAction)open:(NSButton *)sender {
    NSString *file = self.destFilepath ? self.destFilepath : self.filepath;
    NSArray *fileURLs = @[[NSURL fileURLWithPath:file]];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
}

- (IBAction)choose:(NSButton *)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.prompt = @"选择";
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result != NSModalResponseOK) return;
        
        self.filepath = openPanel.URLs.firstObject.path;
        self.filepathLabel.stringValue = [NSString stringWithFormat:@"需要加密的目录：\n%@", self.filepath];
        self.destFilepathLabel.stringValue = @"";
        self.startBtn.enabled = YES;
        self.openBtn.enabled = YES;
    }];
}

@end
