//
//  LPXEditController.m
//  通讯录
//
//  Created by 卢鹏肖 on 16/4/20.
//  Copyright © 2016年 卢鹏肖. All rights reserved.
//

#import "LPXEditController.h"

@interface LPXEditController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@end

@implementation LPXEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTF.text = self.entity.name;
    self.phoneNumTF.text = self.entity.phoneNum;
    
 }


/**
 *   取消
 */
- (IBAction)cancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  确定
 */
- (IBAction)sureBtn:(id)sender {
    // 更新数据
    self.entity.name = self.nameTF.text;
    self.entity.phoneNum = self.phoneNumTF.text;
    self.entity.namePinYin = [CommonTool getPinYinFromString:self.entity.name];
    self.entity.sectionName = [self.entity.namePinYin substringToIndex:1];
    
    //保存
    [self.entity save];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
