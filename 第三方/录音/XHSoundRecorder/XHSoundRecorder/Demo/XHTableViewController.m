//
//  XHTableViewController.m
//  XHSoundRecorder
//
//  Created by Apple on 16/6/7.
//  Copyright © 2016年 张轩赫. All rights reserved.
//

#import "XHTableViewController.h"
#import "XHSoundRecorder.h"

@interface XHTableViewController ()

//@property (nonatomic, strong) XHSoundRecorder *recorder;

@end

@implementation XHTableViewController

//- (XHSoundRecorder *)recorder {
//    
//    if (!_recorder) {
//        
//        _recorder = [[XHSoundRecorder alloc] init];
//    }
//    
//    return _recorder;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.title = @"全部录音";

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.filePaths.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个录音",indexPath.row + 1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [self.recorder playsound:self.filePaths[indexPath.row] withFinishPlaying:nil];
    
    [[XHSoundRecorder sharedSoundRecorder] playsound:self.filePaths[indexPath.row] withFinishPlaying:nil];
}



@end




