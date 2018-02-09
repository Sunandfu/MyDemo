//
//  MPViewController2.m
//  MPWebViewLongTap
//
//  Created by Plum on 16/4/26.
//  Copyright © 2016年 ManPao. All rights reserved.
//

#import "MPViewController2.h"
#import "UnpreventableUILongPressGestureRecognizer.h"
#import "UIWebView+WebViewAdditions.h"
#import <JavaScriptCore/JavaScriptCore.h> 
@interface MPViewController2 ()<UIWebViewDelegate,UIActionSheetDelegate>
{
    UIWebView *webView;
    UIActionSheet *_actionActionSheet;
    NSString *selectedLinkURL,*selectedImageURL;
}
@end

@implementation MPViewController2
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initWebView];
}

- (void)initWebView{
    
    
    //添加一个webview
    webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scrollView.clipsToBounds = NO;
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES;
    [webView setUserInteractionEnabled:YES];
    [webView setOpaque:NO];
    [self.view addSubview:webView];
    
    webView.scrollView.scrollsToTop = YES;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"http://mp.weixin.qq.com/s?__biz=MzA3MDk4NzMzNg==&mid=2651701608&idx=1&sn=4e8b80cae1f7df434453edede00899f3&scene=0#wechat_redirect"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    
    UnpreventableUILongPressGestureRecognizer *longPressRecognizer = [[UnpreventableUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
     longPressRecognizer.allowableMovement = 20;
     longPressRecognizer.minimumPressDuration = 1.0f;
     [webView addGestureRecognizer:longPressRecognizer];
    
}

#pragma mark --- webview delegate ---
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    return YES;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
    }else {
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
}
#pragma mark -
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
       
                CGPoint pt = [gestureRecognizer locationInView:webView];
       
               // convert point from view to HTML coordinate system
               // 뷰의 포인트 위치를 HTML 좌표계로 변경한다.
               CGSize viewSize = [webView frame].size;
                CGSize windowSize = [webView windowSize];
                 CGFloat f = windowSize.width / viewSize.width;
       
               if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0) {
                         pt.x = pt.x * f;
                        pt.y = pt.y * f;
                   } else {
                            // On iOS 4 and previous, document.elementFromPoint is not taking
                          // offset into account, we have to handle it
                           CGPoint offset = [webView scrollOffset];
                           pt.x = pt.x * f + offset.x;
                           pt.y = pt.y * f + offset.y;
                      }
        
                [self openContextualMenuAt:pt];
            }
  }



 - (void)openContextualMenuAt:(CGPoint)pt{
        // Load the JavaScript code from the Resources and inject it into the web page
         NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Naving" ofType:@"bundle"]];
         NSString *path = [bundle pathForResource:@"JSTools" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView stringByEvaluatingJavaScriptFromString:jsCode];
    
        // get the Tags at the touch location
         NSString *tags = [webView stringByEvaluatingJavaScriptFromString:
                                                  [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%li,%li);",(long)pt.x,(long)pt.y]];
    
         NSString *tagsHREF = [webView stringByEvaluatingJavaScriptFromString:
                                                          [NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%li,%li);",(long)pt.x,(long)pt.y]];
    
         NSString *tagsSRC = [webView stringByEvaluatingJavaScriptFromString:
                                                        [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%li,%li);",(long)pt.x,(long)pt.y]];
    
        NSLog(@"tags : %@",tags);
         NSLog(@"href : %@",tagsHREF);
        NSLog(@"src : %@",tagsSRC);
    
         if (!_actionActionSheet) {
                _actionActionSheet = nil;
            }
        _actionActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                                       delegate:self
                                                                              cancelButtonTitle:nil
                                                                          destructiveButtonTitle:nil
                                                                              otherButtonTitles:nil];
    
        selectedLinkURL = @"";
        selectedImageURL = @"";
    
         // If an image was touched, add image-related buttons.
        if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
                selectedImageURL = tagsSRC;
        
                 if (_actionActionSheet.title == nil) {
                         _actionActionSheet.title = tagsSRC;
                    }
       
                [_actionActionSheet addButtonWithTitle:@"Save Image"];
                 [_actionActionSheet addButtonWithTitle:@"Copy Image"];
            }
        // If a link is pressed add image buttons.
        if ([tags rangeOfString:@",A,"].location != NSNotFound){
               selectedLinkURL = tagsHREF;
       
                _actionActionSheet.title = tagsHREF;
                 [_actionActionSheet addButtonWithTitle:@"Open Link"];
                [_actionActionSheet addButtonWithTitle:@"Copy Link"];
           }
    
         if (_actionActionSheet.numberOfButtons > 0) {
                [_actionActionSheet addButtonWithTitle:@"Cancel"];
                 _actionActionSheet.cancelButtonIndex = (_actionActionSheet.numberOfButtons-1);
        
        
               [_actionActionSheet showInView:webView];
            }
  
}
#pragma UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open Link"]){
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:selectedLinkURL]]];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy Link"]){
        [[UIPasteboard generalPasteboard] setString:selectedLinkURL];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy Image"]){
        [[UIPasteboard generalPasteboard] setString:selectedImageURL];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save Image"]){
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(saveImageURL:) object:selectedImageURL];
        [queue addOperation:operation];
        //[operation release];
    }
}

-(void)saveImageURL:(NSString*)url{
    [self performSelectorOnMainThread:@selector(showStartSaveAlert)
                           withObject:nil
                        waitUntilDone:YES];
    
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
    
    [self performSelectorOnMainThread:@selector(showFinishedSaveAlert)
                           withObject:nil
                        waitUntilDone:YES];
}

@end
