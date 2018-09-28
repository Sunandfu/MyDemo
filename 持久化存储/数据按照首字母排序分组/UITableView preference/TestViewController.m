//
//  TestViewController.m
//  UITableView preference
//
//  Created by 史岁富 on 2018/9/13.
//  Copyright © 2018年 shenliping. All rights reserved.
//

#import "TestViewController.h"
#import "PlistModel.h"
#import "NetRequestManager.h"
#import "EaseChineseToPinyin.h"

@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView  *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;//初始数据源

@end

@implementation TestViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"AllCarList" ofType:@"plist"];//添加我们需要的文件全称
        //获取此路径下的我们需要的数据（NSArray,NSDictionary,NSString...）
        NSMutableArray *rootArray = [NSMutableArray arrayWithContentsOfFile:filepath];//注意，如果想添加新的数据，需要NSMutable类型的
        for (NSDictionary *dcit in rootArray) {
            PlistModel *dataModel = [PlistModel modelWithJSON:dcit];
            [_dataArray addObject:dataModel];
        }
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleStr;
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }
    PlistModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    NSBundle *newPath = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logoImage.bundle"]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"carLogo%002ld.png",indexPath.row] inBundle:newPath compatibleWithTraitCollection:nil];
//    NSString *newPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *plistPath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"carLogo%002ld.png",indexPath.row]];
//    [self downloadWithUrl:model.logo ToPath:plistPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)downloadWithUrl:(NSString *)url ToPath:(NSString *)path{
    [NetRequestManager downloadWithUrl:url saveToPath:path progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        //封装方法里已经回到主线程，所有这里不用再调主线程了
        NSString *jindu = [NSString stringWithFormat:@"进度==%.2f",1.0 * bytesProgress/totalBytesProgress];
        NSLog(@"---------%@",jindu);
    } success:^(id response) {
        NSLog(@"下载完成---------%@",response);
    } failure:^(NSError *error) {
        NSLog(@"下载失败---------%@",error);
    }];
}

/*
 
 //https://www.autohome.com.cn/ashx/AjaxIndexCarFind.ashx?type=1
 
 // json文件  转  plist文件
 NSString *path = [[NSBundle mainBundle] pathForResource:@"car.json" ofType:nil];
 NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
 
 NSString *newPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
 NSString *plistPath = [newPath stringByAppendingPathComponent:@"AllCarList.plist"];
 [array writeToFile:plistPath atomically:YES];
 
 //代码生成plist文件
 NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 //获取完整路径
 NSString *documentsPath = [path objectAtIndex:0];
 NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"SFCarList.plist"];
 NSMutableArray *array = [NSMutableArray array];
 for (int i=0; i<self.dataArray.count; i++) {
 PlistModel *model = self.dataArray[i];
 NSMutableDictionary *usersDic = [[NSMutableDictionary alloc ] init];
 //设置属性值
 [usersDic setObject:model.name forKey:@"name"];
 [usersDic setObject:[NSString stringWithFormat:@"carLogo%02d.png",i] forKey:@"logo"];
 [usersDic setObject:model.logo forKey:@"url"];
 NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:model.name];
 [usersDic setObject:firstLetter1 forKey:@"pinyin"];
 [usersDic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
 [usersDic setObject:model.bfirstletter forKey:@"Initial"];
 [array addObject:usersDic];
 }
 //写入文件
 [array writeToFile:plistPath atomically:YES];
*/

@end
