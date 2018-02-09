//
//  MainViewController.m
//  DevDemo2D
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "MainViewController.h"
#import "BaseNaviViewController.h"
#import "MapViewController.h"

#define MainViewControllerTitle @"AppTools"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *classNames;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController

@synthesize classNames  = _classNames;
@synthesize tableView   = _tableView;

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sections[section][1] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sections[section][0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainCellIdentifier = @"mainCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = _sections[indexPath.section][1][indexPath.row];
    
    cell.detailTextLabel.text = self.classNames[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.classNames[indexPath.section][indexPath.row];
    
    BaseNaviViewController *subViewController = [[NSClassFromString(className) alloc] init];
    
    subViewController.title = _sections[indexPath.section][1][indexPath.row];
    
    [self.navigationController pushViewController:(UIViewController*)subViewController animated:YES];
}

#pragma mark - Initialization

- (void)initTitles
{
    NSString *sec1Title = @"基本功能";
    NSArray *sec1CellTitles = @[@"导航"];
    NSArray *section1 = @[sec1Title, sec1CellTitles];
    
    self.sections = [NSArray arrayWithObjects:section1, nil];
}

- (void)initClassNames
{
    NSArray *sec1ClassNames = @[@"MapViewController",
                               ];
    NSArray *sec2ClassNames = @[@""];
    
    self.classNames = [NSArray arrayWithObjects:sec1ClassNames, sec2ClassNames, nil];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.title = MainViewControllerTitle;
        
        [self initTitles];
        
        [self initClassNames];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

@end
