//
//  RJViewController.m
//  RJImageLoader
//
//  Created by Rounak on 02/19/2015.
//  Copyright (c) 2014 Rounak. All rights reserved.
//

#import "RJViewController.h"
#import <UIImageView+WebCache.h>
#import <UIImageView+RJLoader.h>

@interface RJViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation RJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageView startLoaderWithTintColor:[UIColor blueColor]];
    __weak typeof(self)weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://techrotten.com/wp-content/uploads/2019/03/artificial-intelligence.jpg"] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                [weakSelf.imageView updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [weakSelf.imageView reveal];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
