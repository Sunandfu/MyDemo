//
//  ViewController.m
//  微信九宫格头像
//
//  Created by iMac on 16/11/8.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#import "WSIconView.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)WSIconView *iconV;//九宫格头像
@property (nonatomic, strong)NSArray *imageArray;//头像

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageArray = @[@"http://img.woyaogexing.com/2016/11/08/1314509039fd23c3!200x200.jpg",
                    @"http://img.woyaogexing.com/2016/11/07/513e9c60a6221d3b!200x200.jpg",
                    @"http://img.woyaogexing.com/2016/11/08/7e196a06d7ffadc2!200x200.jpg",
                    @"http://img.woyaogexing.com/2016/11/07/c94a195d225c4afe!200x200.jpg",
                    @"http://img.woyaogexing.com/2016/11/07/c2dbfff1a0101f04!200x200.jpg",
                    @"http://img.woyaogexing.com/2016/11/06/d7b05f4e5d520add!200x200.jpg",
                    @"http://img.woyaogexing.com/2016/11/06/15291f727f42d301!200x200.jpg",
                    @"http://img.woyaogexing.com/2016/11/06/f5ffe101ec7bd91e!200x200.jpg",
                    @"http://img.woyaogexing.com/2016/11/06/f7dcd302c34ecf14!200x200.jpg"];
    
    
    [self _creatTableView];
    
    
    
}


- (void)_creatTableView {
    
    UITableView *tabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStylePlain];;
    tabV.dataSource = self;
    tabV.delegate = self;
    [self.view addSubview:tabV];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 9;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *identy = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
//    
//        
//    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    _iconV = [[WSIconView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    _iconV.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:_iconV];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < indexPath.row+1; i++) {
        [array addObject:[_imageArray objectAtIndex:i]];
    }
    [_iconV setImages:array];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconV.frame)+20, 30, self.view.frame.size.width-100, 20)];
    label.text = [NSString stringWithFormat:@"我们不是那种淫  %ld人",array.count];
    [cell.contentView addSubview:label];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}




@end
