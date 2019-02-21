//
//  YXFeedAdTableViewCell.m
//  LunchAd
//
//  Created by shuai on 2018/10/23.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXFeedAdTableViewCell.h"

#import <YXLaunchAds/YXFeedAdData.h>

@implementation YXFeedAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 4;
    
    self.infoBtn.layer.masksToBounds = YES;
    self.infoBtn.layer.borderColor =  [UIColor colorWithRed:208/255.0 green:0 blue:0 alpha:1].CGColor;
    self.infoBtn.layer.borderWidth = 1;
    self.infoBtn.layer.cornerRadius = 4;
    // Initialization code
}
- (void)initadViewWithData:(YXFeedAdData *)data
{
    //    self.registAdView
    self.adTitleLabel.text = data.adTitle;
    [self setImage:self.adIconImageView WithURL:[NSURL URLWithString:data.IconUrl] placeholderImage:nil];
    [self setImage:self.adImageView WithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:nil];
    self.adContentLabel.text = data.adContent;
    if(!data.buttonText){
        [self.infoBtn setTitle:@"点击下载" forState:UIControlStateNormal];
    }else{
        [self.infoBtn setTitle:data.buttonText forState:UIControlStateNormal];
    }
}
- (void)setImage:(UIImageView*)imageView WithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    NSURLSession *shareSessin = [NSURLSession sharedSession];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [shareSessin dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    }];
    [dataTask resume];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
