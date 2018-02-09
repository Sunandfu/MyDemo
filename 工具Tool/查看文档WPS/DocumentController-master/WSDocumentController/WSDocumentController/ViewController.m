//
//  ViewController.m
//  DocumentController
//
//  Created by iMac on 16/10/12.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UIDocumentInteractionControllerDelegate> {
    /*
     UIDocumentInteractionController是iOS 很早就出来的一个功能。但由于平时很少用到，压根就没有听说过它。而我们忽略的缺是一个功能强大的”文档阅读器”。
     UIDocumentInteractionController主要由两个功能，一个是文件预览，另一个就是调用iPhoneh里第三方相关的app打开文档（注意这里不是根据url scheme 进行识别，而是苹果的自动识别）
     */
    UIDocumentInteractionController *_documentController; //文档交互控制器
}

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *btnTitleArr = @[@"预览",@"其他应用打开"];
    for (NSInteger i = 0; i<2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 100+i*100, kScreenWidth-40, 40);
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        if (i == 0) {
            [btn addTarget:self action:@selector(previewClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [btn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    
    
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    //注意：此处要求的控制器，必须是它的页面view，已经显示在window之上了
    return self.navigationController;
}

//预览
- (void)previewClick:(UIButton *)btn {
    //初始化文档交互
    //准备文档的Url
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"haha.pdf" withExtension:nil];
    
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    [_documentController setDelegate:self];
    
    //当前APP打开  需实现协议方法才可以完成预览功能
    [_documentController presentPreviewAnimated:YES];
    
}

//第三方打开 手机中安装有可以打开此格式的软件都可以打开
- (void)openClick:(UIButton *)btn {
    
    //初始化文档交互
    //准备文档的Url
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"haha.pdf" withExtension:nil];
    
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    [_documentController setDelegate:self];
    
    [_documentController presentOpenInMenuFromRect:btn.frame inView:self.view animated:YES];
    
}




@end
