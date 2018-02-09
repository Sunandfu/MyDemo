//
//  MainViewController.m
//  CWNumberKeyboardDemo
//
//  Created by william on 16/3/19.
//  Copyright © 2016年 陈大威. All rights reserved.
//

#import "MainViewController.h"
#import "CWNumberKeyboard.h"
@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (strong, nonatomic) CWNumberKeyboard *numberKb;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)priceButtonAction:(id)sender {
    if (!_numberKb) {
        _numberKb = [[CWNumberKeyboard alloc] init];
        [self.view addSubview:_numberKb];
    }
    [_numberKb setHidden:NO];
    [_numberKb showNumKeyboardViewAnimateWithPrice:self.mPriceLabel.text andBlock:^(NSString *priceString) {
        self.mPriceLabel.text = priceString;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
