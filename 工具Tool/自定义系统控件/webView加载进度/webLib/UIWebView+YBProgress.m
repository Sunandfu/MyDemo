//
//  UIWebView+YBProgress.m
//  testProgress
//
//  Created by LYB on 16/6/4.
//  Copyright © 2016年 LYB. All rights reserved.
//

#import "UIWebView+YBProgress.h"
#import <objc/runtime.h>

NSString *yb_completeRPCURLPath = @"/ybwebviewprogressproxy/complete";

const float YBInitialProgressValue = 0.1f;
const float YBInteractiveProgressValue = 0.5f;
const float YBFinalProgressValue = 0.9f;

@implementation YBWebViewProgress
{
    NSUInteger _loadingCount;
    NSUInteger _maxLoadCount;
    NSURL *_currentURL;
    BOOL _interactive;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxLoadCount = _loadingCount = 0;
        _interactive = NO;
    }
    return self;
}

- (void)startProgress
{
    if (_progress < YBInitialProgressValue) {
        [self setProgress:YBInitialProgressValue];
    }
}

- (void)incrementProgress
{
    float progress = self.progress;
    float maxProgress = _interactive ? YBFinalProgressValue : YBInteractiveProgressValue;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

/**重置*/
- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

/**重写set*/
- (void)setProgress:(float)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        if ([_progressDelegate respondsToSelector:@selector(webViewProgress:updateProgress:)]) {
            [_progressDelegate webViewProgress:self updateProgress:progress];
        }
        if (self.YBWebViewProgressBlock) {
            self.YBWebViewProgressBlock (progress);
        }
    }
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

#pragma mark  - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.path isEqualToString:yb_completeRPCURLPath]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL ret = YES;
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTPOrLocalFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    if (ret && !isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        _currentURL = request.URL;
        [self reset];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewProxyDelegate webViewDidStartLoad:webView];
    }
    
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, yb_completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, yb_completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if ((complete && isNotRedirect) || error) {
        [self completeProgress];
    }
}
@end






@implementation YBWebViewProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureViews];
}

-(void)configureViews
{
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
    if ([UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(setTintColor:)] && UIApplication.sharedApplication.delegate.window.tintColor) {
        tintColor = UIApplication.sharedApplication.delegate.window.tintColor;
    }
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

-(void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    _progressBarView.backgroundColor = tintColor;
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        _progressBarView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = _progressBarView.frame;
            frame.size.width = 0;
            _progressBarView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 1.0;
        } completion:nil];
    }
}
@end







@implementation UIWebView (YBProgress)

- (void)setProgressView:(YBWebViewProgressView *)progressView
{
    objc_setAssociatedObject(self, @selector(progressView), progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YBWebViewProgressView *)progressView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setProgressProxy:(YBWebViewProgress *)progressProxy
{
    objc_setAssociatedObject(self, @selector(progressProxy), progressProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YBWebViewProgress *)progressProxy
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYBProgressBlock:(void (^)(float))YBProgressBlock
{
    objc_setAssociatedObject(self, @selector(YBProgressBlock), YBProgressBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(float))YBProgressBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYb_tintColor:(UIColor *)yb_tintColor
{
    objc_setAssociatedObject(self, @selector(yb_tintColor), yb_tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.progressView.tintColor = yb_tintColor;
}

- (UIColor *)yb_tintColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yb_reset
{
    [self.progressProxy reset];
}

- (void)yb_addProgressViewUsingBlock:(void (^) (float progress))progressBack
{
    for (UIView *oldView in self.subviews) {
        if ([oldView isKindOfClass:YBWebViewProgressView.class]) {
            [oldView removeFromSuperview];
        }
    }
    self.progressProxy = [[YBWebViewProgress alloc] init];
    self.delegate = self.progressProxy;
    self.progressProxy.progressDelegate = self;
    self.progressProxy.webViewProxyDelegate = self;
    
    self.progressView = [[YBWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 3)];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.progressView];
    
    if (self.YBProgressBlock != progressBack) {
        self.YBProgressBlock = progressBack;
    }
    [self.progressView setProgress:0.0f animated:NO];
}

+ (void)swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load
{
    [super load];
    [self swizzleSelector:@selector(init) withSelector:@selector(init_ybProgress)];
    [self swizzleSelector:@selector(initWithFrame:) withSelector:@selector(initWithFrame_ybProgress:)];
    [self swizzleSelector:@selector(initWithCoder:) withSelector:@selector(initWithCoder_ybProgress:)];
    [self swizzleSelector:@selector(awakeFromNib) withSelector:@selector(awakeFromNib_ybProgress)];
}

- (instancetype)init_ybProgress
{
    self = [self init_ybProgress];
    if (self) {
        [self yb_addProgressViewUsingBlock:nil];
    }
    return self;
}

- (instancetype)initWithFrame_ybProgress:(CGRect)frame
{
    self = [self initWithFrame_ybProgress:frame];
    if (self) {
        [self yb_addProgressViewUsingBlock:nil];
    }
    return self;
}

- (instancetype)initWithCoder_ybProgress:(NSCoder *)coder
{
    self = [self initWithCoder_ybProgress:coder];
    if (self) {
        [self yb_addProgressViewUsingBlock:nil];
    }
    return self;
}

- (void)awakeFromNib_ybProgress
{
    [self awakeFromNib_ybProgress];
    [self yb_addProgressViewUsingBlock:nil];
}

#pragma mark - YBWebViewProgressDelegate
-(void)webViewProgress:(YBWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
    if (self.YBProgressBlock) {
        self.YBProgressBlock (progress);
    }
}

@end
