//
//  ViewController.m
//  LFTipsGuideView
//
//  Created by TsanFeng Lam on 2020/2/3.
//  Copyright © 2020 lincf0912. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+LFTipsGuideView.h"

#import "LFTipsGuideManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)startAction:(id)sender {

    [self lf_showInView:self.navigationController.view maskViews:@[self.button1,self.button2,self.button3,self.button4,self.button5] withTips:@[@"点击此处进行搜索",@"点击此处进行编辑",@"举报用户",@"点击此处进行用于注册",@"..."]];
}

- (IBAction)clearAction:(id)sender {
    [[LFTipsGuideManager manager] removeClass:self.class];
}

- (IBAction)buttonAction:(id)sender {
    
}

@end
