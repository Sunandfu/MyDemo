//
//  ViewController.m
//  meituan
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import "ViewController.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "CategoryModel.h"
#import "FoodModel.h"
#import "TableViewHeaderView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *categoryDataArray;
@property (nonatomic, strong) NSMutableArray *foodDataArray;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@end

@implementation ViewController{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectIndex = 0;
    _isScrollDown = YES;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"meituan" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *foods = dict[@"data"][@"food_spu_tags"];

    //导航按名字
    self.navigationItem.title = dict[@"data"][@"poi_info"][@"name"];
    
    for (NSDictionary *dic in foods) {
        //分类Model
        CategoryModel *model = [[CategoryModel alloc]init];
        model.name = dic[@"name"];//菜品类目
        model.icon = dic[@"icon"];//类目图片
        model.spus = dic[@"spus"];//类目下的菜 数组
        [self.categoryDataArray addObject:model];
        
        //菜品Model
        NSMutableArray *foodDatas = [NSMutableArray array];
        for (NSDictionary *dicFood in model.spus) {
            FoodModel *model = [[FoodModel alloc]init];
            model.name = dicFood[@"name"];
            model.foodId = dicFood[@"id"];
            model.picture = dicFood[@"picture"];
            model.praise_content = [dicFood[@"praise_num"] integerValue];
            model.month_saled = [dicFood[@"month_saled"] integerValue];
            model.min_price = [dicFood[@"min_price"] floatValue];
            
            [foodDatas addObject:model];
        }
        [self.foodDataArray addObject:foodDatas];
        
    }


    
    //创建两个TableView
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    //一开始让左边的tableView选择最上面的一栏
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];


}


- (NSMutableArray *)categoryDataArray
{
    if (!_categoryDataArray)
    {
        _categoryDataArray = [NSMutableArray array];
    }
    return _categoryDataArray;
}

- (NSMutableArray *)foodDataArray
{
    if (!_foodDataArray)
    {
        _foodDataArray = [NSMutableArray array];
    }
    return _foodDataArray;
}


- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, SCREEN_HEIGHT)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 55;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 64, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 64)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 80;
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Right];
    }
    return _rightTableView;
}



#pragma mark - TableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView)
    {
        return 1;
    }
    else
    {
        return self.categoryDataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView)
    {
        return self.categoryDataArray.count;
    }
    else
    {
        return [self.foodDataArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
        CategoryModel *model = self.categoryDataArray[indexPath.row];
        cell.name.text = model.name;
        return cell;
    }
    else
    {
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Right forIndexPath:indexPath];
        FoodModel *model = self.foodDataArray[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        TableViewHeaderView *view = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        CategoryModel *model = self.categoryDataArray[section];
        view.name.text = model.name;
        return view;
    }
    return nil;
}

// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView) && !_isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else {
        FoodModel *model = self.foodDataArray[indexPath.section][indexPath.row];
        NSLog(@"选择了菜品: %@, 菜的id是:%@, 价格是:%@",model.name,model.foodId,[self stringDisposeWithFloat:model.min_price]);
    }
}

// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
    
}

//浮点数处理并去掉多余的0
-(NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%f",floatValue];
    long len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}

@end
