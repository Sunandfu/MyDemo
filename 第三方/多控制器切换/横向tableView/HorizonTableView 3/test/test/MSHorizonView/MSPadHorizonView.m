//
//  MSPadHorizonView.m
//  mushuIpad
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import "MSPadHorizonView.h"

#pragma mark ---------section pos------------
typedef NS_ENUM (NSUInteger, MPSECTION_TYPE){
    MPSECTION_HEADER, MPSECTION_FOOTER
};

//
@interface MSPadHorizonSectionPos : MSPadHorizonPos
@property (nonatomic, assign) MPSECTION_TYPE sectionType;
@property (nonatomic, assign) NSUInteger section;
@end

@implementation MSPadHorizonSectionPos
@end

@interface MSPadHorizonSectionArea : MSPadHorizonPos
@property (nonatomic, assign) NSUInteger headerDrawIndex;
@property (nonatomic, assign) NSUInteger footerDrawIndex;
@end

@implementation MSPadHorizonSectionArea

- (id)init {
    if (self = [super init]) {
        self.headerDrawIndex = self.footerDrawIndex = NSNotFound;
    }
    return self;
}

@end

#pragma mark ---------cell pos----------

@interface MSPadHorizonCellPos : MSPadHorizonPos
@property (nonatomic, strong) MPIndexPath *indexPath;
@end

@implementation MSPadHorizonCellPos
@end

#pragma mark ---------horizonViewCell begin---------
NSString *const MSPadHorizonReuseIdentifierDefault = @"MSPadHorizonReuseIdentifierDefault";

@interface MSPadHorizonCell()
@property (nonatomic, assign) BOOL kHadUsed;
@property (nonatomic, assign) NSUInteger kDrawIndex;
@property (nonatomic, strong) UIColor *kLastColor;

@end
@implementation MSPadHorizonCell
- (id)initWithReuseIdentifier:(NSString*)identifier{
    if (self = [super init]) {
        _identifier = identifier;
        _selectedHighlighted = YES;
        if (!self.identifier) {
            _identifier = MSPadHorizonReuseIdentifierDefault;
        }
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        _selectedHighlighted = YES;
        _identifier = MSPadHorizonReuseIdentifierDefault;
    }
    return self;
}

- (BOOL)highlighted{
    return _kLastColor ? YES : NO;
}

- (void)setSelected:(BOOL)selected{
    if (_selected == selected) {
        return;
    }
    if ((_selected = selected) && self.selectedHighlighted) {
        self.kLastColor = self.backgroundColor ? self.backgroundColor : [UIColor clearColor];
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        if (_kLastColor) {
            self.backgroundColor = _kLastColor;
            _kLastColor = nil;
        }
    }
}

- (void)prepareForReuse{
    
}
@end
#pragma mark ---------horizonView begin---------
const CGFloat MSPadHorizonViewWrapperViewZPosition = -0.1;

const CGFloat MSPadHorizonViewCellZPosition = -0.1; // cell的绘制层级
const CGFloat MSPadHorizonViewSectionViewZPositon = 0;
const CGFloat MSPadHorizonViewHeaderViewZPosition = 0;
const CGFloat MSPadHorizonViewRefreshViewZPosition = 0;

@interface MSPadHorizonView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    BOOL _isRefreshing;// 是否处于上下拉中
    
    BOOL _respond_scrollViewDidScroll,
    _respond_scrollViewDidZoom,
    _respond_scrollViewWillBeginDragging,
    _respond_scrollViewWillEndDraggingWithVelocityTargetContentOffset,
    _respond_scrollViewDidEndDraggingWillDecelerate,
    _respond_scrollViewWillBeginDecelerating,
    _respond_scrollViewDidEndDecelerating,
    _respond_scrollViewDidEndScrollingAnimation,
    _respond_viewForZoomingInScrollView,
    _respond_scrollViewWillBeginZoomingWithView,
    _respond_scrollViewDidEndZoomingWithViewAtScale,
    _respond_scrollViewShouldScrollToTop,
    _respond_scrollViewDidScrollToTop;
    
    BOOL _respond_readyForRefresh_header,
    _respond_hasRefresh_header,
    _respond_endRefresh_header,
    _respond_readyForRefresh_footer,
    _respond_hasRefresh_footer,
    _respond_endRefresh_footer;
    BOOL _respond_didRefresh;
}
// test
@property (nonatomic, strong) NSMutableArray *estimatedDrawInfoList;
@property (nonatomic, strong) NSMutableDictionary *estimatedDrawDic;
@end

@implementation MSPadHorizonView {
    UIView *_contentWrapperView;
    MSPadHorizonPos *_contentDrawArea; // cell/section header&footer的开始绘制点，因为有可能有个headerView
    MSPadHorizonPos *_currDrawArea; // 当前屏幕显示距离，去处header/footer
    NSRange _currCellRange, _currSectionRange; // 当前显示的cell范围
    NSRange _currContentRange; // test
    
    //CGFloat _preContentOffSetX;
    BOOL _layoutSubviewsLock;
    
    NSUInteger _currSuspendSectionHeaderDrawIndex, _currSuspendSectionFooterDrawIndex; // 当前悬浮的sectionHeader的位置
    NSUInteger _currSuspendHeaderSection, _currSuspendFooterSection; // 当前需要悬浮的section
    
    NSUInteger _preSelectedCellDrawIndex; // 当前选中的cell
    
    NSUInteger _numberOfSections;
    NSMutableArray *_cellDrawInfoList, *_sectionDrawInfoList;// cell/section位置讯息
    NSMutableDictionary *_cellDrawDic, *_sectionDrawDic;// 当前已经绘制的index对应的cell/section
    NSMutableArray *_sectionSuspendAreaList;// 每个section悬浮区域（header.end -> footer.begin）
    NSMutableDictionary *_reusableCellDic;// 存储准备reuse的NSSet，按identifier为key
    //
    BOOL _respond_numberOfSectionsInHorizonView,
    _respond_widthForIndexPath,
    
    _respond_widthForHeaderInSection,
    _respond_widthForFooterInSection,
    _respond_viewForHeaderInSection,
    _respond_viewForFooterInSection,
    
    _respond_estimatedWidthForColAtIndexPath,
    _respond_estimatedHeightForHeaderInSection,
    _respond_estimatedHeightForFooterInSection,
    
    _respond_didSelectCellAtIndexPath;
}

- (instancetype)initWithFrame:(CGRect)frame style:(MSPadHorizonViewStyle)style{
    if (self = [super initWithFrame:frame]) {
        _style = style;
        [self initData];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _style = MSPadHorizonViewStylePlain;
        [self initData];
    }
    return self;
}

- (void)initData{
    [self addSubview:_contentWrapperView = [UIView new]];
    _contentWrapperView.layer.zPosition = MSPadHorizonViewWrapperViewZPosition;
    
    _cellSpacing = 1;
    _colWidth = 0;
    [self layoutSubviewsLock];
    
    _reusableCellDic = [NSMutableDictionary new];
    _cellDrawDic = [NSMutableDictionary new];
    _cellDrawInfoList = [NSMutableArray new];
    _sectionDrawInfoList = [NSMutableArray new];
    _sectionDrawDic = [NSMutableDictionary new];
    
    _sectionSuspendAreaList = [NSMutableArray new];
    
    //    _estimatedDrawInfoList = [NSMutableArray new];
    //    _estimatedDrawDic = [NSMutableDictionary new];
    
    _currSuspendSectionFooterDrawIndex = _currSuspendSectionHeaderDrawIndex = NSNotFound;
    _currSuspendFooterSection = _currSuspendHeaderSection = NSNotFound;
    
    _isRefreshing = NO;
    _refreshHeaderOffset = _refreshFooterOffset = 0;
}
// 为了上下拉刷新的安全
- (void)setDelegate:(id<UIScrollViewDelegate>)delegate{
    if (_pullRefreshDelegate) {
        [super setDelegate:self];
    }else {
        [super setDelegate:delegate];
    }
}

#pragma mark --horizon delegate--
- (void)respondsToHorizonDelegate{
    _respond_numberOfSectionsInHorizonView = [self.horizonDelegate respondsToSelector:@selector(numberOfSectionsInHorizonView:)];
    _respond_widthForIndexPath = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:widthForIndexPath:)];
    
    _respond_widthForHeaderInSection = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:widthForHeaderInSection:)];
    _respond_widthForFooterInSection = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:widthForFooterInSection:)];
    _respond_viewForHeaderInSection = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:viewForHeaderInSection:)];
    _respond_viewForFooterInSection = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:viewForFooterInSection:)];
    
    //respond_estimatedWidthForColAtIndexPath = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:estimatedWidthForColAtIndexPath:)];
    //respond_estimatedHeightForHeaderInSection = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:estimatedWidthForHeaderInSection:)];
    //respond_estimatedHeightForFooterInSection = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:estimatedWidthForFooterInSection:)];
    
    _respond_didSelectCellAtIndexPath = [self.horizonDelegate respondsToSelector:@selector(MSPadHorizonView:didSelectCell:atIndexPath:)];
    
}

- (void)respondsToScrollViewDelegate{
    _respond_scrollViewDidScroll = [self.horizonDelegate respondsToSelector:@selector(scrollViewDidScroll:)];
    _respond_scrollViewDidZoom = [self.horizonDelegate respondsToSelector:@selector(scrollViewDidZoom:)];
    _respond_scrollViewWillBeginDragging = [self.horizonDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)];
    _respond_scrollViewWillEndDraggingWithVelocityTargetContentOffset = [self.horizonDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)];
    _respond_scrollViewDidEndDraggingWillDecelerate = [self.horizonDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)];
    _respond_scrollViewWillBeginDecelerating = [self.horizonDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)];
    _respond_scrollViewDidEndDecelerating = [self.horizonDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
    _respond_scrollViewDidEndScrollingAnimation = [self.horizonDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)];
    _respond_viewForZoomingInScrollView = [self.horizonDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)];
    _respond_scrollViewWillBeginZoomingWithView = [self.horizonDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)];
    _respond_scrollViewDidEndZoomingWithViewAtScale = [self.horizonDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)];
    _respond_scrollViewShouldScrollToTop = [self.horizonDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)];
    _respond_scrollViewDidScrollToTop = [self.horizonDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)];
}
#pragma mark --public--

- (void)setHorizonDelegate:(id<MSPadHorizonViewDelegate, UIScrollViewDelegate>)horizonDelegate{
    _horizonDelegate = horizonDelegate;
    [self respondsToHorizonDelegate];
    [self respondsToScrollViewDelegate];
    [self reloadData];
}

// 直接赋值或者协议指定section数
- (NSUInteger)numberOfSections{
    if (_numberOfSections == 0) {
        if (_respond_numberOfSectionsInHorizonView) {
            _numberOfSections = [self.horizonDelegate numberOfSectionsInHorizonView:self];
            NSAssert(_numberOfSections != 0, @"numberOfSections == 0");
        }else{
            _numberOfSections = 1;
        }
    }
    return _numberOfSections;
}

- (void)setNumberOfSections:(NSUInteger)numberOfSections{
    if (!_respond_numberOfSectionsInHorizonView) {
        _numberOfSections = numberOfSections;
    }
}

- (void)setColWidth:(CGFloat)colWidth{
    if (!_respond_widthForIndexPath) {
        _colWidth = colWidth;
    }
}

- (void)setCellSpacing:(CGFloat)cellSpacing{
    if (cellSpacing < 0) {
        cellSpacing = 0;
    }
    _cellSpacing = cellSpacing;
}

- (void)setHeaderView:(UIView *)headerView{
    if (headerView != _headerView) {
        [_headerView removeFromSuperview];
    }
    if ((headerView.superview && headerView.superview != _contentWrapperView) || headerView == self.footerView) {
        return;
    }
    _headerView = headerView;
}

- (void)setFooterView:(UIView *)footerView{
    if (footerView != _footerView) {
        [_footerView removeFromSuperview];
    }
    if ((footerView.superview && footerView.superview != _contentWrapperView) || footerView == self.headerView) {
        return;
    }
    _footerView = footerView;
}
// 主动调用来提取复用的
- (id)horizonReusableCellWithIdentifier:(NSString *)identifier{
    MSPadHorizonCell *result = nil;
    if (!identifier) {
        identifier = MSPadHorizonReuseIdentifierDefault;
    }
    NSMutableSet *queue = [_reusableCellDic objectForKey:identifier];
    if (queue.count) {
        result = [queue anyObject];
        [queue removeObject:result];
    }
    return result;
}

- (MSPadHorizonCell*)cellForColAtIndexPath:(MPIndexPath *)indexPath{
    MSPadHorizonCell *result = nil;
    NSUInteger resultIndex = NSNotFound;
    for (NSUInteger i = _currCellRange.location; i < NSMaxRange(_currCellRange); i++) {
        MSPadHorizonCellPos *pos = _cellDrawInfoList[i];
        if ([pos.indexPath isEqualIndexPath:indexPath]) {
            resultIndex = i;
            break;
        }
    }
    result = [_cellDrawDic objectForKey:@(resultIndex)];
    return result;
}

- (NSArray*)visibleCells{
    //    NSMutableArray *result = [NSMutableArray new];
    //    for (NSUInteger i = currCellRange.location; i < currCellRange.location + currCellRange.length; i++) {
    //        MSPadHorizonCell *cell = [cellDrawDic objectForKey:@(i)];
    //        [result addObject:cell];
    //    }
    return _cellDrawDic.allValues;
}

- (NSArray*)indexPathsForVisibleCols{
    NSMutableArray *result = [NSMutableArray new];
    for (NSUInteger i = _currCellRange.location; i < _currCellRange.location + _currCellRange.length; i++) {
        MSPadHorizonCellPos *pos = _cellDrawInfoList[i];
        [result addObject:pos.indexPath];
    }
    return [result copy];
}

- (NSInteger)getSectionDrawIndexFrom:(MPIndexPath*)indexPath {
    return [_sectionDrawInfoList indexOfObjectBinarySearch:^MP_SEARCH_CASE(MSPadHorizonSectionPos *sectionPos, NSUInteger index, BOOL *stop) {
        if (sectionPos.section > indexPath.section) {
            return MP_SEARCH_LOW;
        }else if (sectionPos.section < indexPath.section) {
            return MP_SEARCH_HIGH;
        }else {
            return MP_SEARCH_EQUAL;
        }
    }];
}

- (MPIndexPath *)getColDrawIndexFrom:(MPIndexPath*)indexPath {
    NSUInteger index = [_cellDrawInfoList indexOfObjectBinarySearch:^MP_SEARCH_CASE(MSPadHorizonCellPos *cellPos, NSUInteger index, BOOL *stop) {
        if (cellPos.indexPath.section > indexPath.section) {
            return MP_SEARCH_LOW;
        }else if (cellPos.indexPath.section < indexPath.section){
            return MP_SEARCH_HIGH;
        }else{
            if (cellPos.indexPath.col > indexPath.col) {
                return MP_SEARCH_LOW;
            }else if (cellPos.indexPath.col < indexPath.col){
                return MP_SEARCH_HIGH;
            }else{
                return MP_SEARCH_EQUAL;
            }
        }
    }];
    if (index != NSNotFound) {
        MSPadHorizonCellPos *pos = _cellDrawInfoList[index];
        return pos.indexPath;
    }else {
        return nil;
    }
}

- (void)scrollToColAtIndexPath:(MPIndexPath *)indexPath atScrollPosition:(MSPadHorizonViewScrollPosition)scrollPosition animated:(BOOL)animated{
    if (indexPath.section >= self.numberOfSections) {
        return;
    }
    MPIndexPath *drawIndex = [self getColDrawIndexFrom:indexPath];
    NSAssert(drawIndex, @"an non-existent indexPath");
    
    MSPadHorizonCellPos *cellPos = _cellDrawInfoList[drawIndex.col];
    CGFloat _contentOffsetX = 0;
    switch (scrollPosition) {
        case MSPadHorizonViewScrollPositionLeft:{
            _contentOffsetX = cellPos.beginPos;
            if (_respond_widthForHeaderInSection && self.style == MSPadHorizonViewStylePlain) {
                MSPadHorizonSectionArea *area = _sectionSuspendAreaList[cellPos.indexPath.section];
                MSPadHorizonSectionPos *sectionPos = _sectionDrawInfoList[area.headerDrawIndex];
                _contentOffsetX -= sectionPos.endPos - sectionPos.beginPos;
            }
        }
            break;
        case MSPadHorizonViewScrollPositionMiddle:
            _contentOffsetX = cellPos.beginPos + (cellPos.endPos - cellPos.beginPos) / 2 - self.frame.size.width / 2;
            break;
        case MSPadHorizonViewScrollPositionRight:{
            _contentOffsetX = cellPos.endPos - self.frame.size.width;
            if (_respond_widthForFooterInSection && self.style == MSPadHorizonViewStylePlain) {
                MSPadHorizonSectionArea *area = _sectionSuspendAreaList[cellPos.indexPath.section];
                MSPadHorizonSectionPos *sectionPos = _sectionDrawInfoList[area.footerDrawIndex];
                _contentOffsetX += sectionPos.endPos - sectionPos.beginPos;
            }
        }break;
    }
    if (_contentOffsetX + self.frame.size.width > self.contentSize.width) {
        _contentOffsetX = self.contentSize.width - self.frame.size.width;
    }
    [self setContentOffset:CGPointMake(_contentOffsetX, 0) animated:animated];
}

- (void)translationalAnimationInCells:(NSIndexSet *)cellIndexSet andSections:(NSIndexSet *)sectionIndexSet {
    [UIView animateWithDuration:0.3 animations:^{
        if (cellIndexSet.count) {
            [_cellDrawDic enumerateKeysAndObjectsUsingBlock:^(id key, MSPadHorizonCell *obj, BOOL *stop) {
                NSUInteger index = [key unsignedIntegerValue];
                if (![cellIndexSet containsIndex:index]) {
                    MSPadHorizonPos *cellPos = _cellDrawInfoList[index];
                    CGRect frame = obj.frame;
                    frame.origin.x = cellPos.beginPos;
                    obj.frame = frame;
                }else {
                    [obj removeFromSuperview];
                    [_cellDrawDic removeObjectForKey:key];
                }
            }];
        }
        [self drawContentSections];
        if (self.footerView) {
            CGRect frame = self.footerView.frame;
            frame.origin.x = self.contentSize.width - frame.size.width;
            self.footerView.frame = frame;
        }
        if (self.refreshFooter) {
            CGRect frame = self.refreshFooter.frame;
            frame.origin.x = self.contentSize.width;
            self.refreshFooter.frame = frame;
        }
    } completion:^(BOOL finished) {
        if (cellIndexSet) [_cellDrawInfoList removeObjectsAtIndexes:cellIndexSet];
        if (sectionIndexSet) [_sectionDrawInfoList removeObjectsAtIndexes:sectionIndexSet];
    }];
}
#pragma mark --reload
//
- (void)clear{
    [self preSelectedCellReset];
    
    [self layoutSubviewsLock];
    //_preContentOffSetX = -CGFLOAT_MAX;
    _contentDrawArea = [MSPadHorizonPos posWithBegin:0 andEnd:0];
    _currDrawArea = [MSPadHorizonPos posWithBegin:0 andEnd:0];
    _preSelectedCellDrawIndex = NSNotFound;
    _currCellRange = NSMakeRange(0, 0);
    _currSectionRange = NSMakeRange(0, 0);
    _currContentRange = NSMakeRange(0, 0);
    _numberOfSections = 0;
    
    [self clearCellsData];
    [self clearSectionData];
    
    if (self.style == MSPadHorizonViewStylePlain) {
        [self clearSuspendSectionData];
    }
}

- (void)clearCellsData{
    [_cellDrawInfoList removeAllObjects];
    [_cellDrawDic enumerateKeysAndObjectsUsingBlock:^(id key, MSPadHorizonCell *obj, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [_cellDrawDic removeAllObjects];
    
    [_reusableCellDic enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableSet *queue, BOOL *stop) {
        for (MSPadHorizonCell *cell in queue) {
            [cell removeFromSuperview];
        }
        [queue removeAllObjects];
    }];
    [_reusableCellDic removeAllObjects];
}

- (void)clearSectionData{
    [_sectionDrawInfoList removeAllObjects];
    
    [_sectionDrawDic enumerateKeysAndObjectsUsingBlock:^(id key, UIView *obj, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [_sectionDrawDic removeAllObjects];
}

- (void)clearSuspendSectionData{
    _currSuspendSectionFooterDrawIndex = _currSuspendSectionHeaderDrawIndex = NSNotFound;
    _currSuspendFooterSection = _currSuspendHeaderSection = NSNotFound;
    [_sectionSuspendAreaList removeAllObjects];
}

- (void)reloadData{
    if ([NSRunLoop currentRunLoop] != [NSRunLoop mainRunLoop]) {
        return [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    
    [self clear];
    CGFloat step = 0;
    if (self.headerView) {
        _contentDrawArea.beginPos = step = self.headerView.frame.size.width;
        CGRect frame = self.headerView.frame;
        frame.origin.x = frame.origin.y = 0;
        self.headerView.frame = frame;
        if (self.headerView.superview != _contentWrapperView || !self.headerView.superview) {
            [_contentWrapperView addSubview:self.headerView];
        }
    }
    step = [self initDrawFixedInfoAt:step];
    _contentDrawArea.endPos = step;
    if (self.footerView) {
        CGRect frame = self.footerView.frame;
        frame.origin.y = 0;
        if (step <= CGRectGetMaxX(self.headerView.frame)) { // 如果中间一个玩意也没有
            frame.origin.x = CGRectGetMaxX(self.headerView.frame);
        }else{
            frame.origin.x = step;
        }
        self.footerView.frame = frame;
        if (self.footerView.superview != _contentWrapperView || !self.footerView.superview) {
            [_contentWrapperView addSubview:self.footerView];
        }
        step += frame.size.width;
    }
    if (_cellDrawInfoList.count || _sectionDrawInfoList.count) {
        [self layoutSubviewsUnlock];
    }
    // 多0.5像素保证可以滚动，并且拉动刷新的坐标计算也不会偏差太多
    if (step < self.frame.size.width + 0.5) {
        step = self.frame.size.width + 0.5;
    }
    [self setContentSize:CGSizeMake(step, self.frame.size.height)];
    if (!CGSizeEqualToSize(self.contentSize, _contentWrapperView.frame.size)) {
        _contentWrapperView.frame = CGRectMake(0, 0, step, self.contentSize.height);
    }else {
        [self layoutSubviews];
    }
    // 有可能两次显示同样的cell，那么需要手动刷新
    // 上下拉头
    if (self.pullRefreshDelegate) {
        CGRect frameTemp = self.refreshHeader.frame;
        frameTemp.origin.x = -frameTemp.size.width;
        self.refreshHeader.frame = frameTemp;
        
        frameTemp = self.refreshFooter.frame;
        frameTemp.origin.x = self.contentSize.width;
        self.refreshFooter.frame = frameTemp;
    }
    if (_isRefreshing) {
        [self finishRefresh];
    }
}

- (CGFloat)initDrawFixedInfoAt:(CGFloat)startStep{
    CGFloat step = startStep;
    // 计算存储所有子视图的位置
    for (NSInteger i = 0; i < self.numberOfSections; i++) {
        MSPadHorizonSectionArea *area = nil;
        if (self.style == MSPadHorizonViewStylePlain) {
            area = [MSPadHorizonSectionArea new];
        }
        // header
        if (_respond_widthForHeaderInSection) {
            CGFloat width = [self.horizonDelegate MSPadHorizonView:self widthForHeaderInSection:i];
            MSPadHorizonSectionPos *sectionInfo = [MSPadHorizonSectionPos posWithBegin:step andEnd:step + width];
            sectionInfo.section = i;
            sectionInfo.sectionType = MPSECTION_HEADER;
            [_sectionDrawInfoList addObject:sectionInfo];
            step = sectionInfo.endPos;
            area.headerDrawIndex = _sectionDrawInfoList.count - 1;
        }
        area.beginPos = step;
        // cell的位置
        // 这section有几个col
        NSUInteger colsInSection = [self.horizonDelegate MSPadHorizonView:self numberOfColsInSection:i];
        for (NSInteger j = 0; j < colsInSection; j++) {
            MPIndexPath *indexPath = [MPIndexPath indexPathWithSection:i andCol:j];
            CGFloat cellWidth = _respond_widthForIndexPath ? [self.horizonDelegate MSPadHorizonView:self widthForIndexPath:indexPath] : self.colWidth;
            MSPadHorizonCellPos *info = [MSPadHorizonCellPos posWithBegin:step andEnd:step + cellWidth];
            info.indexPath = indexPath;
            step += cellWidth + _cellSpacing;
            [_cellDrawInfoList addObject:info];
        }
        area.endPos = step;
        // footer
        if (_respond_widthForFooterInSection) {
            CGFloat width = [self.horizonDelegate MSPadHorizonView:self widthForFooterInSection:i];
            MSPadHorizonSectionPos *sectionInfo = [MSPadHorizonSectionPos posWithBegin:step andEnd:step + width];
            sectionInfo.sectionType = MPSECTION_FOOTER;
            sectionInfo.section = i;
            [_sectionDrawInfoList addObject:sectionInfo];
            area.footerDrawIndex = _sectionDrawInfoList.count - 1;
            step = sectionInfo.endPos;
        }
        if (area) {
            [_sectionSuspendAreaList addObject:area];
        }
    }
    return step;
}

#pragma mark --更替---------------------------------------------------------------------

- (BOOL)isLayoutSubviewsLock {
    return _layoutSubviewsLock;
}

- (void)layoutSubviewsLock {
    _layoutSubviewsLock = YES;
}

- (void)layoutSubviewsUnlock {
    _layoutSubviewsLock = NO;
}

- (void)getCurrContentArea{
    _currDrawArea.beginPos = self.contentOffset.x;
    _currDrawArea.endPos = _currDrawArea.beginPos + self.frame.size.width;
    if (_currDrawArea.endPos > _contentDrawArea.endPos) {// 如果是滑动到最右，那么可视区域会变小
        _currDrawArea.endPos = _contentDrawArea.endPos;
    }
    if (_currDrawArea.beginPos < _contentDrawArea.beginPos) { // 如果小于开始绘制点
        _currDrawArea.beginPos = _contentDrawArea.beginPos;
    }
}
#pragma mark --cell--
// 计算当前显示的cell们的range
- (NSRange)getCurrCellRange {
    NSUInteger cellCount = _cellDrawInfoList.count;
    if (cellCount == 0) {
        return NSMakeRange(0, 0);
    }
    NSUInteger middle = [_cellDrawInfoList mp_indexOfObjectBinarySearch:^MP_SEARCH_CASE(MSPadHorizonCellPos *pos) {
        if (pos.beginPos > _currDrawArea.endPos) {
            return MP_SEARCH_LOW;
        }else if (pos.endPos + _cellSpacing < _currDrawArea.beginPos) {
            return MP_SEARCH_HIGH;
        }else{
            return MP_SEARCH_EQUAL;
        }
    }];
    
    NSUInteger start = middle, end = middle;
    while (start > 0) {
        MSPadHorizonPos *pos = _cellDrawInfoList[start - 1];
        if (pos.endPos + _cellSpacing < _currDrawArea.beginPos) {
            break;
        }else {
            start--;
        }
    }
    NSUInteger endIndex = cellCount - 1;
    while (end < endIndex) {
        MSPadHorizonPos *pos = _cellDrawInfoList[end + 1];
        if (pos.beginPos > _currDrawArea.endPos) {
            break;
        }else {
            end++;
        }
    }
    if (start == middle && end == middle) {
        MSPadHorizonPos *pos = _cellDrawInfoList[middle];
        if (pos.beginPos > _currDrawArea.endPos || pos.endPos + _cellSpacing < _currDrawArea.beginPos) {
            return NSMakeRange(0, 0);
        }
    }
    return NSMakeRange(start, end - start + 1);
}
// 算出当前区域中有没存在的cell，remove掉
bool intersectPositions(MSPadHorizonPos *first, MSPadHorizonPos *second) {
    return !(first.endPos <= second.beginPos || first.beginPos >= second.endPos);
}
- (void)removeOverlappedViewWithPos:(MSPadHorizonPos*)pos {
    for (UIView *subview in _contentWrapperView.subviews) {
        //        if (intersectPositions(pos, [MSPadHorizonPos posWithBegin:subview.frame.origin.x andEnd:CGRectGetMaxX(subview.frame)])) {
        //            if(subview.frame.origin.y == 0/*[subview isKindOfClass:[MSPadHorizonCell class]]*/) { // 防止把滚动条remove了
        //                [subview removeFromSuperview];
        //                break;
        //            }
        //        }
        //        return;
        if (subview.frame.origin.x == pos.beginPos || CGRectGetMaxX(subview.frame) == pos.endPos) {
            if(subview.frame.origin.y == 0/*[subview isKindOfClass:[MSPadHorizonCell class]]*/) { // 防止把滚动条remove了
                [subview removeFromSuperview];
                break;
            }
        }
    }
}
// range求差
NSRange MPSubtractionRange(NSRange subtrahend, NSRange minuend) {
    if (subtrahend.length == minuend.length) {
        return NSMakeRange(0, 0);
    }
    if (minuend.length == 0) {
        return subtrahend;
    }
    return NSMakeRange((subtrahend.location == minuend.location) ? NSMaxRange(minuend) : subtrahend.location, subtrahend.length - minuend.length);
}

- (void)drawContentCells {
    NSRange range = [self getCurrCellRange];
    // 如果跟上次处于同一个显示范围就不要重绘，即显示的视图范围没有变化
    if (NSEqualRanges(_currCellRange, range)) {
        return;
    }
    [_cellDrawDic enumerateKeysAndObjectsUsingBlock:^(id key, MSPadHorizonCell *cell, BOOL *stop) {
        NSUInteger i = [key unsignedIntegerValue];
        if (outofRange(i, _currCellRange)) {
            NSMutableSet *queue = [_reusableCellDic objectForKey:cell.identifier];
            if (!queue) {
                queue = [NSMutableSet new];
                [_reusableCellDic setObject:queue forKey:cell.identifier];
            }
            [queue addObject:cell];
            [_cellDrawDic removeObjectForKey:@(i)];
            [cell prepareForReuse];
        }
    }];
    
    NSRange preCellRange = _currCellRange;
    _currCellRange = range;
    range = NSIntersectionRange(preCellRange, _currCellRange);
    NSRange drawRange = MPSubtractionRange(_currCellRange, range);
    // 绘制当前cell
    for (NSInteger i = drawRange.location; i < NSMaxRange(drawRange); i++) {
        MSPadHorizonCellPos *info = _cellDrawInfoList[i];
        // 在此剔除重叠视图，在之前的入队cell操作并未将cell剔除——因为很多情况下是不会导致重叠，实测在这边进行遍历计算重叠性能更快，因为self同一时间的subviews并不多
        [self removeOverlappedViewWithPos:info];
        MSPadHorizonCell *cell = [self.horizonDelegate MSPadHorizonView:self cellForColAtIndexPath:info.indexPath];
        CGRect frame = cell.frame;
        frame.origin.x = info.beginPos;
        frame.size.width = info.endPos - info.beginPos;
        // cell刚被创建并非重用出来的
        if (!cell.kHadUsed) {
            frame.size.height = self.frame.size.height;
            cell.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCell:)];
            tap.delegate = self;
            [cell addGestureRecognizer:tap];
            cell.layer.zPosition = MSPadHorizonViewCellZPosition;
            cell.kHadUsed = YES;
        }
        cell.frame = frame;
        if (![cell superview] || cell.superview != _contentWrapperView) {
            [_contentWrapperView addSubview:cell];
        }
        cell.kDrawIndex = i;
        // 选中状态判断
        if (_preSelectedCellDrawIndex == i) {
            [cell setSelected:YES];
        }else{
            [cell setSelected:NO];
        }
        // 记录cell为已绘制
        [_cellDrawDic setObject:cell forKey:@(i)];
    }
}
#pragma mark --section
// 当前section header & footer
- (NSRange)getCurrSectionRange{
    NSUInteger sectionCount = _sectionDrawInfoList.count;
    if (sectionCount == 0) {
        return NSMakeRange(0, 0);
    }
    NSUInteger middle = [_sectionDrawInfoList mp_indexOfObjectBinarySearch:^MP_SEARCH_CASE(MSPadHorizonPos *pos) {
        if (pos.beginPos > _currDrawArea.endPos) {
            return MP_SEARCH_LOW;
        }else if (pos.endPos < _currDrawArea.beginPos) {
            return MP_SEARCH_HIGH;
        }else{
            return MP_SEARCH_EQUAL;
        }
    }];
    
    NSUInteger start = middle, end = middle;
    while (start > 0) {
        MSPadHorizonPos *pos = _sectionDrawInfoList[start - 1];
        if (pos.endPos < _currDrawArea.beginPos) {
            break;
        }else{
            start--;
        }
    }
    while (end < sectionCount - 1) {
        MSPadHorizonPos *pos = _sectionDrawInfoList[end + 1];
        if (pos.beginPos > _currDrawArea.endPos) {
            break;
        }else{
            end++;
        }
    }
    if (start == middle && middle == end) {
        MSPadHorizonPos *pos = _sectionDrawInfoList[middle];
        if (pos.beginPos > _currDrawArea.endPos || pos.endPos < _currDrawArea.beginPos) {
            return NSMakeRange(0, 0);
        }
    }
    return NSMakeRange(start, end - start + 1);
}

NS_INLINE BOOL outofRange(NSUInteger target, NSRange range){
    return (target < range.location || target > range.location + range.length - 1) || range.length < 1;
}

NS_INLINE BOOL MPNotEqualRanges(NSRange range1, NSRange range2){
    return range1.location != range2.location || range1.length != range2.length;
}

#define mp_size_count(_x_) sizeof(_x_) / sizeof(_x_[0])

bool insideOfArray(NSUInteger target, const NSUInteger *array, NSUInteger count){
    for (NSUInteger i = 0; i < count; i++) {
        if (target == array[i]) {
            return YES;
        }
    }
    return NO;
}

- (void)drawContentSections{
    NSRange range = [self getCurrSectionRange];
    if (self.style == MSPadHorizonViewStylePlain) {
        [self suspendCurrSection:range];
    }
    if (MPNotEqualRanges(_currSectionRange, range)) {
        [_sectionDrawDic enumerateKeysAndObjectsUsingBlock:^(id key, UIView *section, BOOL *stop) {
            if (section.frame.origin.x > _currDrawArea.endPos || CGRectGetMaxX(section.frame) < _currDrawArea.beginPos) {
                NSUInteger index = [key unsignedIntegerValue];
                if (index != _currSuspendSectionHeaderDrawIndex && index != _currSuspendSectionFooterDrawIndex) {
                    [section removeFromSuperview];
                    [_sectionDrawDic removeObjectForKey:@(index)];
                }
            }
        }];
        NSRange preRange = _currSectionRange;
        _currSectionRange = range;
        NSRange intersectionRange = NSIntersectionRange(_currSectionRange, preRange);
        NSRange drawRange = MPSubtractionRange(_currSectionRange, intersectionRange);
        
        NSArray *temp = _sectionDrawDic.allKeys;
        NSUInteger count = 0;
        NSUInteger just[temp.count];
        for (id index in temp) {
            just[count++] = [index unsignedIntegerValue];
        }
        for (NSUInteger i = drawRange.location; i < NSMaxRange(drawRange); i++) {
            //            if (i == currSuspendSectionHeaderDrawIndex || i == currSuspendSectionFooterDrawIndex) {
            //                continue;
            //            }
            if (insideOfArray(i, just, count)) {
                continue;
            }
            [self drawSctionViewAtIndex:i];
        }
    }
}
// 绘制sectionview
- (UIView*)drawSctionViewAtIndex:(NSUInteger)index{
    MSPadHorizonSectionPos *pos = _sectionDrawInfoList[index];
    UIView *sectionView = nil;
    if (pos.sectionType == MPSECTION_HEADER) {
        if (_respond_viewForHeaderInSection) {
            sectionView = [self.horizonDelegate MSPadHorizonView:self viewForHeaderInSection:pos.section];
        }
    }else{
        if (_respond_viewForFooterInSection) {
            sectionView = [self.horizonDelegate MSPadHorizonView:self viewForFooterInSection:pos.section];
        }
    }
    if (sectionView) {
        CGRect frame = sectionView.frame;
        frame.origin.x = pos.beginPos;
        frame.origin.y = 0;
        frame.size.width = pos.endPos - pos.beginPos;
        frame.size.height = self.frame.size.height;
        sectionView.frame = frame;
        sectionView.layer.zPosition = MSPadHorizonViewSectionViewZPositon;
        [_contentWrapperView addSubview:sectionView];
        [_sectionDrawDic setObject:sectionView forKey:@(index)];
    }
    return sectionView;
}

// 悬浮
- (void)suspendCurrSection:(NSRange)range {
    if (!_sectionDrawInfoList.count) {
        return;
    }
    NSUInteger startSection = NSNotFound, endSection = NSNotFound;
    if (range.length) {
        MSPadHorizonSectionPos *startSectionPos = _sectionDrawInfoList[range.location];
        MSPadHorizonSectionPos *endSectionPos = startSectionPos;
        if (range.length > 1) {
            endSectionPos = _sectionDrawInfoList[NSMaxRange(range) - 1];
        }
        startSection = startSectionPos.section;
        endSection = endSectionPos.section;
    }
    
    if (_currCellRange.length) {
        MSPadHorizonCellPos *cellStartPos = _cellDrawInfoList[_currCellRange.location];
        if (cellStartPos.indexPath.section < startSection) {
            startSection = cellStartPos.indexPath.section;
        }
        MSPadHorizonCellPos *cellEndPos = cellStartPos;
        if (_currCellRange.length > 1) {
            cellEndPos = _cellDrawInfoList[NSMaxRange(_currCellRange) - 1];
        }
        if (cellEndPos.indexPath.section > endSection || endSection == NSNotFound) {
            endSection = cellEndPos.indexPath.section;
        }
    }
    if (startSection == NSNotFound /* || endSection == NSNotFound */) {
        return;
    }
    NSUInteger headerDrawIndex = NSNotFound, footerDrawIndex = NSNotFound;
    MSPadHorizonSectionArea *startArea = _sectionSuspendAreaList[startSection];
    MSPadHorizonSectionArea *endArea = startArea;
    headerDrawIndex = startArea.headerDrawIndex;
    footerDrawIndex = startArea.footerDrawIndex;
    if (startSection != endSection) {
        endArea = _sectionSuspendAreaList[endSection];
        footerDrawIndex = endArea.footerDrawIndex;
    }
    
    if (_respond_widthForHeaderInSection) {
        if (_currSuspendHeaderSection != startSection) {
            if (_currSuspendHeaderSection != NSNotFound) {
                UIView * header = [_sectionDrawDic objectForKey:@(_currSuspendSectionHeaderDrawIndex)];
                MSPadHorizonSectionArea *preStartArea = _sectionSuspendAreaList[_currSuspendHeaderSection];
                CGRect frame = header.frame;
                if (preStartArea.beginPos >= _currDrawArea.beginPos && preStartArea.beginPos - frame.size.width <= _currDrawArea.endPos) {
                    if (frame.origin.x != preStartArea.beginPos - frame.size.width) {
                        frame.origin.x = preStartArea.beginPos - frame.size.width;
                        header.frame = frame;
                    }
                }else{
                    [header removeFromSuperview];
                    [_sectionDrawDic removeObjectForKey:@(_currSuspendSectionHeaderDrawIndex)];
                }
            }
            _currSuspendSectionHeaderDrawIndex = headerDrawIndex;
            _currSuspendHeaderSection = startSection;
        }
        [self suspendSectionHeader:headerDrawIndex atArea:startArea];
    }
    
    if (_respond_widthForFooterInSection) {
        if (_currSuspendFooterSection != endSection) {
            if (_currSuspendFooterSection != NSNotFound) {
                UIView * footer = [_sectionDrawDic objectForKey:@(_currSuspendSectionFooterDrawIndex)];
                MSPadHorizonSectionArea *preEndArea = _sectionSuspendAreaList[_currSuspendFooterSection];
                CGRect frame = footer.frame;
                if (preEndArea.endPos <= _currDrawArea.endPos && preEndArea.endPos + frame.size.width >= _currDrawArea.beginPos) {
                    if (frame.origin.x != preEndArea.endPos) {
                        frame.origin.x = preEndArea.endPos;
                        footer.frame = frame;
                    }
                }else{
                    [footer removeFromSuperview];
                    [_sectionDrawDic removeObjectForKey:@(_currSuspendSectionFooterDrawIndex)];
                }
            }
            _currSuspendSectionFooterDrawIndex = footerDrawIndex;
            _currSuspendFooterSection = endSection;
        }
        [self suspendSectionFooter:footerDrawIndex atArea:endArea];
    }
}

- (void)suspendSectionHeader:(NSUInteger)headerDrawIndex atArea:(MSPadHorizonSectionArea*)startArea{
    if (_currDrawArea.beginPos <= startArea.endPos) {
        UIView *header = [_sectionDrawDic objectForKey:@(headerDrawIndex)];
        if (!header && headerDrawIndex != NSNotFound) {
            header = [self drawSctionViewAtIndex:headerDrawIndex];
        }
        if (!header) {
            return;
        }
        CGRect frame = header.frame;
        frame.origin.x = _currDrawArea.beginPos;
        if (frame.origin.x + frame.size.width > startArea.endPos) {
            if (frame.origin.x != startArea.endPos - frame.size.width) {
                frame.origin.x = startArea.endPos - frame.size.width;
            }
        }
        if (frame.origin.x + frame.size.width < startArea.beginPos) {
            if (frame.origin.x != startArea.beginPos - frame.size.width) {
                frame.origin.x = startArea.beginPos - frame.size.width;
            }
        }
        header.frame = frame;
    }
}

- (void)suspendSectionFooter:(NSUInteger)footerDrawIndex atArea:(MSPadHorizonSectionArea*)endArea{
    if (_currDrawArea.endPos >= endArea.beginPos) {
        UIView *footer = [_sectionDrawDic objectForKey:@(footerDrawIndex)];
        if (!footer && footerDrawIndex != NSNotFound) {
            footer = [self drawSctionViewAtIndex:footerDrawIndex];
        }
        if (!footer) {
            return;
        }
        CGRect frame = footer.frame;
        frame.origin.x = _currDrawArea.endPos - frame.size.width;
        if (frame.origin.x < endArea.beginPos) {
            if (frame.origin.x != endArea.beginPos) {
                frame.origin.x = endArea.beginPos;
            }
        }
        if (frame.origin.x > endArea.endPos) {
            if (frame.origin.x != endArea.endPos) {
                frame.origin.x = endArea.endPos;
            }
        }
        footer.frame = frame;
    }
}

#pragma mark --layoutSubviews--
- (void)updateCurrContent:(BOOL)animated{
    if (!self.horizonDelegate) {
        return;
    }
    _currDrawArea.beginPos = self.contentOffset.x;
    _currDrawArea.endPos = _currDrawArea.beginPos + self.frame.size.width;
    if (_currDrawArea.endPos > _contentDrawArea.endPos) {// 如果是滑动到最右，那么可视区域会变小
        _currDrawArea.endPos = _contentDrawArea.endPos;
    }
    if (_currDrawArea.beginPos < _contentDrawArea.beginPos) { // 如果小于开始绘制点
        _currDrawArea.beginPos = _contentDrawArea.beginPos;
    }
    [self getCurrContentArea];
    if (animated) {
        return [UIView animateWithDuration:0.3 animations:^{
            [self drawContentCells];
            [self drawContentSections];
        }];
    }
    [self drawContentCells];
    [self drawContentSections];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (![self isLayoutSubviewsLock]) {
        [self updateCurrContent:NO];
    }
}
#pragma mark --更替 end---------------------------------------------------------------------

#pragma mark --选中cell
- (void)preSelectedCellReset{
    MSPadHorizonCell *preSelectedCell = [_cellDrawDic objectForKey:@(_preSelectedCellDrawIndex)];
    [preSelectedCell setSelected:NO];
}

- (void)selectCell:(UITapGestureRecognizer*)tap{
    if (_respond_didSelectCellAtIndexPath) {
        [self preSelectedCellReset];
        MSPadHorizonCell *cell = (MSPadHorizonCell*)tap.view;
        [cell setSelected:YES];
        _preSelectedCellDrawIndex = cell.kDrawIndex;
        MSPadHorizonCellPos *pos = _cellDrawInfoList[_preSelectedCellDrawIndex];
        [self.horizonDelegate MSPadHorizonView:self didSelectCell:cell atIndexPath:pos.indexPath];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer.view isKindOfClass:[MSPadHorizonCell class]]) {
        return YES;
    }
    return YES;
}

#pragma mark --左右拉刷新
const CGFloat MSPadHorizonViewAnimationEdgeZero = 0.3; // 结束左右拉，视图复原的动画时间
const CGFloat MSPadHorizonViewAnimationEdge = 0.5; // 开始左右拉的时候，定位contentInset到左右拉头位置的动画时间

- (void)setPullRefreshDelegate:(id<MSPadHorizonViewPullRefreshDelegate>)pullRefreshDelegate{
    if ((_pullRefreshDelegate = pullRefreshDelegate)) {
        self.delegate = self;
        _respond_didRefresh = [_pullRefreshDelegate respondsToSelector:@selector(MSPadHorizonView:didRefresh:)];
    }
    self.refreshHeader.hidden = self.refreshFooter.hidden = !_pullRefreshDelegate;
}

- (void)respondsToRefreshHeader{
    _respond_readyForRefresh_header = [self.refreshHeader respondsToSelector:@selector(readyForRefresh:)];
    _respond_hasRefresh_header = [self.refreshHeader respondsToSelector:@selector(hasRefresh:)];
    _respond_endRefresh_header = [self.refreshHeader respondsToSelector:@selector(endRefresh:)];
}

- (void)respondsToRefreshFooter{
    _respond_readyForRefresh_footer = [self.refreshFooter respondsToSelector:@selector(readyForRefresh:)];
    _respond_hasRefresh_footer = [self.refreshFooter respondsToSelector:@selector(hasRefresh:)];
    _respond_endRefresh_footer = [self.refreshFooter respondsToSelector:@selector(endRefresh:)];
}

- (void)setRefreshHeader:(UIView<MSPadHorizonRefreshViewDelegate> *)refreshHeader{
    if (!refreshHeader) {
        if (_refreshHeader) {
            [_refreshHeader removeFromSuperview];
        }
        _refreshHeader = nil;
        return;
    }
    if (!self.refreshHeaderOffset) {
        self.refreshHeaderOffset = refreshHeader.frame.size.width;
    }
    [_contentWrapperView addSubview:_refreshHeader = refreshHeader];
    _refreshHeader.layer.zPosition = MSPadHorizonViewRefreshViewZPosition;
    CGRect frame = _refreshHeader.frame;
    frame.origin.y = 0;
    frame.origin.x = -frame.size.width;
    _refreshHeader.frame = frame;
    [self respondsToRefreshHeader];
}

- (void)setRefreshFooter:(UIView<MSPadHorizonRefreshViewDelegate> *)refreshFooter{
    if (!refreshFooter) {
        if (_refreshFooter) {
            [_refreshFooter removeFromSuperview];
        }
        _refreshFooter = nil;
        return;
    }
    if (!self.refreshFooterOffset) {
        self.refreshFooterOffset = refreshFooter.frame.size.width;
    }
    [_contentWrapperView addSubview:_refreshFooter = refreshFooter];
    _refreshFooter.layer.zPosition = MSPadHorizonViewRefreshViewZPosition;
    CGRect frame = _refreshFooter.frame;
    frame.origin.y = 0;
    frame.origin.x = self.contentSize.width;
    _refreshFooter.frame = frame;
    [self respondsToRefreshFooter];
}

- (void)horizonViewDidScroll {
    if (_pullRefreshDelegate) {
        CGFloat contentOffSetX = self.contentOffset.x;
        if (!_isRefreshing) {
            if (contentOffSetX < 0 && self.refreshHeader && fabs(contentOffSetX) > self.refreshHeaderOffset) {
                if (_respond_readyForRefresh_header) {
                    [self.refreshHeader readyForRefresh:self];
                }
            }else if ((contentOffSetX - self.refreshFooterOffset >= self.contentSize.width - self.frame.size.width) && self.refreshFooter){
                if (_respond_readyForRefresh_footer) {
                    [self.refreshFooter readyForRefresh:self];
                }
            }else{
                if (self.refreshHeader) {
                    if (_respond_endRefresh_header) {
                        [self.refreshHeader endRefresh:self];
                    }
                }
                if (self.refreshFooter) {
                    if (_respond_endRefresh_footer) {
                        [self.refreshFooter endRefresh:self];
                    }
                }
            }
        }
    }
}

- (void)horizonDidEndDraggingWillDecelerate:(BOOL)decelerate {
    if (self.pullRefreshDelegate) {
        CGFloat contentOffSetX = self.contentOffset.x;
        if (!_isRefreshing && decelerate) {
            if (contentOffSetX < 0 && self.refreshHeader && fabs(contentOffSetX) > self.refreshHeaderOffset) {
                if (_respond_hasRefresh_header) {
                    [self.refreshHeader hasRefresh:self];
                }
                _isRefreshing = YES;
                [self setEdgeAtDirection:MSPadHorizonRefreshDirectTop];
            }else if (self.refreshFooter && (self.contentSize.width < self.frame.size.width || contentOffSetX - self.refreshFooterOffset >= self.contentSize.width - self.frame.size.width)){
                if (_respond_hasRefresh_footer) {
                    [self.refreshFooter hasRefresh:self];
                }
                _isRefreshing = YES;
                [self setEdgeAtDirection:MSPadHorizonRefreshDirectBottom];
            }
        }
    }
}
// 手动结束刷新
- (void)finishRefresh{
    if (_isRefreshing == NO) {
        return;
    }
    _isRefreshing = NO;
    [UIView animateWithDuration:MSPadHorizonViewAnimationEdgeZero animations:^{
        self.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished) {

    }];
}

- (void)setEdgeAtDirection:(MSPadHorizonRefreshDirection)direction{
    UIEdgeInsets edge;
    if (direction == MSPadHorizonRefreshDirectTop) {
        edge = UIEdgeInsetsMake(0, self.refreshHeader.frame.size.width, 0, 0);
    }else if(direction == MSPadHorizonRefreshDirectBottom){
        edge = UIEdgeInsetsMake(0, 0, 0, self.refreshFooter.frame.size.width);
    }
    self.scrollEnabled = NO;
    [UIView animateWithDuration:MSPadHorizonViewAnimationEdge animations:^{
        [self setContentInset:edge];
    } completion:^(BOOL finished) {
        [self flashScrollIndicators];
        self.scrollEnabled = YES;
        if (_respond_didRefresh) {
            [self.pullRefreshDelegate MSPadHorizonView:self didRefresh:direction];
        }
    }];
}

#pragma mark -UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_respond_scrollViewDidScroll) [self.horizonDelegate scrollViewDidScroll:scrollView];
    [self horizonViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_respond_scrollViewDidEndDraggingWillDecelerate) [self.horizonDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self horizonDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (_respond_scrollViewDidZoom) [self.horizonDelegate scrollViewDidZoom:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_respond_scrollViewWillBeginDragging) [self.horizonDelegate scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_respond_scrollViewWillEndDraggingWithVelocityTargetContentOffset) [self.horizonDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_respond_scrollViewWillBeginDecelerating) [self.horizonDelegate scrollViewWillBeginDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_respond_scrollViewDidEndDecelerating) [self.horizonDelegate scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_respond_scrollViewDidEndScrollingAnimation) [self.horizonDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (_respond_viewForZoomingInScrollView) {
        return [self.horizonDelegate viewForZoomingInScrollView:scrollView];
    }else {
        return nil;
    }
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if (_respond_scrollViewWillBeginZoomingWithView) [self.horizonDelegate scrollViewWillBeginZooming:scrollView withView:view];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (_respond_scrollViewDidEndZoomingWithViewAtScale) [self.horizonDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if (_respond_scrollViewShouldScrollToTop) {
        return [self.horizonDelegate scrollViewShouldScrollToTop:scrollView];
    }else {
        return self.scrollsToTop;
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_respond_scrollViewDidScrollToTop) [self.horizonDelegate scrollViewDidScrollToTop:scrollView];
}
@end