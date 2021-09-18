//
//  SFFocusImage.m
//  AdDemo
//
//  Created by lurich on 2021/6/11.
//


#import "SFFocusImage.h"
#import <ImageIO/ImageIO.h>
#import "SFPageControl.h"
#import "SFSliderPageControl.h"
#import "SFAnimationPageControl.h"
#import "SFTimerWeakProxy.h"

#define DEFAULTTIME 3
#define DEFAULTPOTINT 10
#define VERMARGIN 3
#define DEFAULTHEIGT 20


@interface SFFocusImage()<UIScrollViewDelegate>

//保存的视图数组
@property(nonatomic, strong)NSArray *viewArray;

///滑动控件
@property(nonatomic, strong)UIScrollView *scrollView;

///当前页面图片
@property(nonatomic, strong) UIView *currView;

///别的页面图片
@property(nonatomic, strong) UIView *otherView;

///当前页面下标
@property(nonatomic, assign)NSInteger currIndex;

///下一个页面下标
@property(nonatomic, assign)NSInteger nextIndex;

///定时器
@property(nonatomic, strong)NSTimer *timer;

///页面控制器
@property(nonatomic, strong) UIView *pageControl;

@end

@implementation SFFocusImage

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _time = 3.0;
        _showPageControl = YES;
        _pageControlStyle = YXBannerScrollViewPageContolStyleClassic;
        _pageControlAliment = YXBannerScrollViewPageContolAlimentCenter;
        _currentPageDotColor = [UIColor whiteColor];
        _pageDotColor = [UIColor lightGrayColor];
        _hidesForSinglePage = YES;
        _pageOffset = CGPointMake(0, 5);
        _pageControlDotSize = CGSizeMake(12, 10);
    }
    return self;
}
- (void)reloadWithViews:(NSArray<UIView *> *)viewArray{
    self.viewArray = viewArray;
    //设置图片
    [self setViewForArray];
}

#pragma mark - frame相关
- (CGFloat)height{
    return self.scrollView.frame.size.height;
}

- (CGFloat)width{
    return self.scrollView.frame.size.width;
}
- (UIView *)getShowViewWithBackView:(UIView *)backView{
    UIView *showView = [backView viewWithTag:9488];
    return showView;
}
- (void)replaceViewWithBackView:(UIView *)backView AddView:(UIView *)showView{
    [backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    showView.tag = 9488;
    [backView addSubview:showView];
}


#pragma mark - 布局子控件
-(void)layoutAllViews
{
    //有导航控制器时，会默认在scrollview上方添加64的内边距，这里强制设置为0
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = self.bounds;
    //设置scrollview 的位置
    [self setScrollViewContentSize];
    
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[SFPageControl class]]) {
        SFPageControl *pageControl = (SFPageControl *)_pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(CGSizeMake(10, 10), self.pageControlDotSize))) {
            pageControl.dotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.viewArray.count];
    } else if ([self.pageControl isKindOfClass:[SFAnimationPageControl class]]) {
        SFAnimationPageControl *pageControl = (SFAnimationPageControl *)_pageControl;
        //size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count];
        CGFloat dotWidth   = pageControl.dotBigSize.width;
        CGFloat dotHeight  = pageControl.dotBigSize.height;
        CGFloat dotMargin  = pageControl.dotMargin;
        size = CGSizeMake(self.viewArray.count * (dotWidth + dotMargin),dotHeight);
    } else if ([self.pageControl isKindOfClass:[SFSliderPageControl class]]) {
        size = CGSizeMake(self.viewArray.count * self.pageControlDotSize.width, self.pageControlDotSize.height);
    } else if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)self.pageControl;
        size = [pageControl sizeForNumberOfPages:self.viewArray.count];
//        size = CGSizeMake(self.viewArray.count * self.pageControlDotSize.width, self.pageControlDotSize.height);
    }
    CGFloat x = (self.bounds.size.width - size.width) * 0.5;
    if (self.pageControlAliment == YXBannerScrollViewPageContolAlimentRight) {
        x = self.frame.size.width - size.width - 10;
    } else if(self.pageControlAliment == YXBannerScrollViewPageContolAlimentLeft) {
        x = 20;
    }
    CGFloat y = self.frame.size.height - 10;
    if ([self.pageControl isKindOfClass:[SFPageControl class]]) {
        SFPageControl *pageControl = (SFPageControl *)_pageControl;
        [pageControl sizeToFit];
    } else if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        y = self.frame.size.height - size.height;
    }
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageOffset.y;
    pageControlFrame.origin.x -= self.pageOffset.x;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
}


#pragma mark - 设置图片数组
-(void)setViewForArray{
    [self addSubview:self.scrollView];
    [self setupPageControl];
    if (self.viewArray.count==0) return;
    //设置图片
    if (_currIndex >= self.viewArray.count)_currIndex = self.viewArray.count -1;
    [self replaceViewWithBackView:self.currView AddView:self.viewArray[_currIndex]];
    [self layoutAllViews];
}

#pragma mark - -------设置scrollView的contentSize---------
- (void)setScrollViewContentSize {
    if (self.viewArray.count > 1) {
        self.scrollView.contentSize = CGSizeMake(self.width * 5, 0);
        self.scrollView.contentOffset = CGPointMake(self.width * 2, 0);
        self.currView.frame = CGRectMake(self.width * 2, 0, self.width, self.height);
        
        if (_changeMode == SFChangeModeFade) {
            //淡入淡出模式，两个imageView都在同一位置，改变透明度就可以了
            _currView.frame = CGRectMake(0, 0, self.width, self.height);
            _otherView.frame = self.currView.frame;
            _otherView.alpha = 0;
            [self insertSubview:self.currView atIndex:0];
            [self insertSubview:self.otherView atIndex:1];
        }
        [self startTimer];
    } else {
        //只要一张图片时，scrollview不可滚动，且关闭定时器
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset = CGPointZero;
        self.currView.frame = CGRectMake(0, 0, self.width, self.height);
        [self stopTimer];
    }
}


#pragma mark 当图片滚动过半时就修改当前页码
- (void)changeCurrentPageWithOffset:(CGFloat)offsetX {
    if (offsetX < self.width * 1.5) {
        NSInteger index = self.currIndex - 1;
        if (index < 0) index = self.viewArray.count - 1;
        [self changeCurrentPageWithCurrentIndex:index];
    } else if (offsetX > self.width * 2.5){
        [self changeCurrentPageWithCurrentIndex:(self.currIndex + 1) % self.viewArray.count];
    } else {
        [self changeCurrentPageWithCurrentIndex:self.currIndex];
    }
}


#pragma mark - 切换图片
-(void)changToNext{
    if (_changeMode == SFChangeModeFade) {
        self.currView.alpha = 1;
        self.otherView.alpha = 0;
    }
    //切换下张图片
    [self replaceViewWithBackView:self.currView AddView:[self getShowViewWithBackView:self.otherView]];
    self.scrollView.contentOffset = CGPointMake(self.width * 2, 0);
    [self.scrollView layoutSubviews];
    self.currIndex = self.nextIndex;
    [self changeCurrentPageWithCurrentIndex:self.currIndex];
}
- (void)setChangeMode:(SFChangeMode)changeMode{
    _changeMode = changeMode;
}

#pragma mark - ---------UIScrollViewDelegate------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (CGSizeEqualToSize(CGSizeZero, scrollView.contentSize))return;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    //滚动过程中。改变当前页码
    [self changeCurrentPageWithOffset:offsetX];
    
    //判断向右滚动
    if(offsetX < self.width * 2){
        if (_changeMode == SFChangeModeFade) {
            self.currView.alpha = offsetX / self.width -1;
            self.otherView.alpha = 2 - offsetX / self.width;
        }else{
            self.otherView.frame = CGRectMake(self.width, 0, self.width, self.height);
        }
        self.nextIndex = self.currIndex -1;
        if (self.nextIndex < 0) self.nextIndex = self.viewArray.count -1;
        [self replaceViewWithBackView:self.otherView AddView:self.viewArray[self.nextIndex]];
        if (offsetX <= self.width ) {
            [self changToNext];
        }
        
    }else if(offsetX > self.width * 2){
        if (_changeMode == SFChangeModeFade) {
            self.otherView.alpha = offsetX / self.width -2;
            self.currView.alpha = 3 - offsetX / self.width;
        }else{
            self.otherView.frame = CGRectMake(CGRectGetMaxX(_currView.frame), 0, self.width, self.height);
        }
        self.nextIndex = (self.currIndex + 1) % self.viewArray.count;
        [self replaceViewWithBackView:self.otherView AddView:self.viewArray[self.nextIndex]];
        if (offsetX >= self.width * 3) [self changToNext];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.viewArray.count) return; // 解决清除timer时偶尔会出现的问题
    CGFloat offsetX = scrollView.contentOffset.x;
    [self animateChangeCurrentPageWithCurrentIndex:offsetX];
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
    CGFloat offsetX = scrollView.contentOffset.x;
    [self animateChangeCurrentPageWithCurrentIndex:offsetX];
}

//该方法用来修复滚动过快导致分页异常的bug
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_changeMode == SFChangeModeFade) return;
    CGPoint currPointInSelf = [_scrollView convertPoint:_currView.frame.origin toView:self];
    if (currPointInSelf.x >= -self.width / 2 && currPointInSelf.x <= self.width / 2)
        [self.scrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
    else [self changToNext];
}




//下一页
-(void)nextPage{
    if (_changeMode == SFChangeModeFade) {
        self.nextIndex = (self.currIndex + 1) % self.viewArray.count;
        [self replaceViewWithBackView:self.otherView AddView:self.viewArray[self.nextIndex]];
        [UIView animateWithDuration:1.2 animations:^{
            self.currView.alpha = 0;
            self.otherView.alpha = 1;
        } completion:^(BOOL finished) {
            [self changToNext];
        }];
        
    }else{
        [self.scrollView setContentOffset:CGPointMake(self.width *3, 0) animated:YES];
    }
}



#pragma mark- --------定时器相关方法--------
- (void)startTimer {
    //如果只有一张图片，则直接返回，不开启定时器
    if (self.viewArray.count <= 1) return;
    //如果定时器已开启，先停止再重新开启
    if (self.timer) [self stopTimer];
    SFTimerWeakProxy *timerProxy = [SFTimerWeakProxy proxyWithTarget:self];
    self.timer = [NSTimer timerWithTimeInterval:_time < 1 ? DEFAULTTIME: _time target:timerProxy selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark 设置定时器时间
- (void)setTime:(NSTimeInterval)time {
    _time = time;
    [self startTimer];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)dealloc{
    [self stopTimer];
}
#pragma mark 图片点击事件
- (void)imageClick {
    if (_delegate && [_delegate respondsToSelector:@selector(tapFocusWithIndex:)]) {
        [_delegate tapFocusWithIndex:self.currIndex];
    }
}

- (void)setPageOffset:(CGPoint)pageOffset {
    _pageOffset = pageOffset;
    CGRect frame = _pageControl.frame;
    frame.origin.x += pageOffset.x;
    frame.origin.y += pageOffset.y;
    _pageControl.frame = frame;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        //添加手势图片的点击
        UITapGestureRecognizer *ImageClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)];
        [_scrollView addGestureRecognizer:ImageClick];
        [_scrollView addSubview:self.currView];
        [_scrollView addSubview:self.otherView];
    }
    return _scrollView;
}

-(UIView *)currView{
    if (!_currView) {
        _currView = [[UIView alloc]init];
        _currView.clipsToBounds = YES;
    }
    return _currView;
}
-(UIView *)otherView{
    if (!_otherView) {
        _otherView = [[UIView alloc]init];
        _otherView.clipsToBounds = YES;
    }
    return _otherView;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize {
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
    if ([self.pageControl isKindOfClass:[SFPageControl class]]) {
        SFPageControl *pageContol = (SFPageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor {
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[SFPageControl class]]) {
        SFPageControl *pageControl = (SFPageControl *)_pageControl;
        pageControl.dotColor = currentPageDotColor;
    } else if ([self.pageControl isKindOfClass:[SFSliderPageControl class]]) {
        SFSliderPageControl *pageControl = (SFSliderPageControl *)_pageControl;
        pageControl.currentPageColor = currentPageDotColor;
    }else if ([self.pageControl isKindOfClass:[SFAnimationPageControl class]]) {
        
    } else if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor {
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    } else if ([self.pageControl isKindOfClass:[SFSliderPageControl class]]){
        SFSliderPageControl *pageControl = (SFSliderPageControl *)_pageControl;
        pageControl.normalPageColor = pageDotColor;
    } else if ([self.pageControl isKindOfClass:[SFAnimationPageControl class]]){

    } else {
        
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage {
    _currentPageDotImage = currentPageDotImage;
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage {
    _pageDotImage = pageDotImage;
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot {
    if (!image || !self.pageControl) return;
    if ([self.pageControl isKindOfClass:[SFPageControl class]]) {
        SFPageControl *pageControl = (SFPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage        = image;
        }
    } else if ([self.pageControl isKindOfClass:[SFAnimationPageControl class]]) {
        SFAnimationPageControl *pageControl = (SFAnimationPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentPageImage = image;
        } else {
            pageControl.normalPageImage  = image;
        }
    }
}

- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
}

- (void)setPageControlStyle:(YXBannerScrollViewPageContolStyle)pageControlStyle {
    _pageControlStyle = pageControlStyle;
}
- (void)setupPageControl {
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    if ((self.viewArray.count == 1) && _hidesForSinglePage) return;
    if (!_showPageControl) return;
    int indexOnPageControl = 0;
    switch (self.pageControlStyle) {
        case YXBannerScrollViewPageContolStyleAnimated: {
            SFPageControl *pageControl = [[SFPageControl alloc] init];
            pageControl.numberOfPages = self.viewArray.count;
            pageControl.dotColor = self.currentPageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
        }
            break;
        case YXBannerScrollViewPageContolStyleClassic: {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.viewArray.count;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
        }
            break;
        case YXBannerScrollViewPageControlHorizontal: {
            SFSliderPageControl *pageControl = [[SFSliderPageControl alloc] init];
            pageControl.pages = self.viewArray.count;
            pageControl.currentPageColor = self.currentPageDotColor;
            pageControl.normalPageColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.startPage = indexOnPageControl;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
        }
            break;
        case YXBannerScrollViewPageImageRotation: {
            SFAnimationPageControl *pageControl = [[SFAnimationPageControl alloc] init];
            pageControl.pages = self.viewArray.count;
            pageControl.normalPageImage = self.pageDotImage;
            pageControl.animationType = SFAnimationPageControlRotation;
            pageControl.currentPageImage = self.currentPageDotImage;
            pageControl.userInteractionEnabled = NO;
            pageControl.startPage = indexOnPageControl;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
            self.scrollView.scrollEnabled = NO;
        }
            break;
        case YXBannerScrollViewPageImageJump: {
            SFAnimationPageControl *pageControl = [[SFAnimationPageControl alloc] init];
            pageControl.pages = self.viewArray.count;
            pageControl.normalPageImage = self.pageDotImage;
            pageControl.animationType = SFAnimationPageControlJump;
            pageControl.currentPageImage = self.currentPageDotImage;
            pageControl.userInteractionEnabled = NO;
            pageControl.startPage = indexOnPageControl;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
            self.scrollView.scrollEnabled = NO;
        }
            break;
        case YXBannerScrollViewPageImageAnimated: {
            SFAnimationPageControl *pageControl = [[SFAnimationPageControl alloc] init];
            pageControl.pages = self.viewArray.count;
            pageControl.normalPageImage = self.pageDotImage;
            pageControl.animationType = SFAnimationPageControlNoamal;
            pageControl.currentPageImage = self.currentPageDotImage;
            pageControl.userInteractionEnabled = NO;
            pageControl.startPage = indexOnPageControl;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
            self.scrollView.scrollEnabled = NO;
        }
            break;
        case YXBannerScrollViewPageContolStyleNone: {}
            break;
        default:
            break;
    }
    
    // 重设pagecontroldot图片
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
}

- (void)changeCurrentPageWithCurrentIndex:(NSInteger)indexOnPageControl{
    
    if ([self.pageControl isKindOfClass:[SFPageControl class]]) {
        SFPageControl *pageControl = (SFPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }  else if ([self.pageControl isKindOfClass:[SFSliderPageControl class]]) {
        SFSliderPageControl *pageControl = (SFSliderPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
        [pageControl setCurrentPage:indexOnPageControl];
    }  else if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
}
- (void)animateChangeCurrentPageWithCurrentIndex:(CGFloat)offsetX{
    NSInteger index;
    if (offsetX < self.width * 1.5) {
        index = self.currIndex - 1;
        if (index < 0) index = self.viewArray.count - 1;
    } else if (offsetX > self.width * 2.5){
        index = (self.currIndex + 1) % self.viewArray.count;
    } else {
        index = self.currIndex;
    }
    if ([self.pageControl isKindOfClass:[SFAnimationPageControl class]]) {
        SFAnimationPageControl *pageControl = (SFAnimationPageControl *)_pageControl;
        [pageControl setCurrentPage:index];
    }
}

@end










