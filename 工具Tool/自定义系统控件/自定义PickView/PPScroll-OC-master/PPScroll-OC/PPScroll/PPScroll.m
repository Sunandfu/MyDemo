//
//  PPScroll.m
//  PPScroll
//  项目地址：https://github.com/Fanish/PPScroll-OC
//  Created by Charlie C on 15/8/29.
//  Copyright (c) 2015年 Charlie C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPScroll.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

/**
 *  TableCell
 */

@interface PPScrollCell : UITableViewCell

@property (nonatomic, readwrite, copy)  UIFont *textFont;
@property (nonatomic, readwrite, copy)  UILabel *label;
@property (nonatomic, readwrite, copy)  UIColor *textColor_n;
@property (nonatomic, readwrite, copy)  UIColor *textColor_h;

@end

@implementation PPScrollCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.textLabel.font = [_textFont fontWithSize:_textFont.pointSize];
        self.textLabel.textColor = _textColor_h;
    }else{
        self.textLabel.font = _textFont;
        self.textLabel.textColor = _textColor_n;
    }
}

@end

/**
  *  主体
  */

@interface PPScroll()

@property (nonatomic,readwrite) float bannerHeight;
@property (nonatomic,readwrite) NSMutableDictionary *componentTables;
@property (nonatomic, readwrite, strong) NSMutableDictionary *selectedIndexDic;

@end

@implementation PPScroll

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setDefaults];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setDefaults];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}

void drawLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color){
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect{
    
    NSMutableArray *portions = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < _columnNum; i++) {
        
        float aaa = 1/_columnNum;
    
        [portions addObject:[NSString stringWithFormat:@"%f",aaa]];
        
    }
    
    _bannerHeight = _lineNum ? self.frame.size.height/_lineNum : self.frame.size.height/4;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, _bgColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGFloat portionSum = 0;
    CGRect bannerRect = ((int)_lineNum %2 == 0) ? //单双数
    CGRectMake(0, (rect.size.height-_bannerHeight)/2 - _bannerHeight/2, rect.size.width, _bannerHeight) ://双
    CGRectMake(0, (rect.size.height-_bannerHeight)/2, rect.size.width, _bannerHeight);//单
    //**此句重要，判断lineNum单双数来控制banner的y坐标**//
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [_bannerColor CGColor]);
    CGContextFillRect(context, bannerRect);
    CGContextRestoreGState(context);
    
    for (int i=0; i<_columnNum; i++) {
        portionSum += [[portions objectAtIndex:i] floatValue];
        if (portionSum > 0 && portionSum < 1) {
            CGPoint startPoint = CGPointMake(portionSum*rect.size.width, 0);
            CGPoint endPoint = CGPointMake(portionSum*rect.size.width, rect.size.height);
            drawLine(context, startPoint, endPoint, _separatorLineColor.CGColor);
        }
    }
    //下分界线
    CGPoint startPoint_up = CGPointMake(0, 0);
    CGPoint endPoint_up = CGPointMake(rect.size.width,0);
    drawLine(context, startPoint_up, endPoint_up, _separatorLineColor.CGColor);
    //上分界线
    CGPoint startPoint_down = CGPointMake(0, rect.size.height - 0.5);
    CGPoint endPoint_down = CGPointMake(rect.size.width,rect.size.height - 0.5);
    drawLine(context, startPoint_down, endPoint_down, _separatorLineColor.CGColor);
    
    [self layoutViews];

}


- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
//    [self layoutViews];
    [self setNeedsDisplay];
}

- (void)setBannerColor:(UIColor *)bannerColor{
    _bannerColor = bannerColor;
    [self setNeedsDisplay];
}

- (void)setSeparatorLineColor:(UIColor *)separatorLineColor{
    _separatorLineColor = separatorLineColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    _font = font;
    [self refreshTables];
}

- (void)setLineNum:(float)lineNum{
    _lineNum = lineNum;
    [self setNeedsDisplay];
    [self layoutViews];
}

-(void)setColumnNum:(float)columnNum{
    _columnNum = columnNum;
    [self setNeedsDisplay];
    [self layoutViews];
}

-(void)setTextColor_n:(UIColor *)textColor_n{
    _textColor_n = textColor_n;
    [self refreshTables];
}

-(void)setTextColor_h:(UIColor *)textColor_h{
    _textColor_h = textColor_h;
    [self refreshTables];
}

- (void)setDefaults
{
    _componentTables = [NSMutableDictionary new];
    _selectedIndexDic = [NSMutableDictionary new];
    
    _lineNum = 4;
    _columnNum = 5;
    _bannerColor = RGBA(8, 140, 79, 1);
    _separatorLineColor = RGBA(230, 230, 230, 1);
    _bgColor = RGBA(238, 238, 238, 1);
    _font = [UIFont systemFontOfSize:10];
    _textColor_h = RGBA(255, 255, 255, 1);
    _textColor_n = RGBA(0, 0, 0, 1);

}

- (void)layoutViews{
    
    CGSize contentSize = self.bounds.size;
    
    self.frame = (CGRect){.origin = CGPointMake(0, 0), .size = contentSize};
    
    for (UITableView *table in _componentTables.allValues) {
        [table removeFromSuperview];
    }
    
     [_componentTables removeAllObjects];
    
    NSMutableArray *portions = [[NSMutableArray alloc]init];
    
    if (_columnNum) {
        
        for (int i = 0; i < _columnNum; i++) {
            
            double aaa = 1/_columnNum;
            
            [portions addObject:[NSString stringWithFormat:@"%f",aaa]];
            
        }
    }
    
    CGFloat previousPortionSum = 0;
    
    for (int i = 0; i<portions.count; i++) {
        float currentPortion = [[portions objectAtIndex:i] floatValue];
        if (currentPortion > 0) {
            CGRect frame = CGRectMake(contentSize.width*previousPortionSum, 0, contentSize.width*currentPortion, contentSize.height);
            UITableView *table = [[UITableView alloc] initWithFrame:frame];
            table.backgroundColor = [UIColor clearColor];
            table.showsVerticalScrollIndicator = NO;
            table.separatorStyle  = UITableViewCellSeparatorStyleNone;
            table.contentInset = ((int)_lineNum % 2 == 0)? UIEdgeInsetsMake(CGRectGetHeight(table.frame) - (_lineNum/2 + 1)*_bannerHeight, 0, CGRectGetHeight(table.frame) - (_lineNum/2)*_bannerHeight, 0) : UIEdgeInsetsMake((CGRectGetHeight(table.frame) - _bannerHeight)/2, 0, (CGRectGetHeight(table.frame) - _bannerHeight)/2, 0);
            //**此句重要，判断lineNum单双数来控制table的可滑动区域**//
            [self addSubview:table];
            table.delegate = self;
            table.dataSource = self;
            table.tag = i + 100;
            [_componentTables setObject:table forKey:[NSNumber numberWithInt:i]];
        }
        previousPortionSum += currentPortion;
    }
    [self refreshTables];
}

- (void)refreshTables
{
    for (UITableView *table in _componentTables.allValues) {
        [self refreshTable:table];
    }
}

- (void)refreshTable:(UITableView *)table
{
    [table reloadData];
    [self scrollToAndSelectIndex:0 forTableView:table];
}

- (void)scrollToAndSelectIndex:(NSInteger)index forTableView:(UITableView *)tableView
{
    for (UITableView *table in _componentTables.allValues) {

        if (table == tableView) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [table reloadData];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)refreshTableWithArr:(NSMutableArray *)arr{

    for (UITableView *table in _componentTables.allValues) {
        NSInteger index = [arr[table.tag - 100] integerValue];
        [self scrollToAndSelectIndex:index forTableView:table];
    }
    
}


- (NSInteger)getIndexForScrollViewPosition:(UIScrollView *)scrollView
{    
    CGFloat offsetContentScrollView = (scrollView.frame.size.height - _bannerHeight) / 2.0f;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat index = roundf((offsetY + offsetContentScrollView) / _bannerHeight);
    
    if (((int)_lineNum % 2 == 0)) {
        index -= 1;
        //此句解决了，偶数使index产生的误差
    }
    
    [_selectedIndexDic setObject:[NSString stringWithFormat:@"%ld",(long)index] forKey:[NSString stringWithFormat:@"%ld",(long)scrollView.tag - 100]];
    
    if ([self.delegate respondsToSelector:@selector(scroll:selectedIndexDic:)]) {
        [self.delegate scroll:self selectedIndexDic:_selectedIndexDic];
    }
    if ([self.delegate respondsToSelector:@selector(scroll:index:)]) {
        [self.delegate scroll:self index:index];
    }
    
    return index;
}

#pragma mark - UIScrollViewDelegate Additional Methods

- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView
{
    [self selectMiddleRowOnScreenForTableView:(UITableView *)scrollView];
}

- (void)selectMiddleRowOnScreenForTableView:(UITableView *)tableView
{
    NSInteger index = [self getIndexForScrollViewPosition:tableView];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    /**
     *  使cell的位置改变为整数倍
     */
    targetContentOffset->y = round(targetContentOffset->y/_bannerHeight)*_bannerHeight;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScroll:scrollView];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self scrollToAndSelectIndex:indexPath.row forTableView:tableView];
    
    [_selectedIndexDic setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:[NSString stringWithFormat:@"%ld",(long)tableView.tag - 100]];
    
    if ([self.delegate respondsToSelector:@selector(scroll:selectedIndexDic:)]) {
        [self.delegate scroll:self selectedIndexDic:_selectedIndexDic];
    }
    if ([self.delegate respondsToSelector:@selector(scroll:index:)]) {
        [self.delegate scroll:self index:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _bannerHeight;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PPScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) cell = [[PPScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"T%ld  C%ld",(long)tableView.tag - 100,(long)indexPath.row];
    
    cell.textColor_h = _textColor_h;
    cell.textColor_n = _textColor_n;
    
    cell.textFont = _font;
    
    return cell;
}

@end
