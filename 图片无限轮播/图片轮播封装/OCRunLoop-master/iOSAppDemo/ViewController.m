//
//  ViewController.m
//  iOSAppDemo
//
//  Created by lurich on 2021/12/2.
//

#import "ViewController.h"
#import "SFFocusImage.h"
#import "SFImgUtil.h"

@interface ViewController ()<SFFocusImageDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SFFocusImage *loopView = [[SFFocusImage alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 150)];
    loopView.layer.masksToBounds = YES;
    loopView.layer.cornerRadius = 10;
    loopView.time = 3;
    loopView.delegate = self;
    [self.view addSubview:loopView];
    NSMutableArray *imgArr = [NSMutableArray array];
    NSArray *urlArr = @[
        @"https://t7.baidu.com/it/u=963301259,1982396977&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=737555197,308540855&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=1297102096,3476971300&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=3655946603,4193416998&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=12235476,3874255656&fm=193&f=GIF",
    ];
    for (int i=0; i<urlArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:loopView.bounds];
        imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlArr[i]]]];
        [imgArr addObject:imgView];
    }
    [loopView reloadWithViews:imgArr];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 300, 100, 100)];
    [SFImgUtil imgWithUrl:@"http://creative3.bxsnews.com/creative/b1124be1511bf9ae0005d0d4827273d2.gif" successBlock:^(UIImage *img, NSData *imgData, SFImageType type) {
        imgView.image = img;
    } failBlock:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    [self.view addSubview:imgView];
}

@end
