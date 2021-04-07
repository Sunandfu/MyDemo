//
//  SFFontChooseViewController.m
//  ReadBook
//
//  Created by lurich on 2020/7/5.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFFontChooseViewController.h"
#import <CoreText/CoreText.h>

@interface SFFontChooseViewController ()

@property (strong, nonatomic) NSString *errorMessage;

@end

@implementation SFFontChooseViewController

- (void)asynchronouslySetFontName:(NSString *)fontName
{
    UIFont* aFont = [UIFont fontWithName:fontName size:12.];
    // If the font is already downloaded
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // Go ahead and display the sample text.
        self.fTextView.text = self.fontShow;
        self.fTextView.font = [UIFont fontWithName:fontName size:24.];
        [[NSUserDefaults standardUserDefaults] setObject:fontName forKey:KeyFontName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.fTableView reloadData];
        return;
    }
    
    // Create a dictionary with the font's PostScript name.
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    // Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        //NSLog( @"state %d - %@", state, progressParameter);
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show an activity indicator
                [self.fActivityIndicatorView startAnimating];
                self.fActivityIndicatorView.hidden = NO;
                
                // Show something in the text view to indicate that we are downloading
                self.fTextView.text= [NSString stringWithFormat:@"Downloading %@", fontName];
                self.fTextView.font = [UIFont systemFontOfSize:14.];
                
                NSLog(@"Begin Matching");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the activity indicator
                [self.fActivityIndicatorView stopAnimating];
                self.fActivityIndicatorView.hidden = YES;
                
                // Display the sample text for the newly downloaded font
                self.fTextView.text = self.fontShow;
                self.fTextView.font = [UIFont fontWithName:fontName size:24.];
                [[NSUserDefaults standardUserDefaults] setObject:fontName forKey:KeyFontName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.fTableView reloadData];
                // Log the font URL in the console
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
//                NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", fontName);
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show a progress bar
                self.fProgressView.progress = 0.0;
                self.fProgressView.hidden = NO;
                NSLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the progress bar
                self.fProgressView.hidden = YES;
                NSLog(@"Finish downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Use the progress bar to indicate the progress of the downloading
                [self.fProgressView setProgress:progressValue / 100.0 animated:YES];
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                self.errorMessage = [error description];
            } else {
                self.errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {
                self.fProgressView.hidden = YES;
                NSLog(@"Download error: %@", self.errorMessage);
            });
        }
        
        return (bool)YES;
    });
    
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fontNames count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    // Set up the cell.
    NSDictionary *fontDict = self.fontNames[indexPath.row];
    cell.textLabel.text = fontDict[@"china"];
    NSString *keyFontName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyFontName];
    NSString *fontName = fontDict[@"PostScript"];
    if ([fontName isEqualToString:keyFontName]) {
        cell.detailTextLabel.text = @"当前使用";
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *fontDict = self.fontNames[indexPath.row];
    NSString *fontName = fontDict[@"PostScript"];
    [self asynchronouslySetFontName:fontName];
    // Dismiss the keyboard in the text view if it is currently displayed
    if ([self.fTextView isFirstResponder])
        [self.fTextView resignFirstResponder];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fontNames = [[NSArray alloc] initWithObjects:
                      @{@"china":@"华文宋体",@"PostScript":@"STSong"},
                      @{@"china":@"华文楷体",@"PostScript":@"STKaiti"},
                      @{@"china":@"华文黑体",@"PostScript":@"STHeiti"},
                      @{@"china":@"华文仿宋",@"PostScript":@"STFangsong"},
                      @{@"china":@"黑体-简 细体",@"PostScript":@"STHeitiSC-Light"},
                      @{@"china":@"黑体-繁 细体",@"PostScript":@"STHeitiTC-Light"},
                      @{@"china":@"黑体-简 中等",@"PostScript":@"STHeitiSC-Medium"},
                      @{@"china":@"黑体-繁 中等",@"PostScript":@"STHeitiTC-Medium"},
                      @{@"china":@"楷体-简 常规体",@"PostScript":@"STKaitiSC-Regular"},
                      @{@"china":@"楷体-繁 常规体",@"PostScript":@"STKaitiTC-Regular"},
                      @{@"china":@"楷体-简 粗体",@"PostScript":@"STKaitiSC-Bold"},
                      @{@"china":@"楷体-简 黑体",@"PostScript":@"STKaitiSC-Black"},
                      @{@"china":@"行楷-简 细体",@"PostScript":@"STXingkaiSC-Light"},
                      @{@"china":@"行楷-繁 细体",@"PostScript":@"STXingkaiTC-Light"},
                      @{@"china":@"行楷-简 粗体",@"PostScript":@"STXingkaiSC-Bold"},
                      @{@"china":@"宋体-简 常规体",@"PostScript":@"STSongti-SC-Regular"},
                      @{@"china":@"宋体-繁 常规体",@"PostScript":@"STSongti-TC-Regular"},
                      @{@"china":@"宋体-简 细体",@"PostScript":@"STSongti-SC-Light"},
                      @{@"china":@"宋体-简 粗体",@"PostScript":@"STSongti-SC-Bold"},
                      @{@"china":@"宋体-简 黑体",@"PostScript":@"STSongti-SC-Black"},
                      @{@"china":@"苹方-港 常规体",@"PostScript":@"PingFangHK-Regular"},
                      @{@"china":@"苹方-繁 常规体",@"PostScript":@"PingFangTC-Regular"},
                      @{@"china":@"苹方-简 常规体",@"PostScript":@"PingFangSC-Regular"},
                      @{@"china":@"苹方-简 极细体",@"PostScript":@"PingFangSC-Ultralight"},
                      @{@"china":@"苹方-简 细体",@"PostScript":@"PingFangSC-Light"},
                      @{@"china":@"苹方-简 纤细体",@"PostScript":@"PingFangSC-Thin"},
                      @{@"china":@"苹方-简 中黑体",@"PostScript":@"PingFangSC-Medium"},
                      @{@"china":@"苹方-简 中粗体",@"PostScript":@"PingFangSC-Semibold"},
                      @{@"china":@"魏碑-简 粗体",@"PostScript":@"WeibeiSC-Bold"},
                      @{@"china":@"魏碑-繁 粗体",@"PostScript":@"WeibeiTC-Bold"},
                      @{@"china":@"雅痞-简 常规体",@"PostScript":@"YuppySC-Regular"},
                      @{@"china":@"圆体-简 常规体",@"PostScript":@"STYuanti-SC-Regular"},
                      @{@"china":@"圆体-简 细体",@"PostScript":@"STYuanti-SC-Light"},
                      @{@"china":@"圆体-简 粗体",@"PostScript":@"STYuanti-SC-Bold"},
                      @{@"china":@"圆体-繁 常规体",@"PostScript":@"STYuanti-TC-Regular"},
                      @{@"china":@"手札体-简 常规体",@"PostScript":@"HannotateSC-W5"},
                      @{@"china":@"手札体-简 粗体",@"PostScript":@"HannotateSC-W7"},
                      @{@"china":@"手札体-繁 常规体",@"PostScript":@"HannotateTC-W5"},
                      @{@"china":@"翩翩体-简 常规体",@"PostScript":@"HanziPenSC-W3"},
                      @{@"china":@"翩翩体-简 粗体",@"PostScript":@"HanziPenSC-W5"},
                      @{@"china":@"翩翩体-繁 常规体",@"PostScript":@"HanziPenTC-W3"},
                      @{@"china":@"凌慧体-简 中黑体",@"PostScript":@"MLingWaiMedium-SC"},
                      @{@"china":@"隶变-简 常规体",@"PostScript":@"STLibianSC-Regular"},
                      @{@"china":@"兰亭黑-简 纤黑",@"PostScript":@"FZLTXHK--GBK1-0"},
                      @{@"china":@"兰亭黑-简 中黑",@"PostScript":@"FZLTZHK--GBK1-0"},
                      @{@"china":@"兰亭黑-简 特黑",@"PostScript":@"FZLTTHK--GBK1-0"},
                      @{@"china":@"兰亭黑-繁 纤黑",@"PostScript":@"FZLTXHB--B51-0"},
                      @{@"china":@"报隶-简 常规体",@"PostScript":@"STBaoliSC-Regular"},
                      @{@"china":@"娃娃体-简 常规体",@"PostScript":@"DFWaWaSC-W5"},
                      @{@"china":@"標楷體",@"PostScript":@"DFKaiShu-SB-Estd-BF"},
                      @{@"china":@"蘋果儷細宋",@"PostScript":@"LiSungLight"},
                      @{@"china":@"蘋果儷中黑",@"PostScript":@"LiGothicMed"},
                      @{@"china":@"儷黑 Pro",@"PostScript":@"LiHeiPro"},
                      @{@"china":@"儷宋 Pro",@"PostScript":@"LiSongPro"},
                      @{@"china":@"冬青黑体简体中文 W3",@"PostScript":@"HiraginoSansGB-W3"},
                      @{@"china":@"冬青黑体简体中文 W6",@"PostScript":@"HiraginoSansGB-W6"},
                      @{@"china":@"Phosphate Inline",@"PostScript":@"Phosphate-Inline"},
                      @{@"china":@"Phosphate Solid",@"PostScript":@"Phosphate-Solid"},
                      @{@"china":@"Klee Medium",@"PostScript":@"Klee-Medium"},
                      @{@"china":@"Kai Regular",@"PostScript":@"SIL-Kai-Reg-Jian"},
                      @{@"china":@"Hiragino Sans W0",@"PostScript":@"HiraginoSans-W0"},
                      @{@"china":@"HiraMinProN-W3",@"PostScript":@"HiraMinProN-W3"},
                      @{@"china":@"HiraMaruProN-W4",@"PostScript":@"HiraMaruProN-W4"},
//                      @{@"china":@"AAAAAAAAAA",@"PostScript":@"AAAAAAAAAAAAA"},
                        nil];
    self.fontShow = @"\n字体样式展示\n\n汉体书写信息技术标准\n兙兛兞兝兡兣嗧瓩糎\n㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩\nHello world!\n1 2 3 4 5 6 7 8 9\n,.!@#$%^&*()';:|\n，。！@#￥%……&*（）‘；：、|";
    
    
    NSString *keyFontName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyFontName];
    self.fTextView.text = self.fontShow;
    self.fTextView.font = [UIFont fontWithName:keyFontName size:24.];
    self.fTextView.textAlignment = NSTextAlignmentCenter;
    
    self.title = @"66种字体随意换";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
@end

