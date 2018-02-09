//
//  MySlideTabBarView.m
//
//  Created by 史岁富 on 15/11/18.
//  Copyright © 2015年 史岁富. All rights reserved.
//

#import "MySlideTabBarView.h"

#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMainScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface MySlideTabBarView ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIScrollView *headerScrollView;
@property (nonatomic,strong) NSMutableArray *linesArray;
@property (nonatomic,strong) NSMutableArray *buttonsArray;
@property (nonatomic,strong) NSArray *headerTitleArray;//头部可点击的列表按钮
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *scrollTableViews;
@property (nonatomic,assign) int currentPage;//当前展示tableView


@end
@implementation MySlideTabBarView
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}
- (void)initData{
    self.linesArray = [[NSMutableArray alloc]init];
    self.buttonsArray = [[NSMutableArray alloc]init];
    self.selectColor = [UIColor grayColor];
    self.unSelectColor = [UIColor grayColor];
    self.headerHeight = 45;
    self.currentPage = 0;
    self.scrollTableViews = [[NSMutableArray alloc]init];
    [self addSubview:self.scrollView];
    
}
#pragma mark -- 实例化ScrollView
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    _scrollView.frame = CGRectMake(0, 45, self.bounds.size.width, self.bounds.size.height - 45);
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * self.headerTitleArray.count, 0);

    return _scrollView;
}
- (UIScrollView *)headerScrollView{
    if (!_headerScrollView) {
        _headerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.headerHeight)];
        [self addSubview:_headerScrollView];
        _headerScrollView.delegate = self;
        _headerScrollView.backgroundColor = [UIColor whiteColor];
        _headerScrollView.showsHorizontalScrollIndicator = NO;
        _headerScrollView.showsVerticalScrollIndicator = NO;
    }
    return _headerScrollView;
}
- (void)setHeaderHeight:(CGFloat)headerHeight{
    _headerHeight = headerHeight;
    self.headerScrollView.frame = CGRectMake(self.headerScrollView.frame.origin.x, self.headerScrollView.frame.origin.y, self.headerScrollView.frame.size.width, headerHeight);
}

- (void)creatHeaderUI{

    for (int i = 0; i<self.headerTitleArray.count; i++) {
        CGFloat width = [NSString widthForText:self.headerTitleArray[i] withWheight:45 WithFont:14];
        if (width < 45) {
            width = 45;
        }
        CGFloat space = 10;
        CGFloat framex = 15;
        if (i >= 1) {
            framex = [self.buttonsArray[i-1] frameX] + space + [self.buttonsArray[i-1] frameWidth];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(framex, 0, width, 45);
        [button setBackgroundColor:[UIColor clearColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:self.headerTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:self.headerTitleArray[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsArray addObject:button];
        [self.headerScrollView addSubview:button];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.origin.x, self.headerScrollView.bounds.size.height - 5, width, 2.5)];
        line.backgroundColor = [UIColor grayColor];
        [self.headerScrollView addSubview:line];
        [self.linesArray addObject:line];
        line.centerX = button.centerX;
        line.tag = i;
        
        if (i == 0) {
            button.selected = YES;
            line.hidden = NO;
        }else{
            line.hidden = YES;
        }
    }
    CGFloat contentSizeWidth = [[self.buttonsArray lastObject] frameX]+[[self.buttonsArray lastObject] frameWidth] + 15;
    CGFloat totalWidth = 0;
    if (contentSizeWidth < kMainScreenWidth) {
        for (UIButton *btn in self.buttonsArray) {
            totalWidth+=btn.frameWidth;
        }
        CGFloat space = (kMainScreenWidth - 30 - totalWidth)/(self.headerTitleArray.count - 1);
        for (int i = 0; i<self.buttonsArray.count; i++) {
            UIButton *button = self.buttonsArray[i];
            UIImageView *line = self.linesArray[i];
            CGFloat framex = 15;
            if (i >= 1) {
                framex = [self.buttonsArray[i-1] frameX] + space + [self.buttonsArray[i-1] frameWidth];
            }
            button.frame = CGRectMake(framex, 0, button.frameWidth, 45);
            line.centerX = button.centerX;
        }
    }
    self.headerScrollView.contentSize = CGSizeMake([[self.buttonsArray lastObject] frameX]+[[self.buttonsArray lastObject] frameWidth] + 15, 0);
    [self initDownTables];

}
- (void)buttonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    _currentPage = (int)button.tag;
    _currentTableView = self.scrollTableViews[_currentPage];
    for (UIButton *btn in self.buttonsArray) {
        btn.transform = CGAffineTransformMakeScale(1, 1);
        if (btn.tag == button.tag) {
            if (_delegate && [_delegate respondsToSelector:@selector(headerTitleClick:)]) {
                [_delegate headerTitleClick:(int)button.tag];
            }
            btn.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat offset = btn.centerX - self.frameWidth/2;
                offset = offset<=0?0:offset;
                offset = offset>self.headerScrollView.contentSize.width- self.headerScrollView.frameWidth?self.headerScrollView.contentSize.width- self.headerScrollView.frameWidth:offset;
                self.headerScrollView.contentOffset = CGPointMake(offset , 0);
            } completion:^(BOOL finished) {
                button.transform = CGAffineTransformMakeScale(1.1, 1.1);
            }];
        }else{
            btn.selected = NO;
        }
    }
    for (UIImageView *line in self.linesArray) {
        if (line.tag == button.tag) {
            line.hidden = NO;
        }else{
            line.hidden = YES;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(button.tag * self.bounds.size.width, 0) animated:YES];

}
-(void)initDownTables{
    
    for (int i = 0; i < self.headerTitleArray.count; i ++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.opaque = YES;
        tableView.tag = i;
        [tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRefresh)];
        [tableView addFooterWithTarget:self action:@selector(tableViewFooterRefresh)];
        [_scrollTableViews addObject:tableView];
        [self.scrollView addSubview:tableView];
    }
    _currentTableView = self.scrollTableViews[0];
}
#pragma  -- mark --tableViewHeaderRefresh
- (void)tableViewHeaderRefresh{
    if (_delegate && [_delegate respondsToSelector:@selector(TableViewHeaderRefresh:)]) {
        UITableView * tableView = self.scrollTableViews[_currentPage];
        [self.delegate TableViewHeaderRefresh:tableView];
    }
}
#pragma  -- mark --tableViewHeaderRefresh
- (void)tableViewFooterRefresh{
    if (_delegate && [_delegate respondsToSelector:@selector(TableViewFooterRefresh:)]) {
        UITableView * tableView = self.scrollTableViews[_currentPage];
        [self.delegate TableViewFooterRefresh:tableView];
    }
}
- (void)setDataSourceDelegate:(id)dataSourceDelegate{
    _dataSourceDelegate = dataSourceDelegate;
    if (_dataSourceDelegate && [_dataSourceDelegate respondsToSelector:@selector(headerTitleArray)]) {
       self.headerTitleArray = [_dataSourceDelegate headerTitleArray];
        if (self.buttonsArray.count == 0) {
            [self creatHeaderUI];
        }
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
#pragma mark -- scrollView的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.headerScrollView) {
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_scrollView isEqual:scrollView]) {
        _currentPage = _scrollView.contentOffset.x/self.bounds.size.width;
        [self buttonClick:self.buttonsArray[_currentPage]];
        UITableView *currentTable = _scrollTableViews[_currentPage];
        [currentTable reloadData];
    }
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.headerScrollView) {
        if (self.headerScrollView.contentOffset.y != 0) {
            self.headerScrollView.contentOffset = CGPointMake(self.headerScrollView.contentOffset.x, 0);
            return;
        }
    }
}
#pragma mark -- talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataSourceDelegate && [self.dataSourceDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSourceDelegate numberOfSectionsInTableView:tableView];
    }
    return 0;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSourceDelegate && [self.dataSourceDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.dataSourceDelegate tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSourceDelegate && [self.dataSourceDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.dataSourceDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSourceDelegate && [self.dataSourceDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.dataSourceDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
- (void)reloadData:(int)index{
    UITableView *tableView = self.scrollTableViews[index];
    [tableView reloadData];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation index:(int)index{
    UITableView *tableView = self.scrollTableViews[index];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
