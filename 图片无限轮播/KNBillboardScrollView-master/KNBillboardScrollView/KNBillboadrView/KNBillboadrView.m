//
//  KNBillboadrView.m
//  KNBillboardScrollView
//
//  Created by 刘凡 on 2017/11/14.
//  Copyright © 2017年 KrystalName. All rights reserved.



#import "KNBillboadrView.h"
#import "NSTimer+KNTimer.h"
#import <ImageIO/ImageIO.h>

#define DEFAULTTIME 3
#define DEFAULTPOTINT 10
#define VERMARGIN 5
#define DEFAULTHEIGT 20





@interface KNBillboadrView()<UIScrollViewDelegate>

///图片描叙控件,默认在底部
@property(nonatomic, strong)UILabel *descLable;


//保存的图片数组
@property(nonatomic, strong)NSArray *imageArray;

///轮播图片的数组
@property(nonatomic, strong)NSMutableArray *images;


//描叙数组
@property(nonatomic, strong)NSMutableArray *titles;

///滑动控件
@property(nonatomic, strong)UIScrollView *scrollView;

///页面控制器
@property(nonatomic, strong)UIPageControl *pageControl;

///当前页面图片
@property(nonatomic, strong)UIImageView *currImageView;

///别的页面图片
@property(nonatomic, strong)UIImageView *otherImageView;

///当前页面下标
@property(nonatomic, assign)NSInteger currIndex;

///下一个页面下标
@property(nonatomic, assign)NSInteger nextIndex;

///pagecontrol的图片大小
@property(nonatomic, assign)CGSize pageImageSize;

///定时器
@property(nonatomic, strong)NSTimer *timer;

///队列
@property(nonatomic, strong)NSOperationQueue *queue;

//默认占位图
@property(nonatomic, strong)UIImage *placeholdImage;

@end

static NSString *cache;

@implementation KNBillboadrView

//创建用来缓存图片的文件夹
+(void)initialize
{
    cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"KNCarousel"];
    BOOL isDir = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cache isDirectory:&isDir];
    if (!isExists || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (instancetype)initKNBillboadrViewWithFrame:(CGRect )frame andImageArray:(NSArray *)imageArray andDescArray:(NSArray *)descArray andplaceholdImage:(UIImage *)placeholdImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.placeholdImage = placeholdImage ?:[UIImage new];
        self.imageArray = imageArray;
        self.titles = descArray.count > 0 ? [NSMutableArray arrayWithArray:descArray] : nil;
        //然后初始化控件
        [self initView];
    }
    return self;
}


-(instancetype)initKNBillboadrViewWithFrame:(CGRect)frame andplaceholdImage:(UIImage *)placeholdImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.placeholdImage = placeholdImage ? :[UIImage new];
        
        [self initView];
    }
    return self;
}


-(void)setImageArray:(NSArray *)imageArray andDescArray:(NSArray *)descArray
{
    ///清空数据
    if (self.images.count > 0) {
        [self.images removeAllObjects];
    }
    if (self.titles.count > 0) {
        [self.titles removeAllObjects];
    }
    
    
    self.imageArray = imageArray;
    self.titles = descArray.count > 0 ? [NSMutableArray arrayWithArray:descArray] : nil;
    //设置图片
    [self setImageForArray];
     //设置标题
    [self setDescribe];
}

-(void)initView{
    
    self.autoCache = YES;
    [self addSubview:self.scrollView];
    [self addSubview:self.descLable];
    [self addSubview:self.pageControl];
    
    //设置图片
    [self setImageForArray];
    //设置标题
    [self setDescribe];
    
}





#pragma mark - frame相关
- (CGFloat)height{
    return self.scrollView.frame.size.height;
}

- (CGFloat)width{
    return self.scrollView.frame.size.width;
}


#pragma mark - 布局子控件
-(void)layoutSubviews
{
    [super layoutSubviews];
    //有导航控制器时，会默认在scrollview上方添加64的内边距，这里强制设置为0
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = self.bounds;
    self.descLable.frame = CGRectMake(0 , self.height - DEFAULTHEIGT , self.width, DEFAULTHEIGT);
    self.KNPageCotrollPostion = _KNPageCotrollPostion;
    //设置scrollview 的位置
    [self setScrollViewContentSize];
}


#pragma mark - 设置图片数组
-(void)setImageForArray{
    //设置图片
    if(!self.imageArray.count) return;
    for (int i = 0; i<self.imageArray.count; i++) {
        if ([self.imageArray[i] isKindOfClass:[UIImage class]]) {
            [self.images addObject:self.imageArray[i]];
        }else if ([self.imageArray[i] isKindOfClass:[NSString class]]){
            //如果是网络图片。 则先添加占位图..下载完后替换掉
            [self.images addObject:self.placeholdImage];
            //下载图片
            [self downloadImages:i];
        }
    }
    if (_currIndex >= self.images.count)_currIndex = self.images.count -1;
    self.currImageView.image = self.images[_currIndex];
    self.pageControl.numberOfPages = self.images.count;
    [self layoutSubviews];
}

#pragma mark - 设置描叙
-(void)setDescribe{
    if (!self.titles.count){
        self.titles = nil;
        self.descLable.hidden = YES;
    }else
    {
        //先判断.如果图片个数大于标签个数，就设置添加空值进去
        if (self.titles.count < self.imageArray.count) {
            NSMutableArray *describes = [NSMutableArray arrayWithArray:self.titles];
            for (NSInteger i = self.titles.count; i < self.imageArray.count; i++) {
                [describes addObject:@""];
            }
            self.titles = describes;
        }
        self.descLable.hidden = NO;
        self.descLable.text = self.titles[_currIndex];
    }
    //重新计算pageControl的位置
    self.KNPageCotrollPostion = _KNPageCotrollPostion;

    
}


#pragma mark - ---------设置pageControl的位置---------
-(void)setKNPageCotrollPostion:(KNPageControllPostion)KNPageCotrollPostion
{
    _KNPageCotrollPostion = KNPageCotrollPostion;
    //设置隐藏模式。 如果设置了隐藏就隐藏。 图片数量等于1的时候也设置成隐藏
    _pageControl.hidden = (_KNPageCotrollPostion == KNPostionHide) || (self.images.count == 1);
    if (_pageControl.hidden) return;
    
    CGSize size;
    if (!_pageImageSize.width) { // 没有设置图片。 系统有原有样式
        size = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
        size.height = 8;
    }else{
        //设置了图片
        size = CGSizeMake(_pageImageSize.width *(_pageControl.numberOfPages * 2.5), _pageImageSize.height);
        
    }
    _pageControl.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat centerY = self.height - size.height *0.5 - VERMARGIN
    - (self.descLable.hidden ? 0 : DEFAULTHEIGT);
    
    CGFloat pointY = self.height - size.height - VERMARGIN - (self.descLable.hidden ?0 : DEFAULTHEIGT);
    
    if (_KNPageCotrollPostion == KNPostionDefalut || _KNPageCotrollPostion == KNPostionBottomCenter) {
        _pageControl.center = CGPointMake(self.width / 2, centerY);
        
    }else if (_KNPageCotrollPostion == KNPostionBottomLeft){
        _pageControl.frame = CGRectMake(DEFAULTPOTINT, pointY, size.width, size.height);
    }else{
        _pageControl.frame = CGRectMake(self.width - DEFAULTPOTINT - size.width , pointY, size.width, size.height);
    }
    
    if (!CGPointEqualToPoint(_pageOffset , CGPointZero)) {
        self.pageOffset = _pageOffset;
    }
    
}



#pragma mark - -------设置scrollView的contentSize---------
- (void)setScrollViewContentSize {
    if (self.images.count > 1) {
        self.scrollView.contentSize = CGSizeMake(self.width * 5, 0);
        self.scrollView.contentOffset = CGPointMake(self.width * 2, 0);
        self.currImageView.frame = CGRectMake(self.width * 2, 0, self.width, self.height);
        
        if (_KNChangeMode == KNChangeModeFade) {
            //淡入淡出模式，两个imageView都在同一位置，改变透明度就可以了
            _currImageView.frame = CGRectMake(0, 0, self.width, self.height);
            _otherImageView.frame = self.currImageView.frame;
            _otherImageView.alpha = 0;
            [self insertSubview:self.currImageView atIndex:0];
            [self insertSubview:self.otherImageView atIndex:1];
        }
        [self startTimer];
    } else {
        //只要一张图片时，scrollview不可滚动，且关闭定时器
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset = CGPointZero;
        self.currImageView.frame = CGRectMake(0, 0, self.width, self.height);
        [self stopTimer];
    }
}


#pragma mark 当图片滚动过半时就修改当前页码
- (void)changeCurrentPageWithOffset:(CGFloat)offsetX {
    if (offsetX < self.width * 1.5) {
        NSInteger index = self.currIndex - 1;
        if (index < 0) index = self.images.count - 1;
        _pageControl.currentPage = index;
    } else if (offsetX > self.width * 2.5){
        _pageControl.currentPage = (self.currIndex + 1) % self.images.count;
    } else {
        _pageControl.currentPage = self.currIndex;
    }
}


#pragma mark - 切换图片
-(void)changToNext{
    if (_KNChangeMode == KNChangeModeFade) {
        self.currImageView.alpha = 1;
        self.otherImageView.alpha = 0;
    }
    //切换下张图片
    self.currImageView.image = self.otherImageView.image;
    self.scrollView.contentOffset = CGPointMake(self.width * 2, 0);
    [self.scrollView layoutSubviews];
    self.currIndex = self.nextIndex;
    self.pageControl.currentPage = self.nextIndex;
    self.descLable.text = self.titles[self.currIndex];
}





#pragma mark - ---------UIScrollViewDelegate------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (CGSizeEqualToSize(CGSizeZero, scrollView.contentSize))return;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //判断gif的动画方式
    if (_gifPlayMode == KNGifPlayModePauseWhenScroll) {
        [self gifAnimating:(offsetX == self.width *2)];
    }
    
    //滚动过程中。改变当前页码
    [self changeCurrentPageWithOffset:offsetX];
    
    //判断向右滚动
    if(offsetX < self.width * 2){
        if (_KNChangeMode == KNChangeModeFade) {
            self.currImageView.alpha = offsetX / self.width -1;
            self.otherImageView.alpha = 2 - offsetX / self.width;
        }else{
            self.otherImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
        }
        self.nextIndex = self.currIndex -1;
        if (self.nextIndex < 0) self.nextIndex = self.images.count -1;
        self.otherImageView.image = self.images[self.nextIndex];
        if (offsetX <= self.width ) {
            [self changToNext];
        }
        
    }else if(offsetX > self.width * 2){
        if (_KNChangeMode == KNChangeModeFade) {
            self.otherImageView.alpha = offsetX / self.width -2;
            self.currImageView.alpha = 3 - offsetX / self.width;
        }else{
            self.otherImageView.frame = CGRectMake(CGRectGetMaxX(_currImageView.frame), 0, self.width, self.height);
        }
        self.nextIndex = (self.currIndex + 1) % self.images.count;
        self.otherImageView.image = self.images[self.nextIndex];
        if (offsetX >= self.width * 3) [self changToNext];
    }
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

//该方法用来修复滚动过快导致分页异常的bug
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_KNChangeMode == KNChangeModeFade) return;
    CGPoint currPointInSelf = [_scrollView convertPoint:_currImageView.frame.origin toView:self];
    if (currPointInSelf.x >= -self.width / 2 && currPointInSelf.x <= self.width / 2)
        [self.scrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
    else [self changToNext];
}




//下一页
-(void)nextPage{
    if (_KNChangeMode == KNChangeModeFade) {
        
        self.nextIndex = (self.currIndex + 1) % self.images.count;
        self.otherImageView.image = self.images[self.nextIndex];
        [UIView animateWithDuration:1.2 animations:^{
            self.currImageView.alpha = 0;
            self.otherImageView.alpha = 1;
            self.pageControl.currentPage = _nextIndex;
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
    if (self.imageArray.count <= 1) return;
    //如果定时器已开启，先停止再重新开启
    if (self.timer) [self stopTimer];
    __weak typeof (self)weakSelf = self;
    self.timer = [NSTimer kn_TimerWithTimeInterval:_time < 1 ? DEFAULTTIME: _time repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf nextPage];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


#pragma mark - ---------其他方法--------------

#pragma mark - 下载网络图片
-(void)downloadImages:(int)index{
    NSString *urlString = self.imageArray[index];
    NSString *imageName = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *path = [cache stringByAppendingPathComponent:imageName];
    //如果开启了缓存功能，先从沙盒中取图片
    if (_autoCache) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            _images[index] = [YYImage imageWithData:data];
            return;
        }
    }
    
    //下载图片
    NSBlockOperation *doenload = [NSBlockOperation blockOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if (!data) return ;
        UIImage *image = [YYImage imageWithData:data];
        //取到的data有可能不是图片
        if (image) {
            //替换掉
            self.images[index] = image;
            //如果下载的图片为当前要现实的图片。直接回到主线程设置图片
            if (_currIndex == index)[self.currImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            //然后如果是开启缓存。就写人文件夹
            if (_autoCache) [data writeToFile:path atomically:YES];
        }
    }];
    //加入队列
    [self.queue addOperation:doenload];
}





#pragma mark 清除沙盒中的图片缓存
+ (void)clearDiskCache {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cache error:NULL];
    for (NSString *fileName in contents) {
        [[NSFileManager defaultManager] removeItemAtPath:[cache stringByAppendingPathComponent:fileName] error:nil];
    }
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

#pragma mark 图片点击事件
- (void)imageClick {
    
    ([_delegate respondsToSelector:@selector(KNBillboadrView:ClickImageForIndex:)]);
    [_delegate KNBillboadrView:self ClickImageForIndex:self.currIndex];
    
}

- (void)gifAnimating:(BOOL)b {
    [self gifAnimating:b view:self.currImageView];
    [self gifAnimating:b view:self.otherImageView];
}


- (void)gifAnimating:(BOOL)isPlay view:(UIImageView *)imageV {
    if (isPlay) {
        CFTimeInterval pausedTime = [imageV.layer timeOffset];
        imageV.layer.speed = 1.0;
        imageV.layer.timeOffset = 0.0;
        imageV.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [imageV.layer convertTime:CACurrentMediaTime() fromLayer:nil] -    pausedTime;
        imageV.layer.beginTime = timeSincePause;
    } else {
        CFTimeInterval pausedTime = [imageV.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        imageV.layer.speed = 0.0;
        imageV.layer.timeOffset = pausedTime;
    }
}






#pragma mark - 设置相关
-(void)setGifPlayMode:(KNGifPlayMode)gifPlayMode
{
    if (_KNChangeMode == KNChangeModeFade)return;
    _gifPlayMode = gifPlayMode;
    
    if (gifPlayMode == KNGifPlayModeAlways) {
        [self gifAnimating:YES];
    }else if(gifPlayMode == KNGifPlayModeNever)
    {
        [self gifAnimating:NO];
    }
}


-(void)setDescLableFont:(UIFont *)DescLableFont
{
    _DescLableFont = DescLableFont;
    self.descLable.font = DescLableFont;
    
}

-(void)setDescLableColor:(UIColor *)DescLableColor{
    _DescLableColor = DescLableColor;
    self.descLable.textColor = DescLableColor;
}

-(void)setDescLableBackgroundColor:(UIColor *)DescLableBackgroundColor{
    _DescLableBackgroundColor = DescLableBackgroundColor;
    self.descLable.backgroundColor = DescLableBackgroundColor;
}

#pragma mark 设置pageControl的指示器图片
-(void)setPageColor:(UIColor *)color andCurrentPageColor:(UIColor *)currentColor{
    self.pageControl.pageIndicatorTintColor = color;
    self.pageControl.currentPageIndicatorTintColor = currentColor;
}

-(void)setPageImage:(UIImage *)image andCurrentPageImage:(UIImage *)currentImage{
    if (!image || !currentImage)return;
    
    self.pageImageSize = image.size;
    [self.pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [self.pageControl setValue:image forKey:@"_pageImage"];
}


-(void)setKNChangeMode:(KNChangeMode)KNChangeMode
{
    _KNChangeMode = KNChangeMode;
    if (KNChangeMode == KNChangeModeFade) {
        _gifPlayMode = KNGifPlayModeAlways;
    }
    
}


- (void)setPageOffset:(CGPoint)pageOffset {
    _pageOffset = pageOffset;
    CGRect frame = _pageControl.frame;
    frame.origin.x += pageOffset.x;
    frame.origin.y += pageOffset.y;
    _pageControl.frame = frame;
}





#pragma mark - 懒加载.
-(NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
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
        [_scrollView addSubview:self.currImageView];
        [_scrollView addSubview:self.otherImageView];
    }
    return _scrollView;
}

-(UIImageView *)currImageView{
    if (!_currImageView) {
        _currImageView = [[YYAnimatedImageView alloc]init];
        _currImageView.clipsToBounds = YES;
    }
    return _currImageView;
}
-(UIImageView *)otherImageView{
    if (!_otherImageView) {
        _otherImageView = [[YYAnimatedImageView alloc]init];
        _otherImageView.clipsToBounds = YES;
    }
    return _otherImageView;
}

-(UILabel *)descLable{
    if (!_descLable) {
        _descLable = [[UILabel alloc]init];
        _descLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _descLable.textColor = [UIColor whiteColor];
        _descLable.textAlignment = NSTextAlignmentCenter;
        _descLable.font = [UIFont systemFontOfSize:13];
        _descLable.hidden = YES;
    }
    return _descLable;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}


-(NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

@end










