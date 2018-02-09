//
//  ViewController.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/20.
//  Copyright © 2016年 More. All rights reserved.
//

#import "ViewController.h"

#import "BaseViewController.h"      // 基础动画
#import "CAKeyfViewController.h"    // 关键帧动画
#import "GroupViewController.h"
#import "CATranViewController.h"
#import "DemoViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tab;

@property(nonatomic)NSArray *titleArray ;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self MakeUI];
    
}

#pragma mark ----- UI

-(void)MakeUI{
    self.title =@"More动画";
    _titleArray =@[@"   基础动画",@"   关键帧动画",@"   动画组",@"   过渡动画",@"   动画进阶Demo",@"                                     @author:More"];
    _tab =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tab.dataSource =self;
    _tab.delegate =self;
    [self.view addSubview:_tab];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _titleArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"ID";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text =_titleArray[indexPath.row];
    
    if (indexPath.row==5) {
        cell.textLabel.textColor =[UIColor redColor];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *vc ;
    
    switch (indexPath.row) {
        case 0:
            vc =[[BaseViewController alloc]init];
            break;
        case 1:
            vc =[[CAKeyfViewController  alloc]init];
            break;
        case 2:
            vc =[[GroupViewController   alloc]init];
            break;
        case 3:
            vc =[[CATranViewController   alloc]init];
            break;
        case 4:
            vc =[[DemoViewController   alloc]init];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
