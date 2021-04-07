//
//  SFBookSourceDetailViewController.m
//  ReadBook
//
//  Created by lurich on 2020/11/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBookSourceDetailViewController.h"
#import "SFBookSourceViewCell.h"
#import "SearchViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SFOneClickImportBookSourceView.h"

@interface SFBookSourceDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSDictionary *defaultNameDict;
@property (nonatomic, retain) NSDictionary *defaultPlaceDict;

@end

@implementation SFBookSourceDetailViewController

- (void)viewDidLoad {
    self.title = @"书源配置";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"一键导入" style:UIBarButtonItemStyleDone target:self action:@selector(daoruSource)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.defaultNameDict = @{
        @"name":@"书源名称",
        @"isCustom":@"自定义标识",
        @"wwwReq":@"主网站域名",
        @"wapReq":@"网站副域名",
        @"search":@"搜索接口",
        @"list":@"书籍列表",
        @"icon":@"书籍图片",
        @"aclick":@"书籍链接",
        @"title":@"书籍名称",
        @"auther":@"书籍作者",
        @"synopsis":@"书籍简介",
        @"synopsisDetail":@"简介详情",
        @"requestType":@"书源类别",
        @"catalog":@"目录接口",
        @"content":@"正文接口"
    };
    self.defaultPlaceDict = @{
        @"name":@"书源名称",
        @"isCustom":@"是否自定义，自定义书籍默认为1",
        @"wwwReq":@"主网站域名",
        @"wapReq":@"主网站副域名，一般为手机浏览器打开时显示的域名，可与主网站域名相同，已弃用",
        @"search":@"搜索书籍接口，关键词以SFSearchKey替代",
        @"list":@"列表xpath路径",
        @"icon":@"图片xpath路径",
        @"aclick":@"书籍链接xpath路径",
        @"title":@"书名xpath路径",
        @"auther":@"作者xpath路径",
        @"synopsis":@"简介xpath路径",
        @"synopsisDetail":@"简介详情xpath路径",
        @"requestType":@"书源类别，分为json或者html",
        @"catalog":@"书籍目录xpath路径",
        @"content":@"书籍正文xpath路径"
    };
    self.dataArray = @[@"name",
                       @"isCustom",
                       @"wwwReq",
                       @"wapReq",
                       @"search",
                       @"list",
                       @"icon",
                       @"aclick",
                       @"title",
                       @"auther",
                       @"synopsis",
                       @"synopsisDetail",
                       @"requestType",
                       @"catalog",
                       @"content"];
    
    [self createScrollViewWithSize:self.view.bounds.size];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.scrollView endEditing:YES];
}
- (void)createScrollViewWithSize:(CGSize)size{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-70)];
    scrollView.contentSize = CGSizeMake(0, self.dataArray.count*45);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int i=0; i<self.dataArray.count; i++) {
        NSString *name = self.dataArray[i];
        SFBookSourceViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SFBookSourceViewCell" owner:nil options:nil] firstObject];
        cell.frame = CGRectMake(0, 45*i, CGRectGetWidth(scrollView.frame), 45);
        cell.tag = 10+i;
        [self.scrollView addSubview:cell];
        cell.nameLabel.text = self.defaultNameDict[name];
        cell.nameLabel.tag = 10+i;
        cell.valueTextField.placeholder = self.defaultPlaceDict[name];
        cell.valueTextField.tag = 100+i;
        if (self.dict) {
            cell.valueTextField.text = self.dict[name];
        } else {
            if ([name isEqualToString:@"isCustom"]) {
                cell.valueTextField.enabled = NO;
                cell.valueTextField.text = @"1";
            } else {
                cell.valueTextField.enabled = YES;
            }
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 45*i+44, 90, 1)];
        lineView.backgroundColor = [SFTool colorWithHexString:@"f3f4f5"];
        [self.scrollView addSubview:lineView];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height-70, size.width, 70)];
    headerView.tag = 1000;
    // 阴影颜色
    headerView.layer.shadowColor = [UIColor grayColor].CGColor;
    // 阴影偏移，默认(0, -3)
    headerView.layer.shadowOffset = CGSizeMake(0,-3);
    // 阴影透明度，默认0
    headerView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    headerView.layer.shadowRadius = 3;
    [self.view addSubview:headerView];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(size.width/2.0-100, 10, 200, 50)];
    button.tag = 1001;
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [button setTitle:@"测试书源" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveBookSourceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    if (@available(iOS 13.0, *)) {
        headerView.backgroundColor = scrollView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            BOOL isFollSys = [[NSUserDefaults standardUserDefaults] boolForKey:KeyNightFollowingSystem];
            if (isFollSys) {
                if (traitCollection.userInterfaceStyle==UIUserInterfaceStyleDark) {
                    return [UIColor blackColor];
                } else {
                    return [UIColor whiteColor];
                }
            } else {
                BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
                if (isNignt) {
                    return [UIColor blackColor];
                } else {
                    return [UIColor whiteColor];
                }
            }
        }];
    } else {
        // Fallback on earlier versions
        BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
        if (isNignt) {
            headerView.backgroundColor = scrollView.backgroundColor = [UIColor blackColor];
        } else {
            headerView.backgroundColor = scrollView.backgroundColor = [UIColor whiteColor];
        }
    };
}
- (void)saveBookSourceBtnClick:(UIButton *)sender{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    for (int i=0; i<self.dataArray.count; i++) {
        NSString *nameStr = self.dataArray[i];
        UITextField *textField = [self.scrollView viewWithTag:100+i];
        if (textField.text.length>0) {
            [mutDict setValue:textField.text forKey:nameStr];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@处为空，请填写",self.defaultNameDict[nameStr]]];
            return;
        }
    }
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.descDict = [NSDictionary dictionaryWithDictionary:mutDict];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)updateFrameWithSize:(CGSize)size{
    self.scrollView.frame = CGRectMake(0, 0, size.width, size.height-70);
    self.scrollView.contentSize = CGSizeMake(0, self.dataArray.count*45);
    for (int i=0; i<self.dataArray.count; i++) {
        SFBookSourceViewCell *cell = [self.scrollView viewWithTag:10+i];
        cell.frame = CGRectMake(0, 45*i, CGRectGetWidth(self.scrollView.frame), 45);
    }
    UIView *headerView = [self.view viewWithTag:1000];
    headerView.frame = CGRectMake(0, size.height-70, size.width, 70);
    UIButton *button = [headerView viewWithTag:1001];
    button.frame = CGRectMake(size.width/2.0-100, 10, 200, 50);
}

- (void)daoruSource{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    SFOneClickImportBookSourceView *alertView = [[[NSBundle mainBundle] loadNibNamed:@"SFOneClickImportBookSourceView" owner:nil options:nil] firstObject];
//    alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    alertView.tag = 7777;
    alertView.frame = window.bounds;
    alertView.importButton.layer.masksToBounds = YES;
    alertView.importButton.layer.cornerRadius = 5;
    alertView.showContentTextView.layer.masksToBounds = YES;
    alertView.showContentTextView.layer.cornerRadius = 5;
    [alertView importBtnClickBlock:^(NSString * _Nonnull jsonStr) {
        NSLog(@"json字符串为：%@",jsonStr);
        if (jsonStr.length>0) {
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (dic) {
                [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i=0; i<self.dataArray.count; i++) {
                    NSString *name = self.dataArray[i];
                    SFBookSourceViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SFBookSourceViewCell" owner:nil options:nil] firstObject];
                    cell.frame = CGRectMake(0, 45*i, CGRectGetWidth(self.scrollView.frame), 45);
                    [self.scrollView addSubview:cell];
                    cell.nameLabel.text = self.defaultNameDict[name];
                    cell.nameLabel.tag = 10+i;
                    cell.valueTextField.placeholder = self.defaultPlaceDict[name];
                    cell.valueTextField.tag = 100+i;
                    if ([name isEqualToString:@"isCustom"]) {
                        cell.valueTextField.enabled = NO;
                        cell.valueTextField.text = @"1";
                    } else {
                        cell.valueTextField.enabled = YES;
                        cell.valueTextField.text = dic[name];
                    }
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 45*i+44, 90, 1)];
                    lineView.backgroundColor = [SFTool colorWithHexString:@"f3f4f5"];
                    [self.scrollView addSubview:lineView];
                }
            }
            
        }
    }];
    [UIView animateWithDuration:1.0 animations:^{
            [window addSubview:alertView];
    }];
}

@end
