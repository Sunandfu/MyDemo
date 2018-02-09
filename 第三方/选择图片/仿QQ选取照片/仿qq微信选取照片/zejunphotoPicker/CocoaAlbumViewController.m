//
//  CocoaAlbumViewController.m
//  baixiaosheng
//
//  Created by 薛泽军 on 15/11/25.
//  Copyright © 2015年 薛泽军. All rights reserved.
//

#import "CocoaAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CocoaImageViewController.h"
@interface CocoaAlbumViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CocoaAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title=@"相册";
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-64)];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    [self goCocoImageViewArray:self.newimageArray withTitle:@"相机胶卷" WithAnimated:NO];
    UIBarButtonItem *rightBii=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBiiClick:)];
    self.navigationItem.rightBarButtonItem=rightBii;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)rightBiiClick:(UIBarButtonItem *)bii
{
    self.selectBlock(NO);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    NSDictionary *dict=self.albumArray[indexPath.row];
    cell.imageView.image=dict[@"image"];
    cell.textLabel.text=[NSString stringWithFormat:@"%@(%lu)",dict[@"name"],[dict[@"albumArray"] count]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=self.albumArray[indexPath.row];
    if ([dict[@"albumArray"] count]==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    [self goCocoImageViewArray:dict[@"albumArray"] withTitle:dict[@"name"] WithAnimated:YES];
    
}
- (void)goCocoImageViewArray:(NSArray *)array withTitle:(NSString *)title WithAnimated:(BOOL)animated
{
    CocoaImageViewController *civc=[[CocoaImageViewController alloc]init];
    civc.newimageArray=array;
    civc.navigationItem.title=title;
    civc.sendBackArray=self.sendBackArray;
    civc.selectBlock=^(BOOL isYes){
        self.selectBlock(isYes);
      [self dismissViewControllerAnimated:YES completion:^{
          
      }];
    };
    [self.navigationController pushViewController:civc animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
