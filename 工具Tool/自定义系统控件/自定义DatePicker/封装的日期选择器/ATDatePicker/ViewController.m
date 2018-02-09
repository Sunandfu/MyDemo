//
//  ViewController.m
//  ATDatePicker
//
//  Created by Jam on 16/8/4.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import "ViewController.h"
#import "ATDatePicker.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onClickButton:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDateAndTime DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
        weakSelf.dateLabel.text = dateString;
        NSLog(@"%@", dateString);
    }];
    datePicker.maximumDate = [NSDate date];
    [datePicker show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
