//
//  ViewController.m
//  RATreeDemo
//
//  Created by l2cplat on 16/5/25.
//  Copyright © 2016年 zhukaiqi. All rights reserved.
//

#import "ViewController.h"
#import <RATreeView/RATreeView.h>
#import "RaTreeViewCell.h"
#import "RaTreeModel.h"
@interface ViewController ()<RATreeViewDataSource,RATreeViewDelegate>

@property (nonatomic,strong) RATreeView *raTreeView;

@property (nonatomic,strong) NSMutableArray *modelArray;//存储model的数组

@end

@implementation ViewController

//懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

//加载数据
- (void)setData {
    
    //宝鸡市 (四层)
    RaTreeModel *zijingcun = [RaTreeModel dataObjectWithName:@"紫荆村" children:nil];
    
    RaTreeModel *chengcunzheng = [RaTreeModel dataObjectWithName:@"陈村镇" children:@[zijingcun]];
    
    RaTreeModel *fengxiang = [RaTreeModel dataObjectWithName:@"凤翔县" children:@[chengcunzheng]];
    RaTreeModel *qishan = [RaTreeModel dataObjectWithName:@"岐山县" children:nil];
    RaTreeModel *baoji = [RaTreeModel dataObjectWithName:@"宝鸡市" children:@[fengxiang,qishan]];
    
    //西安市
    RaTreeModel *yantaqu = [RaTreeModel dataObjectWithName:@"雁塔区" children:nil];
    RaTreeModel *xinchengqu = [RaTreeModel dataObjectWithName:@"新城区" children:nil];
    
    RaTreeModel *xian = [RaTreeModel dataObjectWithName:@"西安" children:@[yantaqu,xinchengqu]];
    
    RaTreeModel *shanxi = [RaTreeModel dataObjectWithName:@"陕西" children:@[baoji,xian]];
    
    [self.modelArray addObject:shanxi];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self setData];
    //创建raTreeView
    self.raTreeView = [[RATreeView alloc] initWithFrame:self.view.frame];
    
    //设置代理
    self.raTreeView.delegate = self;
    self.raTreeView.dataSource = self;
    
    [self.view addSubview:self.raTreeView];
    
    //注册单元格
    [self.raTreeView registerNib:[UINib nibWithNibName:@"RaTreeViewCell" bundle:nil] forCellReuseIdentifier:@"RaTreeViewCell"];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -----------delegate 

//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
 
    return 50;
}

//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    
    RaTreeViewCell *cell = (RaTreeViewCell *)[treeView cellForItem:item];
    cell.iconView.image = [UIImage imageNamed:@"open"];
   
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    
    RaTreeViewCell *cell = (RaTreeViewCell *)[treeView cellForItem:item];
    cell.iconView.image = [UIImage imageNamed:@"close"];

}

//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    
    
    NSLog(@"已经展开了");
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    
    NSLog(@"已经收缩了");
}


#pragma mark -----------dataSource

//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
 
    
   
    //获取cell
    RaTreeViewCell *cell = [treeView dequeueReusableCellWithIdentifier:@"RaTreeViewCell"];
    
    //当前item
    RaTreeModel *model = item;
    
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
   
    //赋值
    [cell setCellBasicInfoWith:model.name level:level children:model.children.count];
   
    return cell;

}

/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  每一节点对应的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
     RaTreeModel *model = item;
    
     if (item == nil) {

        return self.modelArray.count;
    }

    return model.children.count;
}
/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {

    RaTreeModel *model = item;
    if (item==nil) {
       
        return self.modelArray[index];
    }
   
    return model.children[index];
}


//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {

    //获取当前的层
    NSInteger level = [treeView levelForCellForItem:item];

    //当前点击的model
    RaTreeModel *model = item;

    NSLog(@"点击的是第%ld层,name=%@",level,model.name);

}

//单元格是否可以编辑 默认是YES
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    
    return YES;
}

//编辑要实现的方法
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
    
    NSLog(@"编辑了实现的方法");


}

//....没看懂啥意思
- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item {

    return 3;
}



@end
