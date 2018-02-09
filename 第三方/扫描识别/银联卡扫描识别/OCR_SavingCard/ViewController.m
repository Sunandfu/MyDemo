//
//  ViewController.m
//  OCR_SavingCard
//
//  Created by linyingwei on 16/5/5.
//  Copyright © 2016年 linyingwei. All rights reserved.
//

#import "ViewController.h"
#import "ScanCardViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ocr" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ocr"]) {
        ScanCardViewController *svc = segue.destinationViewController;
        [svc passValue:^(NSString *cardNo) {
            self.textLabel.text = cardNo;
        }];
    }
}
@end
