//
//  ViewController.m
//  https://github.com/c6357/YUChineseSorting
//
//  Created by BruceYu on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "ViewController.h"
#import "ChineseString.h"

@interface ViewController ()
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *stringsToSort=[NSArray arrayWithObjects:
                            @"￥hhh", @".$",@" ￥Chin ese ",@"开源中国 ",@"www.oschina.net",@"德国",
                            @"开源技术",@"社区",@"开发者",@"传播",
                            @"2014",@"a1",@"100",@"中国",@"暑假作业",
                            @"键盘", @"鼠标",@"hello",@"world",@"b1",
                            nil];
    
    self.indexArray = [ChineseString IndexArray:stringsToSort];
    self.letterResultArr = [ChineseString LetterSortArray:stringsToSort];
    
    
}


#pragma mark -
#pragma mark - UITableViewDataSource

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark - 
#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    lab.backgroundColor = [UIColor grayColor];
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = [UIColor whiteColor];
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---->%@",[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
                                                   delegate:nil
                                          cancelButtonTitle:@"YES" otherButtonTitles:nil];
    [alert show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
