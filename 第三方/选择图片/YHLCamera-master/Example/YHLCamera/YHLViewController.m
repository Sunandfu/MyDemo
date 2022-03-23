//
//  YHLViewController.m
//  YHLCamera
//
//  Created by 272789124@qq.com on 07/04/2018.
//  Copyright (c) 2018 272789124@qq.com. All rights reserved.
//

#import "YHLViewController.h"
#import "YHLCameraViewController.h"

@interface YHLViewController ()<YHLCameraViewDelegate>
{
    UIButton *_curButton;
}
@property (weak, nonatomic) IBOutlet UIButton *driverFrontButton;
@property (weak, nonatomic) IBOutlet UIButton *driverBackButton;
@property (weak, nonatomic) IBOutlet UIButton *drvingFrontButton;
@property (weak, nonatomic) IBOutlet UIButton *drvingBackButton;
@property (weak, nonatomic) IBOutlet UIButton *IdFontButton;
@property (weak, nonatomic) IBOutlet UIButton *IdBackButton;
@property (strong, nonatomic) IBOutlet UIButton *personButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;


- (IBAction)stateClick:(UIButton *)sender;


- (IBAction)modelClick:(id)sender;
- (IBAction)pushClick:(id)sender;

@end

@implementation YHLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
    [self.driverFrontButton setEnabled:NO];
    _curButton=self.driverFrontButton;
}

-(void)setupUI{
    [self.driverFrontButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.driverBackButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.drvingFrontButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.drvingBackButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.IdFontButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.IdBackButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.personButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.defaultButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
}


- (IBAction)stateClick:(UIButton *)sender {
    _curButton=sender;
    [self selectType:sender];
}

-(void)selectType:(UIButton *)btn{
    [self.driverFrontButton setEnabled:YES];
    [self.driverBackButton setEnabled:YES];
    [self.drvingFrontButton setEnabled:YES];
    [self.drvingBackButton setEnabled:YES];
    [self.IdFontButton setEnabled:YES];
    [self.IdBackButton setEnabled:YES];
    [self.personButton setEnabled:YES];
    [self.defaultButton setEnabled:YES];
    [btn setEnabled:NO];
}

- (IBAction)modelClick:(id)sender {
    YHLCameraViewController *vc = [[YHLCameraViewController alloc] initWithParam:[self paramData]];
    vc.delegate=self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)pushClick:(id)sender {
    YHLCameraViewController *vc = [[YHLCameraViewController alloc] initWithParam:[self paramData]];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)camera:(UIImage *)image{
    if (image) {
        NSLog(@"拍摄成功");
    }
}

//选择拍摄对象
-(cameraType)paramData{
    if (_curButton==self.driverFrontButton) {
        return driverFrontType;
    }else if (_curButton==self.driverBackButton){
        return driverBackType;
    }else if (_curButton==self.drvingFrontButton){
        return drivingFrontType;
    }else if(_curButton==self.drvingBackButton){
        return drivingCopyType;
    }else if(_curButton==self.IdFontButton){
        return idFrontType;
    }else if(_curButton==self.IdBackButton){
        return idBackType;
    }else if(_curButton==self.personButton){
        return personType;
    }else if(_curButton==self.defaultButton){
        return defaultType;
    }else{
        return defaultType;
    }
}

@end
