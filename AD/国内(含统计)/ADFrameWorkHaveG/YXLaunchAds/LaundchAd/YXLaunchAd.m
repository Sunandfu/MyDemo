//
//  YXLaunchAd.m
//  LunchAd
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXLaunchAd.h"
#import "YXLaunchAdView.h"
#import "YXLaunchAdImageView+YXLaunchAdCache.h"
#import "YXLaunchAdDownloader.h"
#import "YXLaunchAdCache.h"
#import "YXFLAnimatedImage.h"
#import "YXLaunchAdController.h"
#import "NetTool.h"
#import "YXImgUtil.h"
#import "YXLaunchAdManager.h"
typedef NS_ENUM(NSInteger, YXLaunchAdType) {
    YXLaunchAdTypeImage,
    YXLaunchAdTypeVideo
};

static NSInteger defaultWaitDataDuration = 5;
static  SourceType _sourceType = SourceTypeLaunchImage;
@interface YXLaunchAd()

@property(nonatomic,assign)YXLaunchAdType launchAdType;
@property(nonatomic,assign)NSInteger waitDataDuration;

@property(nonatomic,strong)YXLaunchVideoAdConfiguration * videoAdConfiguration;



@property(nonatomic,strong)YXLaunchAdVideoView * adVideoView;

//@property(nonatomic,strong)UIWindow * window;
@property(nonatomic,copy)dispatch_source_t waitDataTimer;
@property(nonatomic,copy)dispatch_source_t skipTimer;
@property (nonatomic, assign) BOOL detailPageShowing;
@property(nonatomic,assign) CGPoint clickPoint;
@end

@implementation YXLaunchAd


+(void)setLaunchSourceType:(SourceType)sourceType{
    _sourceType = sourceType;
    
    if ([self imageFromLaunchImage]) {
        _sourceType = SourceTypeLaunchImage;
    }
    if ([self imageFromLaunchScreen]) {
        _sourceType = SourceTypeLaunchScreen;
    }
}
+(void)setLaunchSource{
    if ([self imageFromLaunchImage]) {
        _sourceType = SourceTypeLaunchImage;
    }
    if ([self imageFromLaunchScreen]) {
        _sourceType = SourceTypeLaunchScreen;
    }
}

+ (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage *)imageFromLaunchImage{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if(imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if(imageL)  return imageL;
    //    XHLaunchAdLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}

+(UIImage *)imageFromLaunchScreen{
    NSString *UILaunchStoryboardName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchStoryboardName"];
    if(UILaunchStoryboardName == nil){
        //        XHLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
        return nil;
    }
    UIViewController *LaunchScreenSb = [[UIStoryboard storyboardWithName:UILaunchStoryboardName bundle:nil] instantiateInitialViewController];
    if(LaunchScreenSb){
        UIView * view = LaunchScreenSb.view;
        view.frame = [UIScreen mainScreen].bounds;
        UIImage *image = [self imageFromView:view];
        return image;
    }
    //    XHLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
    return nil;
}

+ (UIImage*)imageFromView:(UIView*)view{
    CGSize size = view.bounds.size;
    //参数1:表示区域大小 参数2:如果需要显示半透明效果,需要传NO,否则传YES 参数3:屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)launchImageWithType:(NSString *)type{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]){
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize)){
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}
+ (UIImage *)snapshotScreenInView:(UIView *)contentView
{
    UIImage * image = nil;
    CGRect rect = contentView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    //自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates:它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)snapshotScreenInView:(UIView *)contentView WithFrame:(CGRect)frame
{
    CGFloat scaleFlote = [UIScreen mainScreen].scale;
    CGRect newFrame = CGRectMake(scaleFlote*frame.origin.x, scaleFlote*frame.origin.y, scaleFlote*frame.size.width, scaleFlote*frame.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self snapshotScreenInView:contentView].CGImage, newFrame);
    UIGraphicsBeginImageContextWithOptions(newFrame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return image;
}
+(void)setWaitDataDuration:(NSInteger )waitDataDuration{
    YXLaunchAd *launchAd = [YXLaunchAd shareLaunchAd];
    launchAd.waitDataDuration = waitDataDuration;
}
+(YXLaunchAd *)imageAdWithImageAdConfiguration:(YXLaunchImageAdConfiguration *)imageAdconfiguration{
    return [YXLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration bottomView:[YXLaunchAd shareLaunchAd].bottomView delegate:nil];
}

+(YXLaunchAd *)imageAdWithImageAdConfiguration:(YXLaunchImageAdConfiguration *)imageAdconfiguration bottomView:(UIView*)bottomView delegate:(id)delegate{
    YXLaunchAd *launchAd = [YXLaunchAd shareLaunchAd];
    launchAd.isCustomAdView = NO;
    launchAd.bottomView = bottomView;
    if(delegate) launchAd.delegate = delegate;
    launchAd.imageAdConfiguration = imageAdconfiguration;
    return launchAd;
}
+(YXLaunchAd *)customImageViewWithImageAdConfiguration:(YXLaunchImageAdConfiguration *)imageAdconfiguration delegate:(id)delegate
{
    YXLaunchAd *launchAd = [YXLaunchAd shareLaunchAd];
    launchAd.isCustomAdView = YES;
    if(delegate) launchAd.delegate = delegate;
    [launchAd addCustomAdViewConfiguration:imageAdconfiguration];
    return launchAd;
}

+(YXLaunchAd *)videoAdWithVideoAdConfiguration:(YXLaunchVideoAdConfiguration *)videoAdconfiguration{
    return [YXLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:nil];
}

+(YXLaunchAd *)videoAdWithVideoAdConfiguration:(YXLaunchVideoAdConfiguration *)videoAdconfiguration delegate:(nullable id)delegate{
    YXLaunchAd *launchAd = [YXLaunchAd shareLaunchAd];
    if(delegate) launchAd.delegate = delegate;
    launchAd.videoAdConfiguration = videoAdconfiguration;
    return launchAd;
}

+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray{
    [self downLoadImageAndCacheWithURLArray:urlArray completed:nil];
}

+ (void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable YXLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock{
    if(urlArray.count==0) return;
    [[YXLaunchAdDownloader sharedDownloader] downLoadImageAndCacheWithURLArray:urlArray completed:completedBlock];
}

+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray{
    [self downLoadVideoAndCacheWithURLArray:urlArray completed:nil];
}

+(void)downLoadVideoAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable YXLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock{
    if(urlArray.count==0) return;
    [[YXLaunchAdDownloader sharedDownloader] downLoadVideoAndCacheWithURLArray:urlArray completed:completedBlock];
}
+(void)removeAndAnimated:(BOOL)animated{
    [[YXLaunchAd shareLaunchAd] removeAndAnimated:animated];
}

+(BOOL)checkImageInCacheWithURL:(NSURL *)url{
    return [YXLaunchAdCache checkImageInCacheWithURL:url];
}

+(BOOL)checkVideoInCacheWithURL:(NSURL *)url{
    return [YXLaunchAdCache checkVideoInCacheWithURL:url];
}
+(void)clearDiskCache{
    [YXLaunchAdCache clearDiskCache];
}

+(void)clearDiskCacheWithImageUrlArray:(NSArray<NSURL *> *)imageUrlArray{
    [YXLaunchAdCache clearDiskCacheWithImageUrlArray:imageUrlArray];
}

+(void)clearDiskCacheExceptImageUrlArray:(NSArray<NSURL *> *)exceptImageUrlArray{
    [YXLaunchAdCache clearDiskCacheExceptImageUrlArray:exceptImageUrlArray];
}

+(void)clearDiskCacheWithVideoUrlArray:(NSArray<NSURL *> *)videoUrlArray{
    [YXLaunchAdCache clearDiskCacheWithVideoUrlArray:videoUrlArray];
}

+(void)clearDiskCacheExceptVideoUrlArray:(NSArray<NSURL *> *)exceptVideoUrlArray{
    [YXLaunchAdCache clearDiskCacheExceptVideoUrlArray:exceptVideoUrlArray];
}

+(float)diskCacheSize{
    return [YXLaunchAdCache diskCacheSize];
}

+(NSString *)YXLaunchAdCachePath{
    return [YXLaunchAdCache YXLaunchAdCachePath];
}

+(NSString *)cacheImageURLString{
    return [YXLaunchAdCache getCacheImageUrl];
}

+(NSString *)cacheVideoURLString{
    return [YXLaunchAdCache getCacheVideoUrl];
}

#pragma mark - 过期
/** 请使用removeAndAnimated: */
+(void)skipAction{
    [[YXLaunchAd shareLaunchAd] removeAndAnimated:YES];
}
/** 请使用setLaunchSourceType: */
+(void)setLaunchImagesSource:(LaunchImagesSource)launchImagesSource{
    switch (launchImagesSource) {
        case LaunchImagesSourceLaunchImage:
            _sourceType = SourceTypeLaunchImage;
            break;
        case LaunchImagesSourceLaunchScreen:
            _sourceType = SourceTypeLaunchScreen;
            break;
        default:
            break;
    }
}

#pragma mark - private
+(YXLaunchAd *)shareLaunchAd{
    static YXLaunchAd *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[YXLaunchAd alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupLaunchAd];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self setupLaunchAdEnterForeground];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            [self removeOnly];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:YXLaunchAdDetailPageWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self->_detailPageShowing = YES;
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:YXLaunchAdDetailPageShowFinishNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self->_detailPageShowing = NO;
        }];
    }
    return self;
}

-(void)setupLaunchAdEnterForeground{
    switch (_launchAdType) {
        case YXLaunchAdTypeImage:{
            if(!_imageAdConfiguration.showEnterForeground || _detailPageShowing) return;
            [self setupLaunchAd];
            if (self.isCustomAdView) {
                [self addCustomAdViewConfiguration:_imageAdConfiguration];
            }else{
                [self setupImageAdForConfiguration:_imageAdConfiguration];
            }
            
        }
            break;
        case YXLaunchAdTypeVideo:{
            if(!_videoAdConfiguration.showEnterForeground || _detailPageShowing) return;
            [self setupLaunchAd];
            [self setupVideoAdForConfiguration:_videoAdConfiguration];
        }
            break;
        default:
            break;
    }
}

-(UIWindow *)adWindow
{
    if (!_adWindow) {
        _adWindow = ({
            UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            
            window.rootViewController = [YXLaunchAdController new];
            
            
            window.rootViewController.view.backgroundColor = [UIColor clearColor];
            window.rootViewController.view.userInteractionEnabled = YES;
            window.windowLevel = UIWindowLevelStatusBar + 1;
            window.hidden = NO;
            window.alpha = 1;
            UIImage *launchImage = [NetTool getLauchImage];
            if (!launchImage) {
                
                NSLog(@"从UILaunchStoryboardName 或者 LaunchScreen 设置启动页 ");
                [self removeOnly];
                return nil ;
            }
            window.backgroundColor = [UIColor colorWithPatternImage:launchImage];
            window;
        });
    }
    
    return _adWindow;
}

-(void)setupLaunchAd{
    
    /** 添加launchImageView */
    [self adWindow];
}

- (UIImageView*)addLogoViewFromFrame:(CGRect)frame
{
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 70, frame.size.height - 25, 70, 25)];
    
    //    [self setImage:logoImageView WithURL:[NSURL URLWithString:YXLaunchLogoURL] placeholderImage:nil];
    
    [YXImgUtil imgWithUrlWithOutCache:YXLaunchLogoURL successBlock:^(UIImage *img) {
        logoImageView.image = img;
    } failBlock:^(NSError *error) {
        
    }];
    
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([YXLaunchAd shareLaunchAd].hiddenRightIcon) {
        return nil;
    }
    return logoImageView;
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
- (void)setupCustomAdViewConfiguration:(YXLaunchImageAdConfiguration *)configuration
{
    if(_adWindow == nil) return;
    [self removeSubViewsExceptLaunchAdImageView];
    [_adWindow addSubview:_customAdView];
    /** frame */
    if(configuration.frame.size.width>0 && configuration.frame.size.height>0) _customAdView.frame = configuration.frame;
    
    [_adWindow addSubview: [self addLogoViewFromFrame:_customAdView.frame]];
    if ([YXLaunchAd shareLaunchAd].customAdView) {
        /** skipButton */
        [self addSkipButtonForConfiguration:configuration];
        [self startSkipDispathTimer];
    }
    /** customView */
    if(configuration.subViews.count>0)  [self addSubViews:configuration.subViews];
    
}
/**图片*/
-(void)setupImageAdForConfiguration:(YXLaunchImageAdConfiguration *)configuration{
    if(_adWindow == nil) return;
    [self removeSubViewsExceptLaunchAdImageView];
    YXLaunchAdImageView *adImageView = [[YXLaunchAdImageView alloc] init];
    [_adWindow addSubview:adImageView];
    
    [_adWindow addSubview: [self addLogoViewFromFrame:[YXLaunchAdManager shareManager].frame]];
    
    if (self.bottomView) {
        [_adWindow addSubview:self.bottomView];
    }
    
    /** frame */
    if(configuration.frame.size.width>0 && configuration.frame.size.height>0) adImageView.frame = configuration.frame;
    if(configuration.contentMode) adImageView.contentMode = configuration.contentMode;
    /** webImage */
    if(configuration.imageNameOrURLString.length && XHISURLString(configuration.imageNameOrURLString)){
        [YXLaunchAdCache async_saveImageUrl:configuration.imageNameOrURLString];
        /** 自设图片 */
        if ([self.delegate respondsToSelector:@selector(YXLaunchAd:launchAdImageView:URL:)]) {
            [self.delegate YXLaunchAd:self launchAdImageView:adImageView URL:[NSURL URLWithString:configuration.imageNameOrURLString]];
        }else{
            if(!configuration.imageOption) configuration.imageOption = YXLaunchAdImageDefault;
            XHWeakSelf
            [adImageView xh_setImageWithURL:[NSURL URLWithString:configuration.imageNameOrURLString] placeholderImage:nil GIFImageCycleOnce:configuration.GIFImageCycleOnce options:configuration.imageOption GIFImageCycleOnceFinish:^{
                //GIF不循环,播放完成
                [[NSNotificationCenter defaultCenter] postNotificationName:YXLaunchAdGIFImageCycleOnceFinishNotification object:nil userInfo:@{@"imageNameOrURLString":configuration.imageNameOrURLString}];
                
            } completed:^(UIImage *image,NSData *imageData,NSError *error,NSURL *url){
                if(!error){
                    if (![YXLaunchAd shareLaunchAd].customAdView) {
                        /** skipButton */
                        [self addSkipButtonForConfiguration:configuration];
                        [self startSkipDispathTimer];
                    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                    if ([weakSelf.delegate respondsToSelector:@selector(YXLaunchAd:imageDownLoadFinish:)]) {
                        [weakSelf.delegate YXLaunchAd:self imageDownLoadFinish:image];
                    }
#pragma clang diagnostic pop
                    if ([weakSelf.delegate respondsToSelector:@selector(YXLaunchAd:imageDownLoadFinish:imageData:)]) {
                        [weakSelf.delegate YXLaunchAd:self imageDownLoadFinish:image imageData:imageData];
                    }
                }
            }];
            if(configuration.imageOption == YXLaunchAdImageCacheInBackground){
                /** 缓存中未有 */
                if(![YXLaunchAdCache checkImageInCacheWithURL:[NSURL URLWithString:configuration.imageNameOrURLString]]){
                    [self removeAndAnimateDefault]; return; /** 完成显示 */
                }
            }
        }
    }else{
        if(configuration.imageNameOrURLString.length){
            NSData *data = XHDataWithFileName(configuration.imageNameOrURLString);
            if(XHISGIFTypeWithData(data)){
                YXFLAnimatedImage *image = [YXFLAnimatedImage animatedImageWithGIFData:data];
                adImageView.animatedImage = image;
                adImageView.image = nil;
                __weak typeof(adImageView) w_adImageView = adImageView;
                adImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
                    if(configuration.GIFImageCycleOnce){
                        [w_adImageView stopAnimating];
                        YXLaunchAdLog(@"GIF不循环,播放完成");
                        [[NSNotificationCenter defaultCenter] postNotificationName:YXLaunchAdGIFImageCycleOnceFinishNotification object:@{@"imageNameOrURLString":configuration.imageNameOrURLString}];
                    }
                };
            }else{
                adImageView.animatedImage = nil;
                adImageView.image = [UIImage imageWithData:data];
            }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            if ([self.delegate respondsToSelector:@selector(YXLaunchAd:imageDownLoadFinish:)]) {
                [self.delegate YXLaunchAd:self imageDownLoadFinish:[UIImage imageWithData:data]];
            }
#pragma clang diagnostic pop
        }else{
            //            YXLaunchAdLog(@"未设置广告图片");
        }
    }
    /** skipButton */
    [self addSkipButtonForConfiguration:configuration];
    [self startSkipDispathTimer];
    /** customView */
    if(configuration.subViews.count>0)  [self addSubViews:configuration.subViews];
    XHWeakSelf
    adImageView.click = ^(CGPoint point) {
        [weakSelf clickAndPoint:point];
    };
}

- (YXLaunchAdButton *)skipButton
{
    if (!_skipButton) {
        
        if(!self.imageAdConfiguration.duration) self.imageAdConfiguration.duration = 5;
        if(!self.imageAdConfiguration.skipButtonType) self.imageAdConfiguration.skipButtonType = SkipTypeTimeText;
        
        
        _skipButton = [[YXLaunchAdButton alloc] initWithSkipType:self.imageAdConfiguration.skipButtonType];
        [_skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_skipButton setTitleWithSkipType:self.imageAdConfiguration.skipButtonType duration:self.imageAdConfiguration.duration];
    }
    return _skipButton;
}

-(void)addSkipButtonForConfiguration:(YXLaunchAdConfiguration *)configuration{
    if(!configuration.duration) configuration.duration = 5;
    if(!configuration.skipButtonType) configuration.skipButtonType = SkipTypeTimeText;
    if(configuration.customSkipView){
        [_adWindow addSubview:configuration.customSkipView];
    }else{
        if(_skipButton == nil){
            _skipButton = [[YXLaunchAdButton alloc] initWithSkipType:configuration.skipButtonType];
            _skipButton.hidden = YES;
            [_skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        [_adWindow addSubview:_skipButton];
        [_skipButton setTitleWithSkipType:configuration.skipButtonType duration:configuration.duration];
    }
}

/**视频*/
-(void)setupVideoAdForConfiguration:(YXLaunchVideoAdConfiguration *)configuration{
    if(_adWindow ==nil) return;
    [self removeSubViewsExceptLaunchAdImageView];
    if(!_adVideoView){
        _adVideoView = [[YXLaunchAdVideoView alloc] init];
    }
    [_adWindow addSubview:_adVideoView];
    /** frame */
    if(configuration.frame.size.width>0&&configuration.frame.size.height>0) _adVideoView.frame = configuration.frame;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if(configuration.scalingMode) _adVideoView.videoScalingMode = configuration.scalingMode;
#pragma clang diagnostic pop
    if(configuration.videoGravity) _adVideoView.videoGravity = configuration.videoGravity;
    _adVideoView.videoCycleOnce = configuration.videoCycleOnce;
    if(configuration.videoCycleOnce){
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            YXLaunchAdLog(@"video不循环,播放完成");
            [[NSNotificationCenter defaultCenter] postNotificationName:YXLaunchAdVideoCycleOnceFinishNotification object:nil userInfo:@{@"videoNameOrURLString":configuration.videoNameOrURLString}];
        }];
    }
    /** video 数据源 */
    if(configuration.videoNameOrURLString.length && XHISURLString(configuration.videoNameOrURLString)){
        [YXLaunchAdCache async_saveVideoUrl:configuration.videoNameOrURLString];
        NSURL *pathURL = [YXLaunchAdCache getCacheVideoWithURL:[NSURL URLWithString:configuration.videoNameOrURLString]];
        if(pathURL){
            if ([self.delegate respondsToSelector:@selector(YXLaunchAd:videoDownLoadFinish:)]) {
                [self.delegate YXLaunchAd:self videoDownLoadFinish:pathURL];
            }
            _adVideoView.contentURL = pathURL;
            _adVideoView.muted = configuration.muted;
            [_adVideoView.videoPlayer.player play];
        }else{
            XHWeakSelf
            [[YXLaunchAdDownloader sharedDownloader] downloadVideoWithURL:[NSURL URLWithString:configuration.videoNameOrURLString] progress:^(unsigned long long total, unsigned long long current) {
                if ([weakSelf.delegate respondsToSelector:@selector(YXLaunchAd:videoDownLoadProgress:total:current:)]) {
                    [weakSelf.delegate YXLaunchAd:self videoDownLoadProgress:current/(float)total total:total current:current];
                }
            }  completed:^(NSURL * _Nullable location, NSError * _Nullable error){
                if(!error){
                    if ([weakSelf.delegate respondsToSelector:@selector(YXLaunchAd:videoDownLoadFinish:)]){
                        [weakSelf.delegate YXLaunchAd:self videoDownLoadFinish:location];
                    }
                }
            }];
            /***视频缓存,提前显示完成 */
            [self removeAndAnimateDefault]; return;
        }
    }else{
        if(configuration.videoNameOrURLString.length){
            NSURL *pathURL = nil;
            NSURL *cachePathURL = [[NSURL alloc] initFileURLWithPath:[YXLaunchAdCache videoPathWithFileName:configuration.videoNameOrURLString]];
            //若本地视频未在沙盒缓存文件夹中
            if (![YXLaunchAdCache checkVideoInCacheWithFileName:configuration.videoNameOrURLString]) {
                /***如果不在沙盒文件夹中则将其复制一份到沙盒缓存文件夹中/下次直接取缓存文件夹文件,加快文件查找速度 */
                NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:configuration.videoNameOrURLString withExtension:nil];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSFileManager defaultManager] copyItemAtURL:bundleURL toURL:cachePathURL error:nil];
                });
                pathURL = bundleURL;
            }else{
                pathURL = cachePathURL;
            }
            
            if(pathURL){
                if ([self.delegate respondsToSelector:@selector(YXLaunchAd:videoDownLoadFinish:)]) {
                    [self.delegate YXLaunchAd:self videoDownLoadFinish:pathURL];
                }
                _adVideoView.contentURL = pathURL;
                _adVideoView.muted = configuration.muted;
                [_adVideoView.videoPlayer.player play];
                
            }else{
                YXLaunchAdLog(@"Error:广告视频未找到,请检查名称是否有误!");
            }
        }else{
            YXLaunchAdLog(@"未设置广告视频");
        }
    }
    /** skipButton */
    [self addSkipButtonForConfiguration:configuration];
    [self startSkipDispathTimer];
    /** customView */
    if(configuration.subViews.count>0) [self addSubViews:configuration.subViews];
    XHWeakSelf
    _adVideoView.click = ^(CGPoint point) {
        [weakSelf clickAndPoint:point];
    };
}

#pragma mark - add subViews
-(void)addSubViews:(NSArray *)subViews{
    [subViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [self->_adWindow addSubview:view];
    }];
}

#pragma mark - set

- (void)setCusAdConfi:(YXLaunchImageAdConfiguration*)imageAdConfiguration
{
    
    _imageAdConfiguration = imageAdConfiguration;
    
    _launchAdType = YXLaunchAdTypeImage;
    
    if(_adWindow == nil) return;
    
    if (self.bottomView) {
        [_adWindow addSubview:self.bottomView];
    }
}

-(void)setImageAdConfiguration:(YXLaunchImageAdConfiguration *)imageAdConfiguration{
    _imageAdConfiguration = imageAdConfiguration;
    _launchAdType = YXLaunchAdTypeImage;
    [self setupImageAdForConfiguration:imageAdConfiguration];
}

- (void)addCustomAdViewConfiguration:(YXLaunchImageAdConfiguration *)imageAdConfiguration{
    _imageAdConfiguration = imageAdConfiguration;
    _launchAdType = YXLaunchAdTypeImage;
    [self setupCustomAdViewConfiguration:imageAdConfiguration];
}

-(void)setVideoAdConfiguration:(YXLaunchVideoAdConfiguration *)videoAdConfiguration{
    _videoAdConfiguration = videoAdConfiguration;
    _launchAdType = YXLaunchAdTypeVideo;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupVideoAdForConfiguration:videoAdConfiguration];
    });
}

-(void)setWaitDataDuration:(NSInteger)waitDataDuration{
    _waitDataDuration = waitDataDuration;
    [self setupLaunchAd];
    /** 数据等待 */
    [self startWaitDataDispathTiemr];
}

#pragma mark - Action
-(void)skipButtonClick{
    
    DISPATCH_SOURCE_CANCEL_SAFE(self->_skipTimer);
    if ([self.delegate respondsToSelector:@selector(skipBtnClicked)]) {
        [self.delegate skipBtnClicked];
    }
    [self removeAndAnimated:YES];
}

-(void)removeAndAnimated:(BOOL)animated{
    if(animated){
        [self removeAndAnimate];
    }else{
        [self remove];
    }
}

-(void)clickAndPoint:(CGPoint)point{
    self.clickPoint = point;
    YXLaunchAdConfiguration * configuration = [self commonConfiguration];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self.delegate respondsToSelector:@selector(YXLaunchAd:clickAndOpenURLString:)]) {
        [self.delegate YXLaunchAd:self clickAndOpenURLString:configuration.openURLString];
        [self removeAndAnimateDefault];
    }
    if ([self.delegate respondsToSelector:@selector(YXLaunchAd:clickAndOpenURLString:clickPoint:)]) {
        [self.delegate YXLaunchAd:self clickAndOpenURLString:configuration.openURLString clickPoint:point];
        [self removeAndAnimateDefault];
    }
#pragma clang diagnostic pop
    if ([self.delegate respondsToSelector:@selector(YXLaunchAd:clickAndOpenModel:clickPoint:)]) {
        [self.delegate YXLaunchAd:self clickAndOpenModel:configuration.openModel clickPoint:point];
        [self removeAndAnimateDefault];
    }
}

-(YXLaunchAdConfiguration *)commonConfiguration{
    YXLaunchAdConfiguration *configuration = nil;
    switch (_launchAdType) {
        case YXLaunchAdTypeVideo:
            configuration = _videoAdConfiguration;
            break;
        case YXLaunchAdTypeImage:
            configuration = _imageAdConfiguration;
            break;
        default:
            break;
    }
    return configuration;
}

-(void)startWaitDataDispathTiemr{
    __block NSInteger duration = defaultWaitDataDuration;
    if(_waitDataDuration) duration = _waitDataDuration;
    _waitDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    NSTimeInterval period = 1.0;
    dispatch_source_set_timer(_waitDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_waitDataTimer, ^{
        if(duration<0){
            DISPATCH_SOURCE_CANCEL_SAFE(self->_waitDataTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:YXLaunchAdWaitDataDurationArriveNotification object:nil];
                if (self.delegate && [self.delegate respondsToSelector:@selector(YXLaunchAdShowFailed)]) {
                    [self.delegate YXLaunchAdShowFailed];
                }
                [self removeOnly];
                return ;
            });
        }
        duration--;
    });
    dispatch_resume(_waitDataTimer);
}
- (void)cancleWait
{
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
    
}
- (void)cancleSkip
{
    DISPATCH_SOURCE_CANCEL_SAFE(_skipTimer);
    
}
-(void)startSkipDispathTimer{
    YXLaunchAdConfiguration * configuration = [self commonConfiguration];
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
    if(!configuration.skipButtonType) configuration.skipButtonType = SkipTypeTimeText;//默认
    __block NSInteger duration = 5;//默认
    if(configuration.duration) duration = configuration.duration;
    if(configuration.skipButtonType == SkipTypeRoundProgressTime || configuration.skipButtonType == SkipTypeRoundProgressText){
        [_skipButton startRoundDispathTimerWithDuration:duration];
    }
    NSTimeInterval period = 1.0;
    _skipTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_skipTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_skipTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(YXLaunchAd:customSkipView:duration:)]) {
                if (duration > 0) {
                    [self.delegate YXLaunchAd:self customSkipView:configuration.customSkipView duration:duration];
                }
            }
            if(!configuration.customSkipView){
                if (duration > 0) {
                    [self->_skipButton setTitleWithSkipType:configuration.skipButtonType duration:duration];
                }
            }
            if(duration==1){
                DISPATCH_SOURCE_CANCEL_SAFE(self->_skipTimer);
                [self removeAndAnimate]; return ;
            }
            duration--;
        });
    });
    dispatch_resume(_skipTimer);
}

-(void)removeAndAnimate{
    
    YXLaunchAdConfiguration * configuration = [self commonConfiguration];
    CGFloat duration = showFinishAnimateTimeDefault;
    if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
    switch (configuration.showFinishAnimate) {
        case ShowFinishAnimateNone:{
            [self removeAndAnimateDefault];
        }
            break;
        case ShowFinishAnimateFadein:{
            [UIView transitionWithView:_adWindow duration:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_adWindow.transform = CGAffineTransformMakeScale(1.5, 1.5);
                self->_adWindow.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateLite:{
            [UIView transitionWithView:_adWindow duration:duration options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->_adWindow.transform = CGAffineTransformMakeScale(1.5, 1.5);
                self->_adWindow.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateFlipFromLeft:{
            [UIView transitionWithView:_adWindow duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                self->_adWindow.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateFlipFromBottom:{
            [UIView transitionWithView:_adWindow duration:duration options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                self->_adWindow.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateCurlUp:{
            [UIView transitionWithView:_adWindow duration:duration options:UIViewAnimationOptionTransitionCurlUp animations:^{
                self->_adWindow.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        default:{
            [self removeAndAnimateDefault];
        }
            break;
    }
}

- (void)failedRemove
{
    dispatch_async(dispatch_get_main_queue(), ^{
        YXLaunchAdConfiguration * configuration = [self commonConfiguration];
        CGFloat duration = showFinishAnimateTimeDefault;
        if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
        [UIView transitionWithView:self->_adWindow duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            
        } completion:^(BOOL finished) {
            self->_adWindow.alpha = 0;
            [self removeOnly];
        }];
    }) ;
}

-(void)removeAndOnly{
    dispatch_async(dispatch_get_main_queue(), ^{
        YXLaunchAdConfiguration * configuration = [self commonConfiguration];
        CGFloat duration = showFinishAnimateTimeDefault;
        if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
        [UIView transitionWithView:self->_adWindow duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            self->_adWindow.frame = ({
                CGRect frame;
                frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                frame;
            });
        } completion:^(BOOL finished) {
            self->_adWindow.alpha = 0;
            [self removeOnly];
        }];
    }) ;
    
}
-(void)removeAndAnimateDefault{
    YXLaunchAdConfiguration * configuration = [self commonConfiguration];
    CGFloat duration = showFinishAnimateTimeDefault;
    if(configuration.showFinishAnimateTime>0) duration = configuration.showFinishAnimateTime;
    [UIView transitionWithView:_adWindow duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self->_adWindow.frame = ({
            CGRect frame;
            frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            frame;
        });
    } completion:^(BOOL finished) {
        self->_adWindow.alpha = 0;
        [self remove];
    }];
}
-(void)removeOnly{
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer)
    DISPATCH_SOURCE_CANCEL_SAFE(_skipTimer)
    REMOVE_FROM_SUPERVIEW_SAFE(_skipButton)
    if(_launchAdType==YXLaunchAdTypeVideo){
        if(_adVideoView){
            [_adVideoView stopVideoPlayer];
            REMOVE_FROM_SUPERVIEW_SAFE(_adVideoView)
        }
    }
    if(_adWindow){
        [_adWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            REMOVE_FROM_SUPERVIEW_SAFE(obj)
        }];
        _adWindow.hidden = YES;
        _adWindow = nil;
    }
}

-(void)remove{
    [self removeOnly];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self.delegate respondsToSelector:@selector(YXLaunchShowFinish:)]) {
        [self.delegate YXLaunchShowFinish:self];
    }
#pragma clang diagnostic pop
    if (self.delegate && [ self.delegate respondsToSelector:@selector(YXLaunchAdShowFinish:)]) {
        [self.delegate YXLaunchAdShowFinish:self];
    }
}

-(void)removeSubViewsExceptLaunchAdImageView{
    [_adWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[YXLaunchImageView class]]){
            REMOVE_FROM_SUPERVIEW_SAFE(obj)
        }
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

