//
//  LPXAddController.m
//  通讯录
//
//  Created by 卢鹏肖 on 16/4/20.
//  Copyright © 2016年 卢鹏肖. All rights reserved.
//

#import "LPXAddController.h"

@interface LPXAddController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation LPXAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
/**
 *  取消
 */
- (IBAction)cancleBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  确定 数据保存到数据库中
 */
- (IBAction)sureBtn:(UIBarButtonItem *)sender{
    // 创建存储数据的对象
    ContactsEntity *entity = [ContactsEntity instanceObject];
    entity.name = self.nameTF.text;
    entity.phoneNum = self.phoneTF.text;
    entity.namePinYin = [CommonTool getPinYinFromString:entity.name];
    entity.sectionName = [entity.namePinYin substringToIndex:1];
    // 保存数据
    [entity save];
    
    [self.navigationController popViewControllerAnimated:YES];
}






@end
