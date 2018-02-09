//
//  DDPhotoDetailController.m
//  DDNews
//
//  Created by Dvel on 16/4/18.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "DDPhotoDetailController.h"
#import "DDPhotoScrollView.h"
#import "DDPhotoDescView.h"

#import "UIImageView+WebCache.h"
#import "JT3DScrollView.h"

@interface DDPhotoDetailController () <UIScrollViewDelegate>{
    NSArray *images;
}
@property (nonatomic, assign) NSInteger currentPage;
// UI
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) JT3DScrollView *imageScrollView;
@property (nonatomic, strong) DDPhotoDescView *photoDescView;

@property (nonatomic, assign) BOOL isDisappear;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation DDPhotoDetailController

- (instancetype)initWithPhotosetID:(NSString *)photosetID
{
	self = [super init];
	if (self) {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	return self;
}

- (void)viewDidLoad
{
	self.view.backgroundColor = [UIColor colorWithRed:0.174 green:0.174 blue:0.164 alpha:1.000];
	//此处获取数据源
    images = @[
                        @"http://img1.3lian.com/img013/v4/96/d/50.jpg",
                        @"http://img15.3lian.com/2015/f2/15/d/142.jpg",
                        @"http://img2.3lian.com/2014/f4/143/d/103.jpg",
                        @"http://www.51wendang.com/pic/11e7e567603f46269949ebe9/1-810-jpg_6-1080-0-0-1080.jpg",
                        @"http://image.tianjimedia.com/uploadImages/2013/235/3K652B0WH4M5.jpg",
                        @"http://image.tianjimedia.com/uploadImages/2013/256/ILCF68501494_1000x500.jpg"];
    
    [self.view addSubview:self.imageScrollView];
    [self.view addSubview:self.backButton];
    _currentIndex = self.index;
    [self.imageScrollView setContentOffset:CGPointMake(_currentIndex*self.view.frame.size.width, 0)];
    [self showDetailTitle];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = self.view.frame.size.width;
    _currentIndex = x/width;
    [self showDetailTitle];
}
- (void)showDetailTitle{
    
    // 如果已经消失了，就不展现描述文本了。
    if (_isDisappear == YES) {return;}
    
    // 先remove
    [_photoDescView removeFromSuperview];
    // 再加入
    _photoDescView = [[DDPhotoDescView alloc] initWithTitle:@"标题名字"
                                                       desc:@"我测试的文本"
                                                      index:_currentIndex
                                                 totalCount:images.count];
    [self.view addSubview:_photoDescView];
}

#pragma mark - getter
- (UIButton *)backButton
{
	if (_backButton == nil) {
		_backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 25, 40, 40)];
        [_backButton setImage:[UIImage imageNamed:@"imageset_back_live"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"imageset_back"] forState:UIControlStateSelected];
		[_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _backButton;
}


- (JT3DScrollView *)imageScrollView
{
	if (_imageScrollView == nil) {
		// 设置大ScrollView  40:适当提高下imageView的高度，否则上面显得太空洞
		_imageScrollView = [[JT3DScrollView alloc] initWithFrame:CGRectMake(0, 0, ScrW, ScrH - 40)];
		_imageScrollView.contentSize = CGSizeMake(images.count * ScrW, ScrH - 40);
		_imageScrollView.showsHorizontalScrollIndicator = NO;
		_imageScrollView.effect = arc4random_uniform(4) + 1; // 切换的动画效果,随机枚举中的1，2，3三种效果。
		_imageScrollView.clipsToBounds = YES;
		_imageScrollView.delegate = self;
		// 设置小ScrollView（装载imageView的scrollView）
		for (int i = 0; i < images.count; i++) {
			DDPhotoScrollView *photoScrollView = [[DDPhotoScrollView alloc] initWithFrame:CGRectMake(ScrW * i, 0, ScrW, ScrH - 40) urlString:images[i]];
			// singleTapBlock回调：让所有UI，除了图片，全部消失
			__weak typeof(self) weakSelf = self;
            photoScrollView.longTapBlock = ^{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存该图片到相册？" preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 先获取图片
                    DDPhotoScrollView *scrollView = weakSelf.imageScrollView.subviews[weakSelf.currentIndex];
                    UIImageWriteToSavedPhotosAlbum(scrollView.imageView.image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }]];
                [self presentViewController:alertVC animated:YES completion:nil];
            };
			photoScrollView.singleTapBlock = ^{
				NSLog(@"tap~");
				// 如果已经消失，就出现
				if (weakSelf.isDisappear == YES) {
					[weakSelf.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						if (![obj isKindOfClass:[JT3DScrollView class]]) {
							[UIView animateWithDuration:0.5 animations:^{
								obj.alpha = 1;
								weakSelf.view.backgroundColor = [UIColor colorWithRed:0.174 green:0.174 blue:0.164 alpha:1.000];
							} completion:^(BOOL finished) {
								obj.userInteractionEnabled = YES;
							}];
						}
					}];
					weakSelf.isDisappear = NO;	
				} else { // 消失
					[weakSelf.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						if (![obj isKindOfClass:[JT3DScrollView class]]) {
							[UIView animateWithDuration:0.5 animations:^{
								obj.alpha = 0;
								weakSelf.view.backgroundColor = [UIColor blackColor];
							} completion:^(BOOL finished) {
								obj.userInteractionEnabled = NO;
							}];
						}
					}];
					weakSelf.isDisappear = YES;
				}
				
			};
			[_imageScrollView addSubview:photoScrollView];
		}
	}
	return _imageScrollView;
}

#pragma mark -
- (void)backButtonClick
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

// 成功保存图片到相册中, 必须调用此方法, 否则会报参数越界错误
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	if (!error) {
        NSLog(@"图片已保存至相册！");
	} else {
        NSLog(@"保存失败");
	}
}

@end

