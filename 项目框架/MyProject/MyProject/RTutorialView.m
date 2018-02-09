//
//  HomeViewController.m
//  MyProject
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "RTutorialView.h"

#define TAG_OFFSET 10000
#define starBtnPic @"learn_start"

@interface RTutorialView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIScrollView *pagesScrollView;
@property (nonatomic, strong) NSMutableArray *learningPages;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *hourImageView;


@end

@implementation RTutorialView {
    NSInteger previousPage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _backgroundScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _backgroundScrollView.showsHorizontalScrollIndicator = NO;
        _backgroundScrollView.directionalLockEnabled = YES;
        
        
        [self addSubview:_backgroundScrollView];
        
        
        _backgroundImageView = [[UIImageView alloc] init];
        [_backgroundScrollView addSubview:_backgroundImageView];
        
        _pagesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _pagesScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _pagesScrollView.showsHorizontalScrollIndicator = NO;
        _pagesScrollView.directionalLockEnabled = YES;
        _pagesScrollView.pagingEnabled = YES;
        _pagesScrollView.delegate = self;
        
        
        [self addSubview:_pagesScrollView];

        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:starBtnPic];
        [self.doneButton setBackgroundImage:image forState:UIControlStateNormal];
        CGRect rect;
        rect.size = image.size;
//        self.doneButton.frame = rect;
        self.doneButton.frame = CGRectMake(0, 0, 80, 35);
        [self.doneButton setTitle:@"启动应用" forState:UIControlStateNormal];
        
        self.doneButton.center = CGPointMake(self.center.x , self.frame.size.height - 60);
        self.doneButton.hidden = YES;
        self.doneButton.layer.cornerRadius = 5;
        [self.doneButton addTarget:self action:@selector(tutorialDone:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];

        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 10)];
        self.pageControl.center = CGPointMake(self.center.x, CGRectGetHeight(self.bounds) - 15);
        [self addSubview:self.pageControl];
        
        
        _hourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1800, 100, 119, 42)];
        _hourImageView.image = [UIImage imageNamed:@"learn_2hour"];
        _hourImageView.hidden = YES;
        [_pagesScrollView addSubview:_hourImageView];
        [_pagesScrollView bringSubviewToFront:_hourImageView];
        
        
        [self setup];
        
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.bounds.size.width;
    
    
    CGFloat width = _backgroundScrollView.contentSize.width - pageWidth;
    CGFloat width2 = _pagesScrollView.contentSize.width - pageWidth;
    
    
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= scrollView.contentSize.width - pageWidth) {
        _backgroundScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x * width / width2, 0);
    }
    
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        [self didPageTo:page];
        previousPage = page;
    }
    if (page >= [self.learningImageNames count] -1) {
        self.doneButton.hidden = NO;
        [self showHourImage];
    } else {
        self.doneButton.hidden = YES;
    }
    
}

-(void)showHourImage{
    
    if (_hourImageView.hidden) {
        
        _hourImageView.hidden = NO;
        
        float width = self.frame.size.width;
        
        CGRect endFrame = CGRectMake(width * 3, 125, 119, 42);
        _hourImageView.frame = endFrame;
        _hourImageView.alpha = .2f;
        
        [UIView animateWithDuration:0.4f animations:^{
            CGRect endFrame = CGRectMake(width * 2 + 25, 125, 119, 42);
            _hourImageView.frame = endFrame;
            _hourImageView.alpha = 1;
            
        } completion:^(BOOL finished) {
            //
        }];
        
    }
}
- (void)didPageTo:(NSInteger)index {
    
    self.pageControl.currentPage = index;
    
    if ([self.tutorialDelegate respondsToSelector:@selector(tutorialView:didPageToIndex:)]) {
        [self.tutorialDelegate tutorialView:self didPageToIndex:index];
    }
}



- (void)setup {
    previousPage = 0;
    self.learningPages = [NSMutableArray array];
}

- (void)tutorialDone:(id)sender{
    if ([self.tutorialDelegate respondsToSelector:@selector(tutorialDidFinish:)]) {
        [self.tutorialDelegate tutorialDidFinish:self];
    }
}

- (void)setBackgroundImage:(UIImage *)image {
    _backgroundImage = image;
    self.backgroundImageView.image = _backgroundImage;
    
}

- (void)setLearningImageNames:(NSArray *)images {
    _learningImageNames = images;
    
    [self.learningPages removeAllObjects];
    
    self.pageControl.numberOfPages = [_learningImageNames count];
    
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    if ([_learningImageNames count] == 0) {
        return;
    }

    self.pageControl.center = CGPointMake(self.center.x, CGRectGetHeight(self.bounds) - 15);
    
    if (_backgroundImage) {
        CGSize imageSize = _backgroundImage.size;
        self.backgroundImageView.frame = CGRectMake(0, 0, imageSize.width, self.bounds.size.height);
        _backgroundScrollView.contentSize = self.backgroundImageView.bounds.size;
    }
    
    if ([self.learningPages count] == 0) {
        CGSize size = self.bounds.size;
        
        int i = 0;
        for (NSString *name in _learningImageNames) {
            UIImage *image = [UIImage imageNamed:name];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.tag = TAG_OFFSET + i;
            imageView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
            
            [self.pagesScrollView addSubview:imageView];
            
            i++;
            
            [self.learningPages addObject:imageView];
        }
        
        self.pagesScrollView.contentSize = CGSizeMake(i * size.width, size.height);
        self.pagesScrollView.frame = self.bounds;
    }
}


@end
