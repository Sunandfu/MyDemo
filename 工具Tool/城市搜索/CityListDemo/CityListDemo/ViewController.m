//
//  ViewController.m
//  CityListDemo
//
//  Created by 林英伟 on 16/5/1.
//  Copyright © 2016年 林英伟. All rights reserved.
//

#import "ViewController.h"
#import "CitySearchBar.h"
#import "CityHeaderView.h"
#import "UIView+SDAutoLayout.h"
#import "pinyin.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#define kStatusBarAndNaviBarH 64
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UIView *searchBarView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *searchResult;
@property (nonatomic,strong) NSMutableDictionary *cityDic;
@property (nonatomic,strong) NSArray *allKeys;
@property (nonatomic,strong) NSArray *letterArr;
@property (nonatomic,strong) CitySearchBar *searchBar;
@property (nonatomic,strong) CityHeaderView *tableHeaderView;
@property (nonatomic,assign) BOOL editing;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchBar];
    [self initTableView];
    [self configTableView];
    [self initData];
    [self sortCities];
}

#pragma mark initMethod
- (void)initSearchBar
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarAndNaviBarH, self.view.frame.size.width, 50)];
    self.searchBarView = view;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CitySearchBar *searchBar = [[CitySearchBar alloc]initWithFrame:CGRectZero];
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:0.5];
    [searchBar.layer setBorderColor:[UIColor grayColor].CGColor];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    [view addSubview:searchBar];
    
    self.searchBar.sd_layout
    .topSpaceToView(view,10)
    .leftSpaceToView(view,20)
    .rightSpaceToView(view,20)
    .heightIs(30);
    [self.view addSubview:view];
}

- (void)initTableView
{
    self.title = @"选择城市";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame), self.view.frame.size.width, self.view.frame.size.height - kStatusBarAndNaviBarH - self.searchBarView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableHeaderView = [[CityHeaderView alloc]init];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)configTableView
{
    self.tableView.sectionIndexColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)initData
{
    self.editing = NO;
    self.searchResult = [NSMutableArray array];
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"citys.plist" withExtension:nil];
    NSArray *tempArray = [NSMutableArray arrayWithContentsOfURL:url];
    NSMutableArray *data = [NSMutableArray array];
    for (NSString *city in tempArray) {
        [data addObject:city];
    }
    self.dataArray = data;
}

- (NSArray *)letterArr
{
    if (!_letterArr) {
        _letterArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    }
    return _letterArr;
}

- (void)sortCities
{
    self.cityDic = [NSMutableDictionary dictionary];
    NSArray *cityArr = [self.dataArray copy];
    for (NSString *city in cityArr) {
        char firstL = pinyinFirstLetter([city characterAtIndex:0]);
        NSString *key = [NSString stringWithFormat:@"%c",firstL];
        key = key.uppercaseString;
        NSMutableArray *newCitys = [self.cityDic objectForKey:key];
        if (!newCitys) {
            newCitys = [NSMutableArray array];
            [self.cityDic setObject:newCitys forKey:key];
        }
        [newCitys addObject:city];
    }
    self.allKeys = [self.cityDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    [self.tableView reloadData];
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:.3 animations:^{
        self.tableView.tableHeaderView = nil ;
    }];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:.3 animations:^{
        self.tableView.tableHeaderView = self.tableHeaderView;
    }];
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        self.editing = YES;
    } else {
        self.editing = NO;
    }
    
    [self.searchResult removeAllObjects];
    if (self.searchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        for (int i=0; i<self.dataArray.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:self.dataArray[i]]) {
                if(searchText.length == 1){
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:self.dataArray[i]];
                    NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [self.searchResult addObject:self.dataArray[i]];
                    }
                }else{
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:self.dataArray[i]];
                    NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [self.searchResult addObject:self.dataArray[i]];
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:self.dataArray[i]];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [self.searchResult addObject:self.dataArray[i]];
                    }
                }
            }
            else {
                NSRange titleResult=[self.dataArray[i] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [self.searchResult addObject:self.dataArray[i]];
                }
            }
        }
    } else if (self.searchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        for (NSString *tempStr in self.dataArray) {
            NSRange titleResult=[tempStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [self.searchResult addObject:tempStr];
            }
        }
    }
    if (self.searchBar.text.length == 0) {
        self.editing = NO;
    }
    [self.tableView reloadData];
}

#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.editing) {
        return nil;
    }
    return self.letterArr;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for (NSString *character in self.allKeys) {
        if ([character isEqualToString:title]) {
            return count;
        }
        count++;
    }
    return count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20,4, 300, 22)];
    headView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    label.textColor = [UIColor darkGrayColor];
    if (self.editing) {
        label.text = @"搜索结果";
    } else {
        label.text = self.allKeys[section];
    }
    [headView addSubview:label];
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.editing) {
        return 1;
    }
    return self.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.editing) {
        return self.searchResult.count;
    }
    return [[self.cityDic objectForKey:self.allKeys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *key = self.allKeys[indexPath.section];
    NSArray *citys = [self.cityDic objectForKey:key];
    if (self.editing) {
        if (self.searchResult.count > 0) {
            cell.textLabel.text = self.searchResult[indexPath.row];
        }else{
            cell.textLabel.text = citys[indexPath.row];
        }
    }else{
        cell.textLabel.text = citys[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectStr;
    NSString *key = self.allKeys[indexPath.section];
    NSArray *citys = [self.cityDic objectForKey:key];
    if (self.editing) {
        if (self.searchResult.count > 0) {
            selectStr = self.searchResult[indexPath.row];
        }else{
            selectStr = citys[indexPath.row];
        }
    }else{
        selectStr = citys[indexPath.row];
    }
    NSLog(@"%@",selectStr);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
