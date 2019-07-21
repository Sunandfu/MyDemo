//
//  Demo7ViewController.m
//  照片选择器
//
//  Created by 洪欣 on 2017/9/2.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "Demo7ViewController.h" 
#import "HXPhotoView.h"


static const CGFloat kPhotoViewMargin = 12.0;

@interface Demo7ViewController ()<HXPhotoViewDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation Demo7ViewController

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 9;
        _manager.configuration.maxNum = 18;

    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    // 加载本地图片
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0 ; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        
        HXCustomAssetModel *model = [HXCustomAssetModel assetWithLocalImage:image selected:YES];
        [images addObject:model];
    }
//    [self.manager addLocalImageToAlbumWithImages:images];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0) manager:self.manager];
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
//    self.manager.localImageList = images;
    [self.manager addCustomAssetModel:images];
    
    /**  添加本地视频  **/
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"QQ空间视频_20180301091047" withExtension:@"mp4"];
    HXCustomAssetModel *videoAsset = [HXCustomAssetModel assetWithLocalVideoURL:url selected:YES];
//    [self.manager addLocalVideo:@[url] selected:YES];
    [self.manager addCustomAssetModel:@[videoAsset]];
    
    [photoView refreshView];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"相机" style:UIBarButtonItemStylePlain target:self action:@selector(didNavOneBtnClick)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(didNavTwoBtnClick)];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}

- (void)didNavOneBtnClick {
    [self.photoView goCameraViewController];
}

- (void)didNavTwoBtnClick {
    if (self.manager.afterSelectPhotoCountIsMaximum) {
        [self.view hx_showImageHUDText:@"图片已达到最大数"];
        return;
    }
    int x = arc4random() % 4;
    HXCustomAssetModel *asset = [HXCustomAssetModel assetWithLocaImageName:@(x).stringValue selected:YES];
    [self.manager addCustomAssetModel:@[asset]];
//    [self.manager addLocalImage:[NSArray arrayWithObjects:[UIImage imageNamed:@(x).stringValue], nil] selected:YES];
    [self.photoView refreshView];
}
 
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"%@",allList);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
}

- (void)dealloc {
    NSSLog(@"%@",self);
}

@end
