//
//  UIImageView+WSWebCache.h
//  app启动广告
//
//  Created by iMac on 16/9/22.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, WSWebImageOptions) {
    WSWebImageDefault = 1 << 0,         // 有缓存,读取缓存,不重新加载,没缓存先加载,并缓存
    WSWebImageOnlyLoad = 1 << 1,        // 只加载,不缓存
    WSWebImageRefreshCached = 1 << 2    // 先读缓存,再加载刷新图片和缓存
};

typedef void(^WSWebImageCompletionBlock)(UIImage *image, NSURL *url);
typedef void(^WSDispatch_asyncBlock)(UIImage *image, NSURL *url, NSData *data);

@interface WSWebImageDownloader : NSObject

/**
 *  缓冲路径
 *
 *  @return 路径
 */
+ (NSString *)cacheImagePath;
/**
 *  检查目录
 *
 *  @param path 路径
 */
+(void)checkDirectory:(NSString *)path;
@end

@interface UIImage(GIF)
/**
 *  NSData -> UIImage
 *
 *  @param data Data
 *
 *  @return UIImage
 */
+ (UIImage *)ws_gifWithData:(NSData *)data;
@end

@interface UIImageView (JWWebCache)

/**
 *  获取当前图像的URL
 */
- (NSURL *)ws_imageURL;

/**
 *  异步加载网络图片+缓存
 *
 *  @param url            图片url
 *  @param placeholder    默认图片
 *  @param completedBlock 加载完成回调
 */
- (void)ws_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completed:(WSWebImageCompletionBlock)completedBlock;

/**
 *  异步加载网络图片+缓存
 *
 *  @param url            图片url
 *  @param placeholder    默认图片
 *  @param options        缓存机制
 *  @param completedBlock 加载完成回调
 */
-(void)ws_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(WSWebImageOptions)options completed:(WSWebImageCompletionBlock)completedBlock;

@end
