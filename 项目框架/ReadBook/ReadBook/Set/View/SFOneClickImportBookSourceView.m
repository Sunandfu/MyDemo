//
//  SFOneClickImportBookSourceView.m
//  ReadBook
//
//  Created by lurich on 2020/11/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFOneClickImportBookSourceView.h"

@implementation SFOneClickImportBookSourceView

- (void)importBtnClickBlock:(importBtnBlock)block{
    self.block = block;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
 请粘贴书源json至下方输入框，即可一键导入
 书源编辑属于高级自定义操作，如果自己不会操作，可联系作者付费定制自己相中的小说网站
}
*/
- (IBAction)importBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.block) {
        self.block(self.showContentTextView.text);
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.showContentTextView endEditing:YES];
}

@end
