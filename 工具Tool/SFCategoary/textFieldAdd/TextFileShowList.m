//
//  TextFileShowList.m
//  TextFileShowList
//
//  Created by 赵楠 on 16/4/26.
//  Copyright © 2016年 ZhaoNan. All rights reserved.
//

#import "TextFileShowList.h"

@interface TextFileShowList   ()<UITableViewDelegate,UITableViewDataSource>{
    CGRect tmpReck;
}
@property (nonatomic,strong)NSArray *suggestEmails;
@property (nonatomic,strong)NSMutableArray *suggestionOptions;
@property (nonatomic,strong)UITextField *textField;

@end
@implementation TextFileShowList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray *)suggestionOptions {
    if (!_suggestionOptions) {
        _suggestionOptions = [NSMutableArray arrayWithCapacity:1];
    }
    return _suggestionOptions;
}
+ (TextFileShowList *)listWithTextField:(UITextField *)enterTextFile{
    return [[self alloc] initWithTextField:enterTextFile];
}
- (TextFileShowList *)initWithTextField:(UITextField *)enterTextFile{
    self = [super initWithFrame:enterTextFile.frame style:UITableViewStylePlain];
    if (self) {
        NSArray *array = @[@"yun-xiang.net",@"139.com",@"qq.com",@"163.com",@"126.com",@"sina.com",@"vip.sina.com",@"hotmail.com",@"188.com",@"yahoo.com",@"sohu.com",@"top.com",@"163.net",@"msn.cn",@"live.com",@"gmail.com"];
        self.suggestEmails = [NSArray arrayWithArray:array];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        
        [enterTextFile addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        self.textField = enterTextFile;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [self hideOptionsView];
        
    }
    return  self;
}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardFram = [value CGRectValue];
    float viewHeight = [[UIScreen mainScreen] bounds].size.height;
    self.frame = CGRectMake(CGRectGetMinX(self.textField.frame), CGRectGetMaxY(self.textField.frame),self.textField.frame.size.width,viewHeight - keyBoardFram.size.height - CGRectGetMaxY(self.textField.frame));
    tmpReck = self.frame;
}
#pragma mark - textfieldchange - 
- (void)textFieldValueChanged:(UITextField *)textField
{
    NSString *currentStr = textField.text;
    if (!currentStr.length) {
        return;
    }
    NSRange range = [currentStr rangeOfString:@"@"];
    if (range.length) {
        NSString *emailstr = [self.textField.text substringFromIndex:range.location+1];
        if ([self substringInArraryOfString:emailstr]) {
            [self showOptionsView];
            [self reloadData];
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }else {
            [self hideOptionsView];
        }
        
    }else {
        [self hideOptionsView];
    }
    
}
#pragma mark - -
- (BOOL)substringInArraryOfString:(NSString *)string {
    NSMutableArray *tempArr = [NSMutableArray array];
    if (!string.length) {
        self.suggestionOptions = [self.suggestEmails mutableCopy];
        return  YES;
    }else {
        for (NSString *everyEmail in self.suggestEmails) {
            if ([everyEmail containsString:string]) {
                [tempArr addObject:everyEmail];
            }
        }
    }
    if (tempArr.count) {
        self.suggestionOptions = [tempArr mutableCopy];
        return YES;
    }else {
    return NO;
    }
}
#pragma mark - Options view control
- (void)showOptionsView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = tmpReck;
    }];
   
}

- (void) hideOptionsView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(CGRectGetMinX(self.textField.frame), CGRectGetMaxY(self.textField.frame), tmpReck.size.width, 0);
    }];
}
#pragma mark - tableviewDelegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.suggestionOptions.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellOfHight ? self.cellOfHight : 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"textFieldcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:(self.cellTextFont ? self.cellTextFont : 17)];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    NSRange range = [self.textField.text rangeOfString:@"@"];
    NSString *emileStr = [[NSString alloc]init];
    if (range.length) {
        emileStr = [self.textField.text substringToIndex:range.location + 1];
    }
    cell.textLabel.text = [emileStr stringByAppendingString:self.suggestionOptions[indexPath.section]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.textField.text = cell.textLabel.text;
    [self.textField resignFirstResponder];
    [self hideOptionsView];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
