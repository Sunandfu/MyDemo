//
//  DemoViewController.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/20.
//  Copyright © 2016年 More. All rights reserved.
//

#import "DemoViewController.h"

#import "FoldViewController.h"
#import "SinaViewController.h"
#import "MusiViewController.h"
#import "UIButtonViewController.h"


@interface DemoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property(nonatomic,strong)NSArray *nameTitle;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title =@"进阶动画Demo";
    
    [self makeUI];
    
    
    
}

-(void)makeUI{
    
    _nameTitle =@[@"图片折叠",@"微博动画",@"音乐振幅",@"",@""];
    
    _tab.dataSource =self;
    
    _tab.delegate =self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameTitle.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text =_nameTitle[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc ;
    
    switch (indexPath.row) {
        case 0:
            vc =[[FoldViewController   alloc]init];
            break;
            
        case 1:
            vc =[[SinaViewController   alloc]init];
            break;
            
        case 2:
            vc =[[MusiViewController   alloc]init];
            break;
            
//        case 3:
//            vc =[[UIButtonViewController   alloc]init];
//            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
