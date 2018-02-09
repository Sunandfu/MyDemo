# DocumentController
文档查看器，查看doc、ppt、docx、pdf、xls格式文件


# PhotoShoot
![image](https://github.com/Zws-China/.../blob/master/1.png)


# How To Use

```ruby
/*
UIDocumentInteractionController是iOS 很早就出来的一个功能。但由于平时很少用到，压根就没有听说过它。而我们忽略的缺是一个功能强大的”文档阅读器”。
UIDocumentInteractionController主要由两个功能，一个是文件预览，另一个就是调用iPhoneh里第三方相关的app打开文档（注意这里不是根据url scheme 进行识别，而是苹果的自动识别）
*/
UIDocumentInteractionController *_documentController; //文档交互控制器


NSURL *url = [[NSBundle mainBundle] URLForResource:@"haha.pdf" withExtension:nil];

_documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
[_documentController setDelegate:self];

//当前APP打开  需实现协议方法才可以完成预览功能
[_documentController presentPreviewAnimated:YES];

//第三方打开 手机中安装有可以打开此格式的软件都可以打开
[_documentController presentOpenInMenuFromRect:btn.frame inView:self.view animated:YES];


```